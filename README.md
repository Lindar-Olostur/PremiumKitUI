# PremiumKitUI

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Библиотека для удобной работы с подписками и UI компонентами в SwiftUI приложениях. Включает готовые решения для интеграции с Apphud, кастомные View-компоненты и систему навигации.

## 🌟 Особенности

- Готовые UI компоненты для экранов подписок
- Интеграция с Apphud SDK
- Управление навигацией между экранами
- Поддержка разных типов подписок (годовые, месячные и т.д.)
- Полностью на SwiftUI

## 📦 Установка

### Swift Package Manager

Добавьте в ваш `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/ваш-ник/UtilityHelper.git", from: "1.0.0")
]
```
Или через Xcode:
File -> Add Packages... -> https://github.com/Lindar-Olostur/PremiumKitUI

## 🚀 Быстрый старт

### Инициализация подписок
```
import PremiumKitUI

Task {
    await PremiumKitUI.Subscription.loadSubscriptions(
        key: "ваш_api_key",
        json: { data in
            print("Получены данные:", data)
        },
        completion: {
            print("Загрузка завершена")
        }
    )
}
```
### Использование UI компонентов
```
// Текстовый компонент
PremiumKitUI.UI.TextBuilder(
    string: "Привет!",
    size: 16,
    color: .blue
)

// Кнопка
PremiumKitUI.UI.BigButton(
    color: .blue,
    corners: 16,
    action: { print("Нажата") },
    label: {
        Text("Купить подписку")
    }
)
```
## 🤝 Совместимость
- iOS 15+
- Swift 5.9+
- Xcode 14+
- ApphudSDK 3.0.0
## 📄 Лицензия
PremiumKitUI доступен по лицензии MIT. См. LICENSE для подробностей.
