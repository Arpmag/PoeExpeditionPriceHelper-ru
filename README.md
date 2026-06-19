# Poe Expedition Price Helper (RU)

Русская версия [**Poe Ancients Price Helper**](https://github.com/pedro-quiterio/PoeAncientsPriceHelper) для **Path of Exile 2** (русский клиент).

Оригинал: [pedro-quiterio/PoeAncientsPriceHelper](https://github.com/pedro-quiterio/PoeAncientsPriceHelper) · [Releases](https://github.com/pedro-quiterio/PoeAncientsPriceHelper/releases)  
**Английский клиент** → скачивайте оригинал, не этот репозиторий.

Оверлей читает список предметов в игре (OCR на русском), подтягивает цены с [poe.ninja](https://poe.ninja/poe2) и рисует их рядом с каждой строкой.

## Features

- **Live prices** с poe.ninja (обновление каждые 30 минут)
- **Экспедиция** — журналы, расплавы, саги, реликты, знаки
- **Рунотворческие комбинации** — руны, сферы, сплавы
- **Стеки** — итог и цена за штуку, например `2 (0.5 за шт.)`
- **Неогранённые камни** — по точному типу и уровню
- **Калибровка один раз** — обвести список предметов в игре
- **Горячие клавиши:** `F5` старт/стоп · `F4` калибровка · `F3` отладка · `Esc` / `Ctrl+клик` скрыть
- **Сворачивание в трей** — сканирование продолжается в фоне

## Download & run

Скачайте последний `PoeExpeditionPriceHelper-vX.Y.Z-win-x64.zip` на странице [**Releases**](../../releases), распакуйте и запустите **`Start.cmd`**. .NET ставить не нужно.

> Windows SmartScreen может предупредить (приложение не подписано) — **Подробнее → Выполнить в любом случае**.

## Build from source

Требуется [.NET 8 SDK](https://dotnet.microsoft.com/download/dotnet/8.0).

```sh
dotnet test PoeExpeditionPriceHelper.sln
dotnet publish src/PoeExpeditionPriceHelper/ -c Release -r win-x64 --self-contained true -o publish
```

## Tech

WPF + WinForms overlay, Tesseract OCR (`rus`), .NET 8. Основа — [PoeAncientsPriceHelper](https://github.com/pedro-quiterio/PoeAncientsPriceHelper) by **pedro-quiterio**.
