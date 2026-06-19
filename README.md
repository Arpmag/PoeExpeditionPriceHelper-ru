# Помощник цен Экспедиции PoE 2 · русский клиент

> **Форк оригинального [Poe Ancients Price Helper](https://github.com/pedro-quiterio/PoeAncientsPriceHelper)**  
> Автор оригинала: [**@pedro-quiterio**](https://github.com/pedro-quiterio)  
> Скачать английскую версию (EN client): [**Releases v1.1.8**](https://github.com/pedro-quiterio/PoeAncientsPriceHelper/releases)

Оверлей цен для **Path of Exile 2** с **русским клиентом**. Программа читает список предметов в игре (OCR на русском), подтягивает актуальные цены с [poe.ninja](https://poe.ninja/poe2) и рисует их поверх интерфейса — как в [оригинальной английской версии](https://github.com/pedro-quiterio/PoeAncientsPriceHelper).

Поддерживаются:

- **Экспедиция** — журналы, расплавы, саги, реликты, знаки, артефакты ([poe2db.tw/ru/Expedition](https://poe2db.tw/ru/Expedition))
- **Рунотворческие комбинации** — руны, сферы, сплавы
- **Валюта, руны, веризий** — всё, что есть на бирже poe.ninja

---

## Оригинальный проект (English)

| | |
|---|---|
| **Репозиторий** | https://github.com/pedro-quiterio/PoeAncientsPriceHelper |
| **Релизы / скачать** | https://github.com/pedro-quiterio/PoeAncientsPriceHelper/releases |
| **Автор** | [pedro-quiterio](https://github.com/pedro-quiterio) |
| **Версия-основа** | [v1.1.8](https://github.com/pedro-quiterio/PoeAncientsPriceHelper/releases/tag/v1.1.8) |

Этот форк **не заменяет** оригинал. Если у вас **английский клиент** PoE 2 — используйте [**PoeAncientsPriceHelper**](https://github.com/pedro-quiterio/PoeAncientsPriceHelper/releases).

Спасибо **pedro** за исходный код, оверлей, OCR и интеграцию с poe.ninja.

---

## Что добавлено в русской версии

| Компонент | Оригинал (EN) | Эта версия (RU) |
|-----------|---------------|-----------------|
| OCR Tesseract | `eng` | `rus` |
| Названия предметов | ключи poe.ninja как в игре | словари RU→EN из [poe2db.tw/ru](https://poe2db.tw/ru) |
| Интерфейс | English | Русский |
| Неогранённые камни | `uncut skill gem level N` | `неогранённый камень умения уровень N` |
| Категории цен | Runes, Currency, Verisium, Expedition, UncutGems | те же + маппинг русских названий |

Словари: `src/PoeExpeditionPriceHelper/Data/expedition_aliases.json`, `game_aliases.json`.

---

## Скачать и запустить

1. Скачайте **`PoeExpeditionPriceHelper-vX.Y.Z-win-x64.zip`** на странице [**Releases**](../../releases) этого репозитория.
2. Распакуйте в любую папку.
3. Запустите **`Start.cmd`**. Установка .NET не нужна — сборка self-contained для Windows x64.

> Windows SmartScreen может предупредить (приложение не подписано) — **Подробнее → Выполнить в любом случае**.  
> Антивирус иногда реагирует на библиотеку глобальных горячих клавиш — это ожидаемо для unsigned open-source утилиты (см. [оригинал](https://github.com/pedro-quiterio/PoeAncientsPriceHelper/releases)).

---

## Использование

1. Запустите `Start.cmd`, выберите лигу (например, **Runes of Aldur**).
2. **Сверните окно программы в трей** — чтобы OCR не захватывал текст приложения.
3. **F4** (или «Калибровать область») — обведите **только список предметов** в игре (без иконок слева, без окна программы).
4. **F5** / «Старт» — откройте панель обмена, рунотворческие комбинации или торговцев Экспедиции.

### Горячие клавиши

| Клавиша | Действие |
|---------|----------|
| **F5** | Старт / стоп сканирования |
| **F4** | Калибровка области |
| **F3** | Отладка (рамки OCR, текст строк) |
| **Esc** / **Ctrl+клик** | Скрыть оверлей |

Все три горячие клавиши можно переназначить в окне программы.

---

## Сборка из исходников

Требуется [.NET 8 SDK](https://dotnet.microsoft.com/download/dotnet/8.0).

```powershell
dotnet test PoeExpeditionPriceHelper.sln -c Release
dotnet publish src/PoeExpeditionPriceHelper/PoeExpeditionPriceHelper.csproj `
  -c Release -r win-x64 --self-contained true -o publish
```

---

## Добавление своих названий

Если предмет не распознаётся, добавьте пару **русское имя → английский ключ poe.ninja** в:

- `src/PoeExpeditionPriceHelper/Data/expedition_aliases.json` — Экспедиция
- `src/PoeExpeditionPriceHelper/Data/game_aliases.json` — руны, валюта, сплавы

Или укажите цену вручную в `custom_prices.json` (ключ — нормализованное **русское** имя).

Источник русских названий: [poe2db.tw/ru](https://poe2db.tw/ru)

---

## Технологии

WPF (окно настроек) + WinForms (оверлей), Tesseract OCR (`rus`), .NET 8.  
Архитектура и логика оверлея — из [PoeAncientsPriceHelper](https://github.com/pedro-quiterio/PoeAncientsPriceHelper) by **pedro-quiterio**.

---

## Лицензия и авторство

- **Оригинал:** [PoeAncientsPriceHelper](https://github.com/pedro-quiterio/PoeAncientsPriceHelper) · **pedro-quiterio**
- **Русский форк:** отдельный репозиторий; изменения касаются локализации, OCR и словарей RU→EN.

При публикации форка, пожалуйста, сохраняйте ссылку на [оригинальный репозиторий](https://github.com/pedro-quiterio/PoeAncientsPriceHelper) и [релизы](https://github.com/pedro-quiterio/PoeAncientsPriceHelper/releases).
