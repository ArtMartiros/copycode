//
//  TreeOCRCustomData.swift
//  CopyCode
//
//  Created by Артем on 29/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

private typealias OCR = TreeOCR
let customOCRTree = OCR.n(.xRange(x: 4...6, y: 0.2, op: .or),
                          pCustomTree,
                          nCustomTree )

let braceOrRoundLTree = OCR.n(.braceOrRoundL, .r("{"), .r("("))
let braceOrRoundRTree = OCR.n(.braceOrRoundR, .r("}"), .r(")"))
let underscoreOnComma = OCR.n(.xRange(x: 3...8, y: 0.9, op: .and), .r("_"), .r(","))
//@=-}1>.mn:_
private let nCustomTree = OCR.n(.xRange(x: 4...6, y: 0.8, op: .or),
                                OCR.n(.xy(x: 0.3, y: 0.9),
                                      underscoreOnComma,
                                      OCR.n(.xRange(x: 8...9, y: 0.5, op: .or),
                                            .r("m"),
                                            OCR.n(.yRange(x: 0.5, y: 3...5, op: .or),
                                                  .r(":"),
                                                  OCR.n(.hLine(l: 4...5, y: 8...9, op: .or, mainOp: .and),
                                                        .r(","),
                                                        .r("."))))),
                                OCR.n(.yRange(x: 0.5, y: 2...4, op: .or),
                                      OCR.n(.equalOrDashCustom,
                                            OCR.n(.yRange(x: 0.1, y: 1...2, op: .or), .r(">"), .r("=")),
                                            OCR.n(.xRange(x: 6...8, y: 0.8, op: .or), .r("n"), .r("-"))),
                                      OCR.n(.yRange(x: 0.3, y: 8...10, op: .or),
                                            .r("_"),
                                            OCR.n(.xRange(x: 4...6, y: 0.7, op: .or),
                                                  .r("."),
                                                  OCR.n(.yRange(x: 0.5, y: 8...10, op: .or), .r("_"), .r("-"))))))

private let pCustomTree = OCR.n(.xRange(x: 7...9, y: 0.5, op: .or),
                                OCR.n(.xRange(x: 1...3, y: 0.5, op: .or),
                                      .r("0"),
                                      OCR.n(.xRange(x:7...9, y: 0.8, op: .or),
                                            .r("]"),
                                            braceOrRoundRTree)),
                                OCR.n(.xRange(x: 2...3, y: 0.5, op: .or),
                                      OCR.n(.xRange(x: 2...2, y: 0.6, op: .or),
                                            .r("["),
                                            OCR.n(.yRange(x: 0.8, y: 4...5, op: .or),
                                                  OCR.n(.yRange(x: 0.8, y: 8...9, op: .or), .r("t"), .r("}")),
                                                  braceOrRoundLTree)),
                                      OCR.n(.yRange(x: 0.8, y: 1...3, op: .or),
                                            OCR.n(.yRange(x: 0.8, y: 3...4, op: .or), .r("2"), .r("I")),
                                            OCR.n(.xRange(x: 5...6, y: 0.8, op: .or),
                                                  .r("1"),
                                                  OCR.n(.yRange(x: 0.2, y: 7...9, op: .or),
                                                        .r("}"),
                                                        questionOrDash)))))

private let questionOrDash = OCR.n(.xRange(x: 5...8, y: 0.5, op: .or), .r("?"), .r("\""))
