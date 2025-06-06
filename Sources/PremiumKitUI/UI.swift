import SwiftUI
import ApphudSDK

public extension PremiumKitUI.UI {
    struct PageIndicator: View {
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
    
    struct PromoList: View {
        let image: String
        let imageColor: Color
        let imageSize: CGFloat
        let text: [String]
        let textColor: Color
        let textSize: CGFloat
        let spacing: CGFloat
        
        public init(image: String, imageColor: Color, imageSize: CGFloat, text: [String], textColor: Color, textSize: CGFloat, spacing: CGFloat) {
            self.image = image
            self.imageColor = imageColor
            self.imageSize = imageSize
            self.text = text
            self.textColor = textColor
            self.textSize = textSize
            self.spacing = spacing
        }
        
        public var body: some View {
            VStack(alignment: .leading, spacing: spacing) {
                ForEach(text, id: \.self) { element in
                    HStack {
                        Image(systemName: image)
                            .font(.system(size: imageSize))
                            .foregroundStyle(imageColor)
                        TextBuilder(string: element, size: textSize, fontName: "Poppins-Regular", color: textColor)
                    }
                }
            }
        }
    }
    
    struct TextBuilder: View {
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
        var trunication: Text.TruncationMode
        
        public init(string: String, size: CGFloat = 16, fontName: String = "", weight: Font.Weight = .regular, color: Color = .black, opacity: Double = 1.0, alignment: TextAlignment = .center, underlined: Bool = false, strikethrough: Bool = false, kerning: CGFloat = 0, trunication: Text.TruncationMode = .tail) {
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
            self.trunication = trunication
        }
        
        public var body: some View {
            Text(string)
                .font(.custom(fontName, size: size).weight(weight))
                .foregroundStyle(color.opacity(opacity))
                .multilineTextAlignment(alignment)
        }
    }
    
    struct SystemImageButton: View {
        var name: String
        var size: CGFloat
        var weight: Font.Weight
        var color: Color
        var opacity: Double
        var alignment: Alignment
        var padding: CGFloat
        let action: () -> Void
        
        public init(name: String = "xmark", size: CGFloat = 20, weight: Font.Weight = .regular, color: Color = .white, opacity: Double = 0.5, alignment: Alignment = .trailing, padding: CGFloat = 16, action: @escaping () -> Void) {
            self.name = name
            self.size = size
            self.weight = weight
            self.color = color
            self.opacity = opacity
            self.alignment = alignment
            self.padding = padding
            self.action = action
        }
        
        public var body: some View {
            Image(systemName: name)
                .font(.system(size: size, weight: weight))
                .foregroundStyle(color.opacity(opacity))
                .frame(maxWidth: .infinity, alignment: alignment)
                .padding(padding)
                .onTapGesture {
                    action()
                }
        }
    }
    
    struct BigButton<Content: View>: View {
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
    
    func customImage(name: String, contentMode: ContentMode = .fit, width: CGFloat = .infinity, height: CGFloat = .infinity, corners: CGFloat = 0, alignment: Alignment = .center) -> some View {
    Image(name)
        .resizable()
        .aspectRatio(contentMode: contentMode)
        .frame(maxWidth: width, maxHeight: height, alignment: alignment)
        .cornerRadius(corners)
}
    
    func systemImage(name: String, size: CGFloat = 16, color: Color = .black, weight: Font.Weight = .regular) -> some View {
        Image(systemName: name)
            .font(.system(size: size).weight(weight))
            .foregroundStyle(color)
    }
    
    struct PurchasesToggle: View {
        @Binding var toggle: Bool
        let tintColor: Color
        let bgColor: Color
        let scale: CGFloat
        let textColor: Color
        let text: String
        let fontName: String
        let size: CGFloat
        let corners: CGFloat
        var height: CGFloat
        var width: CGFloat
        
        public init(toggle: Binding<Bool>, tintColor: Color = .black, bgColor: Color = .white.opacity(0.95), scale: CGFloat = 0.6, textColor: Color = .black, text: String, fontName: String, size: CGFloat = 13, corners: CGFloat = 16, height: CGFloat = 40, width: CGFloat = .infinity) {
            self._toggle = toggle
            self.tintColor = tintColor
            self.bgColor = bgColor
            self.scale = scale
            self.textColor = textColor
            self.text = text
            self.fontName = fontName
            self.size = size
            self.corners = corners
            self.height = height
            self.width = width
        }
        
        public var body: some View {
            HStack {
                TextBuilder(string: text, size: size, fontName: fontName, color: textColor)
                Spacer()
                Toggle("", isOn: $toggle)
                    .labelsHidden()
                    .scaleEffect(scale)
                    .tint(tintColor)
            }
            .padding(.horizontal)
            .frame(maxWidth: width, maxHeight: height)
            .background(bgColor)
            .cornerRadius(corners)
        }
    }
    
    struct PayWallFooter: View {
        var isUnderlined: Bool
        let color: Color
        let termsOfUsePath: String
        let privacyPolicyPath: String
        let restoreCompletion: () -> Void
        
        public init(isUnderlined: Bool = true, color: Color = .gray, termsOfUsePath: String, privacyPolicyPath: String, restoreCompletion: @escaping () -> Void) {
            self.isUnderlined = isUnderlined
            self.color = color
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
            .foregroundStyle(color)
            .padding()
        }
        
        @MainActor public func openURL(_ path: String) {
            if let url = URL(string: path) {
                UIApplication.shared.open(url)
            }
        }
    }
}
