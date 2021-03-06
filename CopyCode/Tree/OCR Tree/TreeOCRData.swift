//
//  TreeOCRData.swift
//  CopyCode
//
//  Created by Артем on 03/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

typealias TreeOCR = Tree<OCROperations, String>
// swiftlint:disable type_name
private typealias T = TreeOCR
private let g_qTree: T = .n(.yRange(x: 0.5, y: 9...10, op: .or), .r("g"), .r("q"))
private let y_jTree = T.n(.rC, .r("j"), .r("y"))

let lowWithTailOCRTree = T.n(.xy(x:0, y:0.05),
                               .n(.lC,
                                  .n(.xy(x:0.9, y: 0.8),
                                     g_qTree,
                                     .n(.xy(x: 0.05, y: 0.7), .r("p"), .r("y"))),
                                  y_jTree),
                               .n(.xyp(x:0.1, y: 0.33, p: 110),
                                  .n(.xRange(x: 8...9, y: 0.8, op: .or),
                                     g_qTree,
                                     .r("p")) ,
                                  y_jTree))

let dashOrHyphenOCRTree = T.n(.hyphenOrDash,
                                .r("~"),
                                .n(.equalOrDash, .r("="), .r("-")))

let commaOCRTree = T.n(.semicolon, .r(";"), .r(","))
let colonOCRTree = T.n(.colon,
                       T.n(.exclamationMarkOrColon, .r("!"), .r(":")),
                       .r("."))
let quoteOCRTree = T.n(.ratio(>, 1.2),
                       .r("'"),
                       T.n(.xy(x: 0.5, y: 0.9), .r("*"), .r("^")))

extension LetterType {
    /// Собраны все бинарные деревья по логике определения буквы
    var treeOCR: TreeOCR {
        switch self {
        case .upper: return upperOCRTree
        case .low: return lowOCRTree
        case .lowWithTail: return lowWithTailOCRTree
        case .dashOrHyphen: return dashOrHyphenOCRTree
        case .dot: return colonOCRTree
        case .underscore: return TreeOCR.r("_")
        case .comma: return commaOCRTree
        case .quote: return quoteOCRTree
        case .undefined: return TreeOCR.r("...")
        case .custom: return customOCRTree
        //тип введен после восстановления LetterResotrer
        case .doubleQuote: return TreeOCR.r("\"")

        }
    }
}
