//
//  TreeOCRLowData.swift
//  CopyCode
//
//  Created by Артем on 17/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

private typealias T = TreeOCR
private let s_rTree = T.n(.xy(x: 0.95, y: 0.6), .r("s"), .r("r"))
private let m_wTree = T.n(.xy(x: 0.05, y: 0.95), .r("m"), .r("w"))
private let s_aTree = T.n(.yRange(x: 0.05, y: 6...8, op: .and), .r("a"), .r("s"))
private let e_aTree = T.n(.e_a, .r("e"), .r("a"))
private let v_uTree = T.n(.v_u, .r("v"), .r("u"))
private let z_rTree = T.n(.xy(x:0.8, y: 0.1), .r("z"), .r("i"))
private let n_wSubTree = T.n(.xRange(x: 2...7, y: 0.1, op: .and), .r("n"), .r("w"))

let lowOCRTree = T.n(.ratio(>, 2.8), .r("!"), nLowSubTree)

// MARK: - ------------------------1 LEVEL-----------------------------
private let nLowSubTree = T.n(.xy(x:0, y:0.05), npLowSubTree, nnLowSubTree)

// MARK: - ------------------------2 LEVEL-----------------------------
// MARK: np
private let npLowSubTree = T.n(.lC, nppLowSubTree, npnLowSubTree)
// MARK: nn
private let nnLowSubTree = T.n(.c, nnpLowSubTree, nnnLowSubTree)

// MARK: - ------------------------3 LEVEL-----------------------------
// MARK: npp
private let nppLowSubTree = T.n(.rC, npppLowSubTree, nppnLowSubTree)
// MARK: npn
private let npnLowSubTree = T.n(.tC,
                                T.n(.question,
                                    .r("?"),
                                    T.n(.bC,
                                        T.n(.xy(x:0.95, y:0),
                                            T.n(.yRange(x: 1, y: 6...7, op: .or),
                                                s_rTree,
                                                T.n(.vLine(l: 3...7, x: 1...3, op: .and, mainOp: .or ),
                                                    .r("r"),
                                                    T.n(.Z_S, .r("z"), .r("s")))),
                                            T.n(.yRange(x: 0.9, y: 6...7, op: .or),
                                                T.n(.yRange(x: 0.95, y: 4...6, op: .and),
                                                    .r("a"),
                                                    T.n(.yRange(x: 0.8, y: 0...5, op: .or),
                                                        .r("s"),
                                                        .r("i"))),
                                                T.n(.yRange(x: 0.5, y: (-5)...(-3), op: .or), .r("i"), .r("r")))),
                                        n_wSubTree)),
                                T.n(.xy(x:0.05, y:0.95),
                                    T.n(.bC,
                                        T.n(.xy(x:0.95, y:0.05), .r("r"), .r("i")),
                                        T.n(.xRange(x: 7...9, y: 0.8, op: .or),
                                            //так как плохо сочетается с sc9
                                            T.n(.xRangeP(x: 0...1, y: 0.5, op: .or, p: 0.8),
                                                .r("w"),
                                                .r("x")),
                                            .r(">"))),
                                    T.n(.w_u,
                                        .r("w"),
                                        v_uTree)))
// MARK: nnp
private let nnpLowSubTree = T.n(.lC,
                                T.n(.yRange(x: 1, y: 7...9, op: .and),
                                    .r("a"),
                                    T.n(.plus_e,
                                        .r("+"),
                                        T.n(.yRange(x: 0.5, y: 9...10, op: .or),
                                            e_aTree,
                                            .r("<")))),
                                T.n(.xy(x:0.1, y: 0.25),

                                    T.n(.vLine(l: 5...9, x: 3...5, op: .and, mainOp: .or),
                                        T.n(.yRange(x: 0.05, y: 7...9, op: .and), .r("m"), .r("*")),
                                        T.n(.yRange(x:1, y: 3...5, op: .and),
                                            .r("a"),
                                            T.n(.yRange(x: 0.5, y: 9...10, op: .or),
                                                .r("s"),
                                                .r("x")))),
                                    T.n(.bL,
                                        T.n(.bC,
                                            T.n(.xy(x:0.8, y: 0.1), .r("z"), .r("i")),
                                            .r("x")),
                                        T.n(.xRange(x: 4...6, y: 0.05, op: .and),
                                            .r("a"),
                                            T.n(.x_asterix,
                                                T.n(.bC, .r("i"), .r("x")),
                                                .r("*"))))))
// MARK: nnn
private let nnnLowSubTree = T.n(.question,
                                .r("?"),
                                T.n(.rC,
                                    T.n(.yRange(x:0.5, y: 4...6, op: .or),
                                        T.n(.xy(x: 0.5, y: 0.9), .r("a"), .r(">")),
                                        .r("o")),
                                    T.n(.bL,
                                        T.n(.yRange(x:0.95, y: 0...2, op: .or),
                                            .r("r"),
                                            .r("i")),
                                        T.n(.xy(x:0.5, y: 0.4),
                                            T.n(.xy(x: 0.05, y: 0.5),
                                                T.n(.xy(x: 0.5, y: 0.05),
                                                    e_aTree,
                                                    .r("<")),
                                                T.n(.xy(x: 0.9, y: 0.6), .r("a"), .r("r"))),
                                            T.n(.xRange(x: 5...8, y: 0.5, op: .allFalse),

                                                T.n(.yRange(x: 0.3, y: 0...1, op: .or), .r("c"), .r("<")),
                                                .r("v"))))))
// MARK: - ------------------------4 LEVEL-----------------------------
// MARK: nppp
private let npppLowSubTree = T.n(.n_u,
                                 T.n(.bC,
                                     T.n(.yRange(x:0.5, y:4...6, op: .or),
                                         T.n(.yRange(x:1, y: 6...8, op: .and),
                                             T.n(.m_a,
                                                 .r("m"),
                                                 s_aTree),
                                             T.n(.e_a, .r("e"), .r("m"))),
                                         .r("o")),
                                     T.n(.xRangeP(x: 4...6, y: 0.5, op: .allFalse, p: 92),
                                         .r("n"),
                                         T.n(.xRange(x: 3...7, y: 0.1, op: .someFalse),
                                             .r("w"),
                                             .r("m")))),
                                 T.n(.xy(x: 0.5, y: 0.95),
                                     T.n(.xy(x: 0.95, y: 0.95),
                                         T.n(.xy(x: 0.5, y: 0.05), .r("m"), .r("u")),
                                         .r("v")),
                                     m_wTree))

// MARK: nppn
private let nppnLowSubTree = T.n(.xy(x: 0, y: 1),
                                 T.n(.xy(x: 0.95, y: 0.6),
                                     T.n(.yRange(x: 0.05, y: 6...8, op: .and),
                                         T.n(.xRange(x: 9...10, y: 0.5, op: .or),
                                             T.n(.c, .r("m"), .r("n")),
                                             .r("c")),
                                         T.n(.m_a,
                                             .r("m"),
                                             .r("s"))),

                                     T.n(.xyp(x: 0, y: 0.5, p: 85),
                                         T.n(.xRange(x: 8...10, y: 0.6, op: .or),
                                             s_aTree,
                                             T.n(.xRange(x: 9...10, y: 0.8, op: .or),
                                                 .r("c"),
                                                 .r("r"))), //r без ножки
                                        //r точно c ножкой
                                        .r("r"))),
                                 T.n(.xRange(x: 5...9, y: 0.5, op: .allFalse),
                                     T.n(.yRange(x: 0.5, y: 4...6, op: .allFalse),
                                         .r("c"),
                                         .r("e")),
                                     T.n(.xy(x: 0.5, y: 1),
                                         T.n(.yRange(x: 0.05, y: 4...8, op: .and),
                                             T.n(.xRange(x: 4...6, y: 0.1, op: .someFalse),
                                                 v_uTree,
                                                 e_aTree),
                                             T.n(.yRange(x: 0.5, y: 0...2, op: .allFalse),
                                                 v_uTree,
                                                 s_aTree)),
                                         T.n(.yRange(x: 0.5, y: 3...6, op: .allFalse),
                                             .r("u"),
                                             T.n(.xRange(x: 3...7, y: 0.1, op: .someFalse),
                                                 T.n(.w_star, .r("w"), .r("*")),
                                                 T.n(.m_a, .r("m"), .r("a")))))))
