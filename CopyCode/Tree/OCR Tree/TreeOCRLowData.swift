//
//  TreeOCRLowData.swift
//  CopyCode
//
//  Created by Артем on 17/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

fileprivate typealias OCR = TreeOCR
private let s_rTree = OCR.n(.xy(x: 0.95, y: 0.6), .r("s"), .r("r"))
private let s_aTree = OCR.n(.yRange(x: 0.05, y: 6...8, op: .and), .r("a"), .r("s"))
private let e_aTree = OCR.n(.e_a, .r("e"), .r("a"))
private let z_rTree = OCR.n(.xy(x:0.8, y: 0.1), .r("z"), .r("i"))
private let n_wSubTree = OCR.n(.xRange(x: 2...7, y: 0.1, op: .and), .r("n"), .r("w"))

let lowOCRTree = OCR.n(.ratio(>, 2.8), .r("!"), nLowSubTree)

// MARK: - ------------------------1 LEVEL-----------------------------
private let nLowSubTree = OCR.n(.xy(x:0, y:0.05), npLowSubTree, nnLowSubTree)

// MARK: - ------------------------2 LEVEL-----------------------------
private let npLowSubTree = OCR.n(.lC, nppLowSubTree, npnLowSubTree)

private let nnLowSubTree = OCR.n(.c,
                                 OCR.n(.lC,
                                       OCR.n(.yRange(x: 1, y: 7...9, op: .and),
                                             .r("a"),
                                             OCR.n(.plus_e,
                                                   .r("+"),
                                                   OCR.n(.xy(x: 0.5, y: 0.9),
                                                         e_aTree,
                                                         .r("<")))),
                                       OCR.n(.xy(x:0.1, y: 0.25),
                                             OCR.n(.s_star,
                                                   OCR.n(.yRange(x:1, y: 3...5, op: .and),
                                                         .r("a"),
                                                         OCR.n(.xy(x: 0.5, y: 0.95), .r("s"), .r("x"))),
                                                   .r("*")),
                                             OCR.n(.bL,
                                                   OCR.n(.bC,
                                                         OCR.n(.xy(x:0.8, y: 0.1), .r("z"), .r("i")),
                                                         .r("x")),
                                                   OCR.n(.xRange(x: 4...8, y: 0.05, op: .and),
                                                         .r("a"),
                                                         .r("*"))))),
                                 OCR.n(.question,
                                       .r("?"),
                                       OCR.n(.rC,
                                             OCR.n(.yRange(x:0.5, y: 4...6, op: .or),
                                                   OCR.n(.xy(x: 0.5, y: 0.9), .r("a"), .r(">")),
                                                   .r("o")),
                                             OCR.n(.bL,
                                                   OCR.n(.yRange(x:0.95, y: 0...2, op: .or),
                                                         .r("r"),
                                                         .r("i")),
                                                   OCR.n(.xy(x:0.5, y: 0.4),
                                                         OCR.n(.xy(x: 0.05, y: 0.5), .r("e"), .r("r")),
                                                         OCR.n(.xy(x:0.3, y: 0),
                                                               .r("c"),
                                                               OCR.n(.xRange(x: 0...3, y: 0.1, op: .or), .r("v"), .r("<"))))))))

// MARK: - ------------------------3 LEVEL-----------------------------

private let nppLowSubTree = OCR.n(.rC,
                                  OCR.n(.n_u,
                                        OCR.n(.bC,
                                              OCR.n(.yRange(x:0.5, y:4...6, op: .or),
                                                    OCR.n(.yRange(x:1, y: 6...8, op: .and),
                                                          OCR.n(.m_a,
                                                                .r("m"),
                                                                OCR.n(.s_a,
                                                                      .r("s"),
                                                                      .r("a"))),
                                                          OCR.n(.e_a, .r("e"), .r("m"))),
                                                    .r("o")),
                                              .r("n")),
                                        OCR.n(.xy(x: 0.5, y: 0.95), .r("u"), .r("w"))),
                                  OCR.n(.xy(x:0, y: 1),
                                        OCR.n(.xy(x: 0.95, y: 0.6),
                                              OCR.n(.yRange(x: 0.05, y: 6...8, op: .and),
                                                    .r("c"),
                                                    .r("s")),
                                              OCR.n(.xy(x: 0.5, y: 0.9),
                                                    OCR.n(.xRange(x: 8...10, y: 0.6, op: .or),
                                                          .r("a"),
                                                          .r("c")),
                                                    .r("r"))),
                                        OCR.n(.xRange(x: 5...9, y: 0.5, op: .allFalse),
                                              .r("c"),
                                              OCR.n(.xy(x: 0.5, y: 1),
                                                    OCR.n(.yRange(x: 0.05, y: 4...8, op: .and),
                                                          OCR.n(.xRange(x: 4...6, y: 0.1, op: .someFalse),
                                                                .r("u"),
                                                                e_aTree),
                                                          s_aTree),
                                                    OCR.n(.yRange(x: 0.5, y: 3...6, op: .allFalse),
                                                          .r("u"),
                                                          OCR.n(.xRange(x: 3...7, y: 0.1, op: .someFalse),
                                                                .r("w"),
                                                                OCR.n(.m_a, .r("m"), .r("a"))))))))

private let npnLowSubTree = OCR.n(.tC,
                                  OCR.n(.question,
                                        .r("?"),
                                        OCR.n(.bC,
                                              OCR.n(.xy(x:0.95, y:0),
                                                    OCR.n(.yRange(x: 1, y: 6...7, op: .or),
                                                          s_rTree,
                                                          OCR.n(.vLine(l: 3...7, x: 1...3, op: .and, mainOp: .or ),
                                                                .r("r"),
                                                                .r("z"))),
                                                    OCR.n(.yRange(x: 0.9, y: 6...7, op: .or),
                                                          OCR.n(.yRange(x: 0.95, y: 4...6, op: .and),
                                                                .r("a"),
                                                                OCR.n(.yRange(x: 0.8, y: 0...5, op: .or),
                                                                      .r("s"),
                                                                      .r("i"))),
                                                          OCR.n(.xy(x: 0.95, y: 0.05), .r("r"), .r("i")))),
                                              n_wSubTree)),
                                  OCR.n(.xy(x:0.05, y:0.95),
                                        OCR.n(.bC,
                                              .r("r"),
                                              OCR.n(.xRange(x: 7...9, y: 0.8, op: .or),
                                                    .r("x"), .r(">"))),
                                        OCR.n(.xy(x: 0.5, y: 0.3),
                                              .r("w"),
                                              OCR.n(.v_u, .r("v"), .r("u")))))
