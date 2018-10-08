//
//  sc1_letter.swift
//  CopyCodeTests
//
//  Created by Артем on 08/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

let sc1_letter = [
    0: "// Created by Артем щт 15/09/2018.",
    1: "//  Copyright © 2018 Artem Martirosyan. All rights reserved.",
    2: "//",

    3: "import AppKit",

    4: "class TextViewCreator {",
    5: "private let kTextViewColor = NSColor.red",

    6: "func create(with frame: NSRect, with attrString: NSAttributedString) -> NSTextView {",
    7: "let textView = NSTextView(frame: frame)",
    8: "textView.isEditable = false",
    9: "textView.isSelectable = true",
    10: "textView.backgroundColor = kTextViewColor",
    11: "textView.textStorage? append(attrString)",
    12: "return textView",
    13: "}",
    14: "}",
    15: "// Monospace fonts",
    16: "// \"Courier New\"",
    17: "// \"Menlo-Regular\"",
    18: "class AttrStringCreator {",
    19: "private let kFontWidthRatio: CGFloat = 1.2",
    20: "private let kTextColor = NSColor.black",
    21: "private func detectFontSize(from letterWidth: CGFloat) -> CGFloat {",
    22: "let fontSize = (letterWidth / kFontWidthRatio * 2).rounded()",
    23: "return fontSize"
]
