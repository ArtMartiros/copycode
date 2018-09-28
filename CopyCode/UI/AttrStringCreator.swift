//
//  AttrStringCreator.swift
//  CopyCode
//
//  Created by Артем on 28/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Cocoa

// Monospace fonts
// "Courier New"
// "Menlo-Regular"
class AttrStringCreator {
    private let kFontWidthRatio: CGFloat = 1.2
    
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
                                                           .foregroundColor: NSColor.textColor]
        let myAttrString = NSAttributedString(string: text, attributes: myAttribute )
        return myAttrString
    }
}