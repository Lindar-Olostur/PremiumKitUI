// The Swift Programming Language
// https://docs.swift.org/swift-book

import ApphudSDK
import StoreKit
import Foundation
import SwiftUICore

public extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}

public class ProductsBuy {
    @MainActor public static let shared = ProductsBuy()
    public init() {}
    
    public var subscriptions: [AppProduct] = []
    
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

public struct TextBuilder: View {
    public let string: String
    public var size: CGFloat = 16
    public var fontName: String = ""
    public var weight: Font.Weight = .regular
    public var color: Color = .black
    public var opacity: Double = 1.0
    public var alignment: TextAlignment = .leading
    
    public var body: some View {
        getAlign(
            t: getColor(
                t: getWeight(
                    t: getFontNSize(
                        t: string,
                        s: size,
                        f: fontName),
                    w: weight),
                c: color,
                o: opacity),
            a: alignment)
    }
    private func getFontNSize(t: String, s: CGFloat = 16, f: String) -> Text {
        Text(t).font(.custom(f, size: s))
    }
    private func getWeight(t: Text, w: Font.Weight = .regular) -> Text {
        t.fontWeight(w)
    }
    private func getColor(t: Text, c: Color, o: Double) -> Text {
        t.foregroundColor(c.opacity(o))
    }
    private func getAlign(t: Text, a: TextAlignment) -> some View {
        t.multilineTextAlignment(a)
    }
}
