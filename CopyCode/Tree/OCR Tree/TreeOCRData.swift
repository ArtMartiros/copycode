//
//  TreeOCRData.swift
//  CopyCode
//
//  Created by Артем on 03/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

typealias TreeOCR = Tree<OCROperations, String>

private let g_qTree: TreeOCR = .n(.bC, .r("g"), .r("q"))

let lowWithTailOCRTree: TreeOCR = .n(.xy(x:0, y:0.05),
                                                 .n(.lC,
                                                    .n(.xy(x:0.9, y: 0.8), g_qTree, .r("p")),
                                                    .n(.rC, .r("j"), .r("y"))),
                                                 .n(.xy(x:0.1, y: 0.33),
                                                    .n(.xy(x:0.9, y: 0.8), g_qTree, .r("p")) ,
                                                    .r("j")))
let dashOrHyphenOCRTree: TreeOCR = .n(.hyphenOrDash,
                                      .r("~"),
                                      .n(.equalOrDash, .r("="), .r("-")))

let commaOCRTree: TreeOCR = .n(.semicolon, .r(";"), .r(","))
let colonOCRTree: TreeOCR = .n(.colon, .r(":"), .r("."))
let quoteOCRTree: TreeOCR = .n(.ratio(>, 1), .r("'"), .r("^"))

extension LetterType {
    /// Собраны все бинарные деревья по логике определения буквы
    var treeOCR: TreeOCR {
        switch self {
        case .upper: return upperOCRTree
        case .low: return lowOCRTree
        case .lowWithTail: return lowWithTailOCRTree
        case .dashOrHyphen: return dashOrHyphenOCRTree
        case .dot: return .r(".")
        case .underscore: return .r("_")
        case .comma: return commaOCRTree
        case .quote: return quoteOCRTree
        case .undefined: return .r("...")
        case .custom: return .r("~")
        }
    }
}
