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
                                   .n(.bracketOrArrowCustom,
                                      .r("}"),
                                      .n(.yRange(x: 0.8, y: 7...8, op: .or),
                                         .n(.xy(x: 0.65, y: 0.2), .r("2"), .r("1")),
                                         .r(">")))),
                                .n(.xy(x: 0.4, y: 0.8),
                                   .n(.xy(x: 0.65, y: 0.8),
                                      .n(.xy(x: 0.65, y: 0.2),
                                         .r("2"),
                                         .n(.xRange(x:1...8, y: 0.7, op: .or),
                                            .r("1"),
                                            .r("_"))),
                                      .n(.xRange(x: 2...4, y: 0.3, op: .or),
                                         .r("}"),
                                         .r("."))),
                                   .n(.xRange(x: 6...8, y: 0.2, op: .or),
                                      .r("\""),
                                      .n(.xRange(x: 1...1, y: 0.8, op: .or), .r("}"), equalOrDash)
                                    )))

