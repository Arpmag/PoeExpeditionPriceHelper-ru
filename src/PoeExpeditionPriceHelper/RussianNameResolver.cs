using System.Reflection;
using Newtonsoft.Json.Linq;

namespace PoeExpeditionPriceHelper;

/// <summary>
/// Maps normalized Russian OCR text (RU game client) to English poe.ninja price keys.
/// Data: poe2db.tw/ru + <c>Data/expedition_aliases.json</c> + <c>Data/game_aliases.json</c>.
/// </summary>
internal static class RussianNameResolver
{
    private static readonly Dictionary<string, string> Aliases = LoadAliases();

    private static readonly string[] CategoryPrefixes =
    [
        "умение", "поддержка", "навык", "дух", "камень",
        "skill", "support", "spirit",
    ];

    private const double FuzzyAliasThreshold = 0.84;

    internal static string PrepareForLookup(string normalizedOcr)
    {
        var s = NormalizeCyrillic(normalizedOcr);
        s = StripCategoryPrefix(s);
        s = StripVendorCostSuffix(s);
        return s.Trim();
    }

    internal static string? ToEnglishKey(string normalizedOcr)
    {
        var s = PrepareForLookup(normalizedOcr);
        if (string.IsNullOrEmpty(s)) return null;

        if (IsMostlyLatin(s)) return s;

        if (Aliases.TryGetValue(s, out var direct)) return direct;

        if (TryResolveUncutGem(s, out var gemKey)) return gemKey;

        if (TryResolveThaumaturgicFlux(s, out var fluxKey)) return fluxKey;

        if (TryResolveAncientRune(s, out var runeKey)) return runeKey;

        if (TryResolveTieredRune(s, out var tieredKey)) return tieredKey;

        if (TryFuzzyAlias(s, out var fuzzyKey)) return fuzzyKey;

        // Longest partial alias contained in OCR text (e.g. "1x жгучий расплав" after strip).
        string? best = null;
        int bestLen = 0;
        foreach (var (ru, en) in Aliases)
        {
            if (s.Contains(ru, StringComparison.Ordinal) && ru.Length > bestLen)
            {
                bestLen = ru.Length;
                best = en;
            }
        }
        return best;
    }

    internal static void RegisterAliases(Dictionary<string, PriceEntry> dict)
    {
        var extras = new List<KeyValuePair<string, PriceEntry>>();
        foreach (var (ru, en) in Aliases)
        {
            if (dict.TryGetValue(en, out var entry))
                extras.Add(new(ru, entry));
        }
        foreach (var (k, v) in extras)
            dict[k] = v;
    }

    internal static bool TryResolveUncutGem(string normalized, out string? key)
    {
        key = null;
        if (!normalized.Contains("камень") && !normalized.Contains("gem")) return false;

        string? type = null;
        if (normalized.Contains("умения") || normalized.Contains("умени")) type = "skill";
        else if (normalized.Contains("духа") || normalized.Contains("дух")) type = "spirit";
        else if (normalized.Contains("поддержки") || normalized.Contains("поддержк")) type = "support";

        if (type is null) return false;

        var lvl = Regex.Match(normalized, @"(?:уровень|level)\s*(\d+)");
        if (!lvl.Success) return true;

        key = $"uncut {type} gem level {lvl.Groups[1].Value}";
        return true;
    }

    private static bool TryResolveThaumaturgicFlux(string normalized, out string? key)
    {
        key = null;
        if (!normalized.Contains("чародейск") && !normalized.Contains("талмутург") &&
            !normalized.Contains("thaumaturgic"))
            return false;

        var lvl = Regex.Match(normalized, @"(?:уровень|level)\s*(\d+)");
        if (!lvl.Success) return false;
        key = $"thaumaturgic flux level {lvl.Groups[1].Value}";
        return true;
    }

    private static bool TryResolveAncientRune(string normalized, out string? key)
    {
        key = null;
        if (!normalized.Contains("древн") && !normalized.Contains("ancient")) return false;
        if (!normalized.Contains("рун")) return false;

        var m = Regex.Match(normalized, @"древн\w*\s+рун\w*\s+(?:из\s+)?(.+)");
        if (!m.Success) return false;
        var tail = MapRuneTail(m.Groups[1].Value.Trim());
        if (string.IsNullOrEmpty(tail)) return false;
        key = $"ancient rune of {tail}";
        return true;
    }

    // poe2db: Малая/Руна/Большая/Безупречная руна {tail}
    private static bool TryResolveTieredRune(string normalized, out string? key)
    {
        key = null;
        if (!normalized.Contains("рун")) return false;

        string tier = "";
        string tail;

        var m = Regex.Match(normalized,
            @"^(?:(мал\w*|lesser)\s+)?(?:(больш\w*|greater)\s+)?(?:(безупречн\w*|perfect)\s+)?рун\w*\s+(.+)$");
        if (!m.Success) return false;

        if (m.Groups[1].Success) tier = "lesser ";
        if (m.Groups[2].Success) tier = "greater ";
        if (m.Groups[3].Success) tier = "perfect ";
        tail = m.Groups[4].Value.Trim();
        if (string.IsNullOrEmpty(tail)) return false;

        if (tier == "greater " && GreaterRuneOfTailMap.TryGetValue(tail, out var ofTail))
        {
            key = $"greater rune of {ofTail}";
            return true;
        }

        var enTail = MapRuneTail(tail);
        if (string.IsNullOrEmpty(enTail) || IsCyrillicHeavy(enTail)) return false;

        key = $"{tier}{enTail} rune".Trim();
        return true;
    }

    private static readonly Dictionary<string, string> GreaterRuneOfTailMap = new(StringComparer.OrdinalIgnoreCase)
    {
        ["стремления"] = "alacrity",
        ["лидерства"] = "leadership",
        ["десятины"] = "tithing",
        ["дворянства"] = "nobility",
    };

    private static readonly Dictionary<string, string> RuneTailMap = new(StringComparer.OrdinalIgnoreCase)
    {
        ["мощи"] = "robust",
        ["искусности"] = "adept",
        ["решительности"] = "resolve",
        ["пустыни"] = "desert",
        ["ледника"] = "glacial",
        ["шторма"] = "storm",
        ["железа"] = "iron",
        ["тела"] = "body",
        ["разума"] = "mind",
        ["перерождения"] = "rebirth",
        ["вдохновения"] = "inspiration",
        ["камня"] = "stone",
        ["видения"] = "vision",
        ["заряда"] = "charging",
        ["барьера"] = "ward",
        ["разложения"] = "decay",
        ["открытия"] = "discovery",
        ["возмездия"] = "retaliation",
        ["разрушения"] = "shattering",
        ["взрыва"] = "detonation",
        ["контроля"] = "control",
        ["враждебности"] = "animosity",
        ["мастерства"] = "prowess",
        ["дуэли"] = "dueling",
        ["орды"] = "the horde",
        ["титана"] = "the titan",
        ["осколков"] = "splinters",
        ["защиты"] = "protection",
        ["жизни"] = "life",
        ["маны"] = "mana",
        ["огня"] = "fire",
        ["холода"] = "cold",
        ["молнии"] = "lightning",
        ["колдовства"] = "witchcraft",
    };

    private static string MapRuneTail(string ruTail) =>
        RuneTailMap.TryGetValue(ruTail, out var mapped) ? mapped : ruTail;

    private static bool TryFuzzyAlias(string s, out string? key)
    {
        key = null;
        if (s.Length < 8) return false;

        string? best = null;
        double bestScore = FuzzyAliasThreshold;
        foreach (var (ru, en) in Aliases)
        {
            if (Math.Abs(ru.Length - s.Length) > 4) continue;
            int dist = ScanEngine.Levenshtein(s, ru);
            double score = 1.0 - (double)dist / Math.Max(s.Length, ru.Length);
            if (score > bestScore)
            {
                bestScore = score;
                best = en;
            }
        }
        key = best;
        return best is not null;
    }

    // Vendor cost in parentheses: "Сфера астромантии (3)" → strip trailing digit.
    private static string StripVendorCostSuffix(string s)
    {
        if (s.Contains("уровень") || s.Contains("level")) return s;
        return Regex.Replace(s, @"\s+\d{1,3}$", "").Trim();
    }

    private static string StripCategoryPrefix(string s)
    {
        foreach (var prefix in CategoryPrefixes)
        {
            if (s.StartsWith(prefix + " ", StringComparison.Ordinal))
                return s[(prefix.Length + 1)..].Trim();
            if (s.StartsWith(prefix + ":", StringComparison.Ordinal))
                return s[(prefix.Length + 1)..].Trim();
        }
        return s;
    }

    private static string NormalizeCyrillic(string s) =>
        s.Replace('ё', 'е').Replace('Ё', 'Е');

    private static bool IsMostlyLatin(string s)
    {
        int latin = 0, cyr = 0;
        foreach (var c in s)
        {
            if (c is >= 'a' and <= 'z') latin++;
            else if (IsCyrillic(c)) cyr++;
        }
        return latin > cyr;
    }

    private static bool IsCyrillicHeavy(string s)
    {
        int cyr = 0;
        foreach (var c in s)
            if (IsCyrillic(c)) cyr++;
        return cyr > 2;
    }

    private static bool IsCyrillic(char c) =>
        c is (>= 'а' and <= 'я') or (>= 'А' and <= 'Я') or 'ё' or 'Ё';

    private static Dictionary<string, string> LoadAliases()
    {
        var result = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        try
        {
            LoadJsonResource("PoeExpeditionPriceHelper.Data.expedition_aliases.json", result);
            LoadJsonResource("PoeExpeditionPriceHelper.Data.game_aliases.json", result);
        }
        catch (Exception ex)
        {
            Console.Error.WriteLine($"[RussianNameResolver] failed to load aliases: {ex.Message}");
        }
        return result;
    }

    private static void LoadJsonResource(string resourceName, Dictionary<string, string> result)
    {
        var asm = Assembly.GetExecutingAssembly();
        string? json = null;
        using (var stream = asm.GetManifestResourceStream(resourceName))
        {
            if (stream is not null)
            {
                using var reader = new StreamReader(stream);
                json = reader.ReadToEnd();
            }
        }
        if (json is null)
        {
            var fileName = resourceName.EndsWith("game_aliases.json", StringComparison.Ordinal)
                ? "game_aliases.json"
                : "expedition_aliases.json";
            var path = Path.Combine(AppContext.BaseDirectory, "Data", fileName);
            if (File.Exists(path)) json = File.ReadAllText(path);
        }
        if (!string.IsNullOrEmpty(json)) MergeJsonAliases(json, result);
    }

    private static void MergeJsonAliases(string json, Dictionary<string, string> result)
    {
        var obj = JObject.Parse(json);
        if (obj["aliases"] is not JObject map) return;
        foreach (var prop in map.Properties())
        {
            var ru = NormalizeCyrillic(prop.Name.ToLowerInvariant());
            var en = prop.Value?.Value<string>();
            if (!string.IsNullOrWhiteSpace(ru) && !string.IsNullOrWhiteSpace(en))
                result[ru] = en;
        }
    }
}
