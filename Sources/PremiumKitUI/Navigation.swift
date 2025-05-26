import ApphudSDK
import SwiftUI
import StoreKit

public extension PremiumKitUI.Navigation {
    final class Coordinator: ObservableObject {
        @Published public var screen: Screen = .splash
        var onCompleted: Bool = UserDefaults.standard.bool(forKey: "onboardingKey")
        
        public init() {}
        
        public func splashFinished() {
            if onCompleted {
                if Apphud.hasPremiumAccess() {
                    withAnimation { screen = .main }
                } else {
                    withAnimation { screen = .paywall }
                }
            } else {
                withAnimation { screen = .onboarding }
            }
        }
        
        public func skipOnboarding() {
            if Apphud.hasPremiumAccess() {
                withAnimation { screen = .main }
            } else {
                withAnimation { screen = .paywall }
            }
        }
        
        public func onboardingFinished() {
            onCompleted = true
            UserDefaults.standard.set(true, forKey: "onboardingKey")
            if Apphud.hasPremiumAccess() {
                withAnimation { screen = .main }
            } else {
                withAnimation { screen = .paywall }
            }
        }
        
    }
    
    enum Screen: Equatable {
        case splash, onboarding, paywall, main
    }
}


public extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
