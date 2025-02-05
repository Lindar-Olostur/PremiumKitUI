// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

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
