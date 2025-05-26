import Foundation
import ApphudSDK
import StoreKit

public extension PremiumKitUI.Subscription {
    @MainActor static var subscriptions: [AppProduct] = []
    
    enum Products: String {
        case year  = "year"
        case halfYear = "half year"
        case week = "week"
        case month = "month"
        case error = "error"
    }
    
    @MainActor static func getProduct(type: Products) -> AppProduct? {
        return subscriptions.first { $0.type == type }
    }
    
    @MainActor static func loadSubscriptions(
        key: String,
        json: @escaping ([String: Any]) -> Void,
        completion: @escaping () -> Void
    ) async throws {
        Apphud.start(apiKey: key)
        
        guard let placement = await Apphud.placement("Placement") else {
            throw NSError(domain: "PremiumKitUI", code: 1, userInfo: [NSLocalizedDescriptionKey: "Не удалось получить placement"])
        }
        
        guard let paywall = placement.paywall else {
            throw NSError(domain: "PremiumKitUI", code: 2, userInfo: [NSLocalizedDescriptionKey: "Paywall отсутствует в placement"])
        }
        
        if let data = paywall.json {
            json(data)
        }
        
        subscriptions.removeAll() // чтобы не накапливать старые продукты
        for item in paywall.products {
            subscriptions.append(AppProduct(item: item))
        }
        
        completion()
    }
    
    struct AppProduct: Identifiable {
        public let id = UUID()
        public let item: ApphudProduct
        public let type: Products
        public let price: String
        
        public init(item: ApphudProduct) {
            self.item = item
            self.type = {
                if item.productId.contains("year") || item.productId.contains("annual") {
                    return .year
                } else if item.productId.contains("week") {
                    return .week
                } else if item.productId.contains("half") || item.productId.contains("6")  {
                    return .halfYear
                }
                return .error
            }()
            self.price = item.skProduct?.localizedPrice ?? "$0"
        }
    }
    
    @MainActor static func getWeeklyPrise(_ s: String) -> String {
        guard !s.isEmpty else { return "" }
        let firstCharacter = String(s.first!)
        let cleanedString = String(s.dropFirst())
        
        guard let number = Double(cleanedString) else { return "" }
        
        let result = number / 52
        let formattedResult = String(format: "%.2f", result)
        
        return "\(firstCharacter)\(formattedResult)"
    }
}
