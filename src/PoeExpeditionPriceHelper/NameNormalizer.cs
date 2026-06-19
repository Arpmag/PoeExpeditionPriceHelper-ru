using System.Text.RegularExpressions;

namespace PoeExpeditionPriceHelper;

// Shared name normalization used by both OcrScanner (OCR text → key) and PriceRepository
// (API name → key). Extracted so both paths use identical logic and a single set of
// pre-compiled regex instances.
internal static class NameNormalizer
{
    // \p{L} keeps Cyrillic letters (Russian game client); \w is ASCII-only.
    private static readonly Regex NonWordSpace = new(@"[^\p{L}\s]", RegexOptions.Compiled);
    private static readonly Regex MultiSpace = new(@"\s+", RegexOptions.Compiled);

    public static string Normalize(string text)
    {
        var s = text.ToLowerInvariant().Replace('ё', 'е');
        s = NonWordSpace.Replace(s, " ");
        s = MultiSpace.Replace(s, " ");
        return s.Trim();
    }
}
