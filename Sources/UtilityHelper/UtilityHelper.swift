// The Swift Programming Language
// https://docs.swift.org/swift-book

import ApphudSDK
import StoreKit
import Foundation
import SwiftUICore

#if os(iOS)
public struct UtilityHelper {
    
//MARK: - Products
    @MainActor public static var subscriptions: [AppProduct] = []
    
    public enum Products: String {
        case year, week, error
    }
    
    @MainActor public static func getProduct(type: Products) -> AppProduct? {
        return subscriptions.first { $0.type == type }
    }
    
    @MainActor public static func loadSubscriptions(key: String, json: @escaping ([String : Any]) -> Void, completion: @escaping () -> ()) async {
        Apphud.start(apiKey: key)
        if let placement = await Apphud.placement("Placement"),
           let paywall = placement.paywall {
            if let data = paywall.json {
                json(data)
            }
            for item in paywall.products {
                subscriptions.append(AppProduct(item: item))
            }
            completion()
        }
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
    
    @MainActor public static func getWeeklyPrise(_ s: String) -> String {
        guard !s.isEmpty else { return "" }
        let firstCharacter = String(s.first!)
        let cleanedString = String(s.dropFirst())
        
        guard let number = Double(cleanedString) else { return "" }
        
        let result = number / 52
        let formattedResult = String(format: "%.2f", result)
        
        return "\(firstCharacter)\(formattedResult)"
    }
    
//MARK: - UI
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
    
    public struct XmarkButton: View {
        var size: CGFloat
        var weight: Font.Weight
        var color: Color
        var opacity: Double
        var alignment: Alignment
        var padding: CGFloat
        let action: () -> Void
        
        public init(size: CGFloat = 20, weight: Font.Weight = .regular, color: Color = .white, opacity: Double = 0.5, alignment: Alignment = .trailing, padding: CGFloat = 16, action: @escaping () -> Void) {
            self.size = size
            self.weight = weight
            self.color = color
            self.opacity = opacity
            self.alignment = alignment
            self.padding = padding
            self.action = action
        }
        
        public var body: some View {
            Image(systemName: "xmark")
                .font(.system(size: size, weight: weight))
                .foregroundStyle(color.opacity(opacity))
                .frame(maxWidth: .infinity, alignment: alignment)
                .padding(padding)
                .onTapGesture {
                    action()
                }
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
    
    public static func customImage(name: String, contentMode: ContentMode = .fit, width: CGFloat = .infinity, height: CGFloat = .infinity, corners: CGFloat = 0, alignment: Alignment = .center) -> some View {
        Image(name)
            .resizable()
            .aspectRatio(contentMode: contentMode)
            .frame(maxWidth: width, maxHeight: height, alignment: alignment)
            .cornerRadius(corners)
    }
    
    public static func systemImage(name: String, size: CGFloat = 16, color: Color = .black, weight: Font.Weight = .regular) -> some View {
        Image(systemName: name)
            .font(.system(size: size).weight(weight))
            .foregroundStyle(color)
    }
    
//    public struct ToggleButton<Content: View>: View {
//        var width: CGFloat
//        var height: CGFloat
//        var color: Color
//        var corners: CGFloat
//        var padding: CGFloat
//        var opacity: CGFloat
//        var shadowColor: Color
//        var shadowOpacity: CGFloat
//        var shadowRadius: CGFloat
//        var strokeColor: Color
//        var strokeOpacity: CGFloat
//        var strokeWidth: CGFloat
//        let action: () -> Void
//        let label: Content
//
//        public init(width: CGFloat = .infinity, height: CGFloat = 52, color: Color = .white, corners: CGFloat = 0, padding: CGFloat = 0, opacity: CGFloat = 0, shadowColor: Color = .clear, shadowOpacity: CGFloat = 0.0, shadowRadius: CGFloat = 0, strokeColor: Color = .clear, strokeOpacity: CGFloat = 0,  strokeWidth: CGFloat = 0, action: @escaping () -> Void, label: () -> Content) {
//            self.width = width
//            self.height = height
//            self.color = color
//            self.corners = corners
//            self.padding = padding
//            self.opacity = opacity
//            self.shadowColor = shadowColor
//            self.shadowOpacity = shadowOpacity
//            self.shadowRadius = shadowRadius
//            self.strokeColor = strokeColor
//            self.strokeOpacity = strokeOpacity
//            self.strokeWidth = strokeWidth
//            self.action = action
//            self.label = label()
//        }
//
//        public var body: some View {
//            label
//                .frame(maxWidth: width, maxHeight: height)
//                .background(color)
//                .cornerRadius(corners)
//                .shadow(color: shadowColor.opacity(shadowOpacity), radius: shadowRadius, x: 0, y: 0)
//                .overlay(
//                    RoundedRectangle(cornerRadius: corners)
//                        .inset(by: 0.5)
//                        .stroke(strokeColor.opacity(strokeOpacity), lineWidth: strokeWidth)
//                )
//                .opacity(opacity)
//                .padding(padding)
//                .onTapGesture {
//                    action()
//                }
//        }
//    }
    
    public struct PayWallFooter: View {
        let termsOfUsePath: String
        let privacyPolicyPath: String
        let restoreCompletion: () -> Void
        
        public init(termsOfUsePath: String, privacyPolicyPath: String, restoreCompletion: @escaping () -> Void) {
            self.termsOfUsePath = termsOfUsePath
            self.privacyPolicyPath = privacyPolicyPath
            self.restoreCompletion = restoreCompletion
        }
        
        public var body: some View {
            HStack {
                Text("Terms of Use")
                    .onTapGesture {
                        openURL(termsOfUsePath)
                    }
                Spacer()
                Text("Restore")
                    .onTapGesture {
                        Apphud.restorePurchases { subscriptions, purchases, error in
                            if Apphud.hasActiveSubscription() {
                                restoreCompletion()
                            }
                        }
                    }
                Spacer()
                Text("Privacy Policy")
                    .onTapGesture {
                        openURL(privacyPolicyPath)
                    }
            }
            .font(.caption)
            .foregroundStyle(.gray)
            .underline()
            .padding()
        }
        
        @MainActor public func openURL(_ path: String) {
            if let url = URL(string: "path") {
                UIApplication.shared.open(url)
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
// e
