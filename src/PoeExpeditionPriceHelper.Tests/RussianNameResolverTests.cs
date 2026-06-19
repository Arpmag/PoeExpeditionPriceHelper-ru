using PoeExpeditionPriceHelper;

namespace PoeExpeditionPriceHelper.Tests;

public class RussianNameResolverTests
{
    [Theory]
    [InlineData("журнал экспедиции", "expedition logbook")]
    [InlineData("пустотный расплав", "void flux")]
    [InlineData("жгучий расплав", "blazing flux")]
    [InlineData("студёный расплав", "chilling flux")]
    [InlineData("искрящий расплав", "crackling flux")]
    [InlineData("сфера узазы", "perfect flux")]
    [InlineData("диковинные монеты", "exotic coinage")]
    [InlineData("сага альдура", "aldur s saga")]
    [InlineData("сага медведя", "medved s saga")]
    [InlineData("сага олрота", "olroth s saga")]
    [InlineData("страсть альдура", "passion of aldur")]
    [InlineData("предательство альдура", "betrayal of aldur")]
    [InlineData("гнев альдура", "ire of aldur")]
    [InlineData("дыхание альдура", "breath of aldur")]
    [InlineData("триумф серли", "serle s triumph")]
    [InlineData("изобретательность астрид", "astrid s creativity")]
    [InlineData("озарение кадигана", "cadigan s epiphany")]
    [InlineData("охота колра", "kolr s hunt")]
    [InlineData("резня вораны", "vorana s carnage")]
    [InlineData("сила трада", "thrud s might")]
    [InlineData("присмотр медведя", "medved s tending")]
    [InlineData("мрачность катлы", "katla s gloom")]
    [InlineData("сидерий утреда", "uhtred s sidereus")]
    [InlineData("наследие альдура", "aldur s legacy")]
    [InlineData("знак круга медведя", "medved s crest of the circle")]
    [InlineData("знак солнца олрота", "olroth s crest of the sun")]
    [InlineData("журнал вораны", "expedition logbook")]
    public void ToEnglishKey_ExpeditionItems(string ru, string en)
    {
        Assert.Equal(en, RussianNameResolver.ToEnglishKey(ru));
    }

    [Theory]
    [InlineData("чародейский расплав уровень 19", "thaumaturgic flux level 19")]
    [InlineData("чародейский расплав (уровень 20)", "thaumaturgic flux level 20")]
    public void ToEnglishKey_ThaumaturgicFlux(string ru, string en)
    {
        Assert.Equal(en, RussianNameResolver.ToEnglishKey(ru));
    }

    [Theory]
    [InlineData("неогранённый камень духа уровень 19", "uncut spirit gem level 19")]
    [InlineData("неограненный камень умения уровень 7", "uncut skill gem level 7")]
    public void ToEnglishKey_UncutGems(string ru, string en)
    {
        Assert.Equal(en, RussianNameResolver.ToEnglishKey(ru));
    }

    [Theory]
    [InlineData("сфера астромантии (3)", "artificer s orb")]
    [InlineData("большая руна мощи (1)", "greater robust rune")]
    [InlineData("руна мощи (1)", "robust rune")]
    [InlineData("большая руна искусности", "greater adept rune")]
    [InlineData("руна решительности", "resolve rune")]
    [InlineData("экспансивный сплав", "expansive alloy")]
    [InlineData("защитный сплав", "protective alloy")]
    [InlineData("сфера алхимии", "orb of alchemy")]
    [InlineData("брльшая руна решительности", "greater resolve rune")]
    public void ToEnglishKey_RuneshapeCombinations(string ru, string en)
    {
        Assert.Equal(en, RussianNameResolver.ToEnglishKey(ru));
    }

    [Fact]
    public void NormalizeName_PreservesCyrillic()
    {
        Assert.Equal("журнал экспедиции", OcrScanner.NormalizeName("Журнал Экспедиции"));
    }
}
