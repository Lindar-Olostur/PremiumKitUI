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
    
    public struct PageIndicator: View {
        let count: Int
        let active: Int
        var activeColor: Color
        var inactiveColor: Color = .blue
        var size: CGFloat = 8
        var width: CGFloat = 0
        var spacing: CGFloat = 8
        
        public init(count: Int, active: Int, activeColor: Color) {
            self.count = count
            self.active = active
            self.activeColor = activeColor
        }
        
        public var body: some View {
            HStack(spacing: spacing) {
                ForEach(0...count-1, id: \.self) { i in
                    Capsule()
                        .frame(width: i == active-1 ? size+width : size, height: size)
                        .foregroundStyle(i == active-1 ? activeColor : inactiveColor)
                }
            }
        }
    }
    
    public struct TextBuilder: View {
        let string: String
        var size: CGFloat = 16
        var fontName: String = ""
        var weight: Font.Weight = .regular
        var color: Color = .black
        var opacity: Double = 1.0
        var alignment: TextAlignment = .center
        var underlined: Bool = false
        var strikethrough: Bool = false
        
        public init(string: String, size: CGFloat) {
            self.string = string
            self.size = size
        }
        
        public var body: some View {
            Text(string)
                .font(.custom(fontName, size: size).weight(weight))
                .foregroundStyle(color.opacity(opacity))
                .multilineTextAlignment(alignment)
                .underline(underlined)
                .strikethrough(strikethrough)
        }
    }
    
    public struct BigButton<Content: View>: View {
        var height: CGFloat = 52
        var color: Color = .white
        var corners: CGFloat = 0
        let action: () -> Void
        let label: Content
        
        public init(action: @escaping () -> Void, label: () -> Content) {
            self.action = action
            self.label = label()
        }
        
        public var body: some View {
            label
                .frame(maxWidth: .infinity, maxHeight: height)
                .background(color)
                .cornerRadius(corners)
                .contentShape(Rectangle())
                .onTapGesture {
                    action()
                }
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



#Preview {
    UtilityHelper.PageIndicator(count: 4, active: 1, activeColor: .red)
}
