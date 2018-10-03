//
//  TreeOCRCustomData.swift
//  CopyCode
//
//  Created by Артем on 29/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

fileprivate let equalOrDash: TreeOCR = .n(.equalOrDashCustom, .r("="), .r("-"))
let customOCRTree: TreeOCR = .n(.xy(x: 0.5, y: 0.55),
                                .n(.xy(x: 0.1, y: 0.55),
                                   equalOrDash,
                                   .n(.bracketOrArrowCustom, .r("}"), .r(">"))),
                                .n(.xy(x: 0.4, y: 0.8),
                                   .n(.xy(x: 0.65, y: 0.8),
                                      .n(.xy(x: 0.65, y: 0.2),
                                         .r("2"),
                                         .n(.xRange(x:1...8, y: 0.7, op: .or),
                                            .r("1"),
                                            .r("_"))),
                                      .r(".")),
                                   .n(.xRange(x: 6...8, y: 0.2, op: .or),
                                      .r("\""),
                                      .n(.xRange(x: 1...1, y: 0.8, op: .or), .r("}"), equalOrDash)
                                    )))

let customOCRTree2: TreeOCR = .n(.xy(x: 0.5, y: 0.5),
                                .n(.xy(x: 0.1, y: 0.5),
                                   .n(.xy(x: 0.9, y: 0.5),
                                      equalOrDash,
                                      .r("-")),
                                   .n(.xy(x: 0.7, y: 0.5), .r("{"), .r("}"))),
                                
                                .n(.xy(x: 0.5, y: 0.3),
                                   .n(.xy(x: 0.9, y: 0.3),
                                      .r("="),
                                      .n(.xRange(x: 8...9, y: 0.5, op: .or),
                                         .r(">"),
                                         .n(.yRange(x: 0.1, y: 2...4, op: .or),
                                            .r("="),
                                            .n(.yRange(x: 0.1, y: 6...8, op: .or),
                                               .r("="),
                                               .r("<"))))),
                                   .n(.xRange(x: 5...8, y: 0.2, op: .or),
                                      .n(.doubleQuotesCustom, .r("\""), .r("'")),
                                      .n(.yRange(x: 0.5, y: 3...4, op: .or),
                                         .r("="), .r(",")))))
