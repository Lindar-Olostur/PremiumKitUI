// The Swift Programming Language
// https://docs.swift.org/swift-book

import ApphudSDK
import StoreKit
import Foundation
import SwiftUICore

#if os(iOS)
public struct UtilityHelper {
    public static func showMessage() {
        print("Hello from UtilityHelper!")
    }
    
    public static let ler = "Lol"
    
    @MainActor public static var subscriptions: [AppProduct] = []
    
    public enum Products: String {
        case year, week, error
    }
    
    public struct AppProduct: Identifiable {
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
                }
                return .error
            }()
            self.price = item.skProduct?.localizedPrice ?? "$0"
        }
    }
}
#endif

public extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
