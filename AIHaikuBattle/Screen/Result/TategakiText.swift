//
//  TategakiText.swift
//  AIHaikuBattle
//
//  Created by 佐川 晴海 on 2025/10/13.
//


import UIKit
import CoreText
import SwiftUI

public struct TategakiText: UIViewRepresentable {
    public var text: String?
    
    public func makeUIView(context: Context) -> TategakiTextView {
        let uiView = TategakiTextView()
        uiView.isOpaque = false
        uiView.text = text
        return uiView
    }
    
    public func updateUIView(_ uiView: TategakiTextView, context: Context) {
        uiView.text = text
    }
}

public class TategakiTextView: UIView {
    public var text: String? = nil {
        didSet {
            ctFrame = nil
        }
    }
    private var ctFrame: CTFrame? = nil
    
    override public func draw(_ rect: CGRect) {
        guard let context:CGContext = UIGraphicsGetCurrentContext() else {
            return
        }
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -rect.height)
        
        let baseAttributes: [NSAttributedString.Key : Any] = [
            .verticalGlyphForm: true,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25),
        ]
        let attributedText = NSMutableAttributedString(string: text ?? "", attributes: baseAttributes)
        let setter = CTFramesetterCreateWithAttributedString(attributedText)
        let path = CGPath(rect: rect, transform: nil)
        let frameAttrs = [
            kCTFrameProgressionAttributeName: CTFrameProgression.rightToLeft.rawValue,
        ]
        let ct = CTFramesetterCreateFrame(setter, CFRangeMake(0, 0), path, frameAttrs as CFDictionary)
        ctFrame = ct
        
        CTFrameDraw(ct, context)
    }
}


#Preview {
    TategakiText(text: """
こんにちは、
わたしの名前はふじきです。
これはswiftuiで実装されています。
「どうやって実装してるのか」って？
それはQiitaの記事を読むとわかりますよ！
""")
}
