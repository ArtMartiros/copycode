//
//  TreeOCRLowData.swift
//  CopyCode
//
//  Created by Артем on 17/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

private let s_rTree:TreeOCR = .n(.xy(x: 0.95, y: 0.6), .r("s"), .r("r"))

let lowOCRTree: TreeOCR = .n(.ratio(>, 5), .r("!"), nLowSubTree)

private let nLowSubTree: TreeOCR = .n(.xy(x:0, y:0.05), npLowSubTree, nnLowSubTree)

private let npLowSubTree:TreeOCR = .n(.lC,
                                      .n(.rC,
                                         .n(.n_u,
                                            .n(.bC,
                                               .n(.yRange(x:0.5, y:4...6, op: .or),
                                                  .n(.yRange(x:1, y: 7...9, op: .and),
                                                     .n(.yRange(x: 0.05, y: 3...6, op: .someFalse),
                                                        .r("a"),
                                                        .r("m")),
                                                     .r("e")),
                                                  .r("o")),
                                               .r("n")),
                                            .r("u")),
                                         .n(.xy(x:0, y: 1),
                                            s_rTree,
                                            .n(.xRange(x: 5...9, y: 0.5, op: .allFalse), .r("c"), .r("w")))),
                                      .n(.tC,
                                         .n(.question,
                                            .r("?"),
                                            .n(.bC,
                                               .n(.xy(x:0.95, y:0),
                                                  .n(.bR, .r("z"), s_rTree),
                                                  .n(.yRange(x: 0.95, y: 6...7, op: .or),
                                                     .r("s"),
                                                     .r("i"))),
                                               .r("w"))),
                                         .n(.xy(x:0.05, y:0.95),
                                            .n(.bC,
                                               .r("r"),
                                               .n(.xRange(x: 7...9, y: 0.8, op: .or),
                                                  .r("x"), .r(">"))),
                                            .n(.xRange(x: 4...6, y: 0.95, op: .someFalse),
                                               .r("w"),
                                               .r("v")))))
private let nnLowSubTree:TreeOCR = .n(.c,
                                      .n(.lC,
                                         .n(.yRange(x:1, y: 7...9, op: .and),
                                            .r("a"),
                                            .n(.plus_e, .r("+"), .r("e"))),
                                         .n(.xy(x:0.1, y: 0.25),
                                            .n(.s_star,
                                               .n(.yRange(x:1, y: 3...5, op: .and), .r("a"), .r("s")),
                                               .r("*")),
                                            .n(.bL,
                                               .n(.bC,
                                                  .n(.xy(x:0.8, y: 0.1), .r("z"), .r("i")),
                                                  .r("x")),
                                               .n(.xRange(x: 4...8, y: 0.05, op: .and),
                                                  .r("a"),
                                                  .r("*"))))),
                                      .n(.question,
                                         .r("?"),
                                         .n(.rC,
                                            .n(.yRange(x:0.5, y: 4...6, op: .or), .r("a"), .r("o")),
                                            .n(.bL,
                                               .r("r"),
                                               .n(.xy(x:0.5, y: 0.4),
                                                  .r("e"),
                                                  .n(.xy(x:0.3, y: 0), .r("c"), .r("<")))))))


