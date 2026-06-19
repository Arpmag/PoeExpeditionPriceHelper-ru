# PoeExpeditionPriceHelper — журнал изменений (RU fork)

## v2.0.0 (2026-06-19)

Порт на основу [PoeAncientsPriceHelper v2.0.0](https://github.com/pedro-quiterio/PoeAncientsPriceHelper/releases/tag/v2.0.0) от pedro-quiterio.

### Из upstream v2.0.0
- .NET 10, Windows OCR вместо Tesseract (без `tessdata`)
- Захват экрана WGC (GPU) с откатом на GDI
- Кэш разрешения имён, индекс fuzzy-match по длине, параллельная загрузка цен
- Улучшенная стабильность оверлея и сканирования

### Русская локализация (сохранено и адаптировано)
- `RussianNameResolver` + словари `expedition_aliases.json` / `game_aliases.json` (poe2db.tw/ru)
- OCR: приоритет языка **ru-RU** / **ru** (Windows OCR)
- `NameNormalizer` и `OcrScanner`: поддержка кириллицы (`\p{L}`)
- Маппинг RU → EN для Экспедиции, валюты, рун, сплавов, неогранённых камней
- Интерфейс, калибровка и пасхалки оверлея на русском
- Проверка обновлений: репозиторий `Arpmag/PoeExpeditionPriceHelper-ru`

### Требования
- Windows 10/11 с языковым пакетом **Русский** и включённым OCR
- [.NET 10 SDK](https://dotnet.microsoft.com/download) для сборки из исходников
