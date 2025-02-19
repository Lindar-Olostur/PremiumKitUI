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
        var inactiveColor: Color
        var size: CGFloat
        var width: CGFloat
        var spacing: CGFloat
        
        public init(count: Int, active: Int, activeColor: Color, inactiveColor: Color = .blue, size: CGFloat = 8, width: CGFloat = 0, spacing: CGFloat = 8) {
            self.count = count
            self.active = active
            self.activeColor = activeColor
            self.inactiveColor = inactiveColor
            self.size = size
            self.width = width
            self.spacing = spacing
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
        var size: CGFloat
        var fontName: String
        var weight: Font.Weight
        var color: Color
        var opacity: Double
        var alignment: TextAlignment
        var underlined: Bool
        var strikethrough: Bool
        var kerning: CGFloat
        
        public init(string: String, size: CGFloat = 16, fontName: String = "", weight: Font.Weight = .regular, color: Color = .black, opacity: Double = 1.0, alignment: TextAlignment = .center, underlined: Bool = false, strikethrough: Bool = false, kerning: CGFloat = 0) {
            self.string = string
            self.size = size
            self.fontName = fontName
            self.weight = weight
            self.color = color
            self.opacity = opacity
            self.alignment = alignment
            self.underlined = underlined
            self.strikethrough = strikethrough
            self.kerning = kerning
        }
        
        public var body: some View {
            Text(string)
                .font(.custom(fontName, size: size).weight(weight))
                .foregroundStyle(color.opacity(opacity))
                .multilineTextAlignment(alignment)
                .underline(underlined)
                .strikethrough(strikethrough)
                .kerning(kerning)
        }
    }
    
    public struct BigButton<Content: View>: View {
        var width: CGFloat
        var height: CGFloat
        var color: Color
        var corners: CGFloat
        var padding: CGFloat
        let action: () -> Void
        let label: Content
        
        public init(width: CGFloat = .infinity, height: CGFloat = 52, color: Color = .white, corners: CGFloat = 0, padding: CGFloat = 0, action: @escaping () -> Void, label: () -> Content) {
            self.width = width
            self.height = height
            self.color = color
            self.corners = corners
            self.padding = padding
            self.action = action
            self.label = label()
        }
        
        public var body: some View {
            label
                .frame(maxWidth: width, maxHeight: height)
                .background(color)
                .cornerRadius(corners)
                .contentShape(Rectangle())
                .padding(padding)
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

