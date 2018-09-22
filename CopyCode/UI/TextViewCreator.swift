//
//  TextViewCreator.swift
//  CopyCode
//
//  Created by Артем on 15/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

class TextViewCreator {
    private let kTextViewColor = NSColor.clear
    
    func create(with frame: NSRect, with attrString: NSAttributedString) -> NSTextView {
        let textView = NSTextView(frame: frame)
        textView.isEditable = false
        textView.isSelectable = true
        textView.backgroundColor = kTextViewColor
        textView.selectedTextAttributes = [ .backgroundColor : NSColor.blue.withAlphaComponent(0.4)]
        textView.textStorage?.append(attrString)
        return textView
    }
}
// Monospace fonts
// "Courier New"
// "Menlo-Regular"
class AttrStringCreator {
    private let kFontWidthRatio: CGFloat = 1.2
    private let kTextColor = NSColor.clear
    private func detectFontSize(from letterWidth: CGFloat) -> CGFloat {
       let fontSize = (letterWidth / kFontWidthRatio * 2).rounded()
        return fontSize
    }
    
    func create(with text: String, letterWidth width: CGFloat, spacing: CGFloat) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        let fontSize = detectFontSize(from: width)
        let font = NSFont(name: "Menlo-Regular", size: fontSize)

        let myAttribute: [NSAttributedString.Key : Any] = [.font: font!,
                                                           .paragraphStyle: paragraphStyle,
                                                           .foregroundColor: kTextColor]
        let myAttrString = NSAttributedString(string: text, attributes: myAttribute )
        return myAttrString
    }
}
