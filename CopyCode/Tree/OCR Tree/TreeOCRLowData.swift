//
//  TreeOCRLowData.swift
//  CopyCode
//
//  Created by Артем on 17/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

private let s_rTree: TreeOCR = .n(.xy(x: 0.95, y: 0.6), .r("s"), .r("r"))
private let s_aTree: TreeOCR = .n(.yRange(x: 0.05, y: 6...8, op: .and), .r("a"), .r("s"))
private let e_aTree: TreeOCR = .n(.e_a, .r("e"), .r("a"))
private let z_rTree: TreeOCR = .n(.xy(x:0.8, y: 0.1), .r("z"), .r("i"))
private let m_sSubTree: TreeOCR =  .n(.botCircleLeft, .r("m"), .r("s"))
private let n_wSubTree: TreeOCR =  .n(.xRange(x: 2...7, y: 0.1, op: .and), .r("n"), .r("w"))

let lowOCRTree: TreeOCR = .n(.ratio(>, 2.8), .r("!"), nLowSubTree)

//MARK:-------------------------1 LEVEL-----------------------------
private let nLowSubTree: TreeOCR = .n(.xy(x:0, y:0.05), npLowSubTree, nnLowSubTree)


//MARK:-------------------------2 LEVEL-----------------------------
private let npLowSubTree: TreeOCR = .n(.lC, nppLowSubTree, npnLowSubTree)

private let nnLowSubTree:TreeOCR = .n(.c,
                                      .n(.lC,
                                         .n(.yRange(x: 1, y: 7...9, op: .and),
                                            .r("a"),
                                            .n(.plus_e,
                                               .r("+"),
                                               .n(.xy(x: 0.5, y: 0.9),
                                              
                                                e_aTree,
                                                .r("<")))),
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
                                               .n(.yRange(x:0.95, y: 0...2, op: .or),
                                                  .r("r"),
                                                  .r("i")),
                                               .n(.xy(x:0.5, y: 0.4),
                                                  .r("e"),
                                                  .n(.xy(x:0.3, y: 0),
                                                     .r("c"),
                                                     .n(.xRange(x: 0...3, y: 0.1, op: .or), .r("v"), .r("<"))))))))


//MARK:-------------------------3 LEVEL-----------------------------

private let nppLowSubTree: TreeOCR = .n(.rC,
                                        .n(.n_u,
                                           .n(.bC,
                                              .n(.yRange(x:0.5, y:4...6, op: .or),
                                                 .n(.yRange(x:1, y: 6...8, op: .and),
                                                    .n(.m_a,
                                                       m_sSubTree,
                                                       .n(.yRange(x:0.05, y: 6...8, op: .and),
                                                          .r("a"),
                                                          .r("s"))),
                                                    .n(.e_a, .r("e"), .r("m"))),
                                                 .r("o")),
                                              .r("n")),
                                           .r("u")),
                                        .n(.xy(x:0, y: 1),
                                           .n(.xy(x: 0.95, y: 0.6),
                                              .n(.yRange(x: 0.05, y: 6...8, op: .and),
                                                 .r("c"),
                                                 .r("s")),
                                              .n(.xy(x: 0.5, y: 0.9), .r("c"), .r("r"))),
                                           .n(.xRange(x: 5...9, y: 0.5, op: .allFalse),
                                              .r("c"),
                                              .n(.xy(x: 0.5, y: 1),
                                                 .n(.yRange(x: 0.05, y: 4...8, op: .and),
                                                    .n(.xRange(x: 4...6, y: 0.1, op: .someFalse),
                                                       .r("u"),
                                                       e_aTree),
                                                    s_aTree),
                                                 .n(.yRange(x: 0.5, y: 3...6, op: .allFalse),
                                                    .r("u"),
                                                    .n(.xRange(x: 3...7, y: 0.1, op: .someFalse),
                                                       .r("w"),
                                                       .r("a")))))))

private let npnLowSubTree: TreeOCR = .n(.tC,
                                        .n(.question,
                                           .r("?"),
                                           .n(.bC,
                                              .n(.xy(x:0.95, y:0),
                                                 .n(.yRange(x: 1, y: 6...7, op: .or),
                                                    s_rTree,
                                                    .n(.vLine(l: 3...7, x: 1...3, op: .and, mainOp: .or ),
                                                       .r("r"),
                                                       .r("z"))),
                                                 .n(.yRange(x: 0.9, y: 6...7, op: .or),
                                                    .n(.yRange(x: 0.95, y: 4...6, op: .and),
                                                       .r("a"),
                                                       .n(.yRange(x: 0.8, y: 0...5, op: .or),
                                                          .r("s"),
                                                          .r("i"))),
                                                    .n(.xy(x: 0.95, y: 0.05), .r("r"), .r("i")))),
                                              n_wSubTree)),
                                        .n(.xy(x:0.05, y:0.95),
                                           .n(.bC,
                                              .r("r"),
                                              .n(.xRange(x: 7...9, y: 0.8, op: .or),
                                                 .r("x"), .r(">"))),
                                           .n(.xRange(x: 4...6, y: 0.95, op: .someFalse),
                                              .r("w"),
                                              .n(.v_u, .r("v"), .r("u")))))




