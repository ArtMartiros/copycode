//
//  TextViewCreator.swift
//  CopyCode
//
//  Created by Артем on 15/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

class TextViewCreator {

    func create(with frame: NSRect, with attrString: NSAttributedString) -> DrawTextView {
        let textView = DrawTextView(frame: frame)
        textView.isEditable = false
        textView.isSelectable = true
        textView.backgroundColor = NSColor.textViewFillColor
        textView.selectedTextAttributes = [ .backgroundColor : NSColor.blue.withAlphaComponent(0.4)]
        textView.textStorage?.append(attrString)
        return textView
    }
}


