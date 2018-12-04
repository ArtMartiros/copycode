//
//  TreeOCRUpperData.swift
//  CopyCode
//
//  Created by Артем on 17/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

private typealias OCR = TreeOCR
let upperOCRTree = OCR.n(.ratio(>, 2.55), pSubTree, nSubTree)

// MARK: - ------------------------1 LEVEL-----------------------------

private let pSubTree = OCR.n(.ratio(>, 3.5), ppSubTree, pnSubTree)

private let nSubTree = OCR.n(.bR, npSubTree, nnSubTree)

// MARK: - ------------------------2 LEVEL-----------------------------

private let npSubTree = OCR.n(.bC, nppSubTree, npnSubTree)
private let nnSubTree = OCR.n(.c, nnpSubTree, nnnSubTree )

private let ppSubTree = OCR.n(.expandFrame(.horizontal), pppSubTree, .empty)

private let pnSubTree = OCR.n(.rCr,
                              OCR.n(.tR,
                                    OCR.n(.xy(x: 0.05, y: 1), .r("]"), .r("1")),
                                    OCR.n(.yRange(x: 0.9, y: 3...6, op: .and),
                                          .r(")"),
                                          .r("}"))),
                              OCR.n(.lCr,
                                    OCR.n(.tL, .r("["), braceOrRoundLOne),
                                    OCR.n(.bL, .r("I"), .r("1"))))
// MARK: - ------------------------3 LEVEL-----------------------------
private let nppSubTree = OCR.n(.tR, npppSubTree, nppnSubTree)
private let npnSubTree = OCR.n(.tCr,
                               OCR.n(.tL,
                                     RKkTree,
                                     OCR.n(.bL,
                                           OCR.n(.N_A,
                                                 OCR.n(.xRange(x: 5...7, y: 0.05, op: .and),
                                                       .r("R"),
                                                       .r("N")),
                                                 .r("A")),
                                           OCR.n(.lC,
                                                 OCR.n(.xRange(x: 6...9, y: 0.5, op: .allFalse),
                                                       braceOrRoundL,
                                                       Q4AndTree),
                                                 .r("t")))),
                               OCR.n(.xy(x: 0.95, y: 0.7),
                                     OCR.n(.tR,
                                           OCR.n(.lC,
                                                 OCR.n(.H_N,
                                                       OCR.n(.M_H, .r("M"), .r("H")),
                                                       OCR.n(.xRange(x: 7...9, y: 0.8, op: .and), .r("N"), .r("M"))),
                                                 .r("1")),
                                           .r("h")),
                                     OCR.n(.lC,
                                           RKkTree,
                                           .r("X"))))

private let nnpSubTree = OCR.n(.bL, nnppSubTree, nnpnSubTree)
private let nnnSubTree = OCR.n(.tL, nnnpSubTree, nnnnSubTree)

private let pppSubTree = OCR.n(.ratio(>, 7.5),
                               .r("|"),
                               OCR.n(.rC,
                                     roundOrSquareR,
                                     OCR.n(.lCr,
                                           roundOrSquareL,
                                           OCR.n(.bL, .r("I"), .r("1")))))

// MARK: - ------------------------4 LEVEL-----------------------------
// MARK: nppp
private let npppSubTree = OCR.n(.bL,
                                OCR.n(.lC,
                                      OCR.n(.tCr,
                                            OCR.n(.topCircleRight,
                                                  .r("B"),
                                                  OCR.n(.E_5, .r("E"), nS_5Tree)),
                                            OCR.n(.tLr, .r("M"), .r("d"))),

                                      OCR.n(.I_Z,
                                            //f c ножкой
                                        OCR.n(.yRange(x: 0.05, y: 3...4, op: .or),
                                              .r("f"),
                                              .r("I")),
                                        OCR.n(.xy(x: 0.9, y: 0.3),
                                              OCR.n(.f_2,
                                                    .r("f"),
                                                    OCR.n(.yRange(x: 0.95, y: 6...8, op: .and),
                                                          .r("J"),
                                                          .r("2"))),
                                              .r("Z")))),
                                OCR.n(.G_C,
                                      OCR.n(.tCr,
                                            OCR.n(.yRange(x:0.95, y: 4...6, op: .someFalse),
                                                  OCR.n(.botCircleLeft, G_8Tree, .r("S")),
                                                  OCR.n(.O_Q,

                                                        OCR.n(.yRange(x: 0.5, y: 4...6, op: .or),
                                                              OCR.n(.yRangeP(x: 0, y: 4...6, op: .and, p: 90),
                                                                    .r("0"),
                                                                    .r("8")),
                                                              .r("O")),
                                                        .r("Q"))),
                                            OCR.n(.xRange(x: 0...1, y: 0.1, op: .or), .r("U"), .r("d"))),
                                      OCR.n(.ratio(>, 2),
                                            OCR.n(.xyp(x: 0.05, y: 0.3, p: 90),
                                                  OCR.n(.hLine(l: 5...7, y: 2...4, op: .and, mainOp: .or),
                                                        .r("t"),
                                                        .r("(")),
                                                  .r("{")),
                                            OCR.n(.hLine(l: 5...7, y: 2...4, op: .and, mainOp: .or), f_tTree, .r("C")))))

// MARK: nppn
private let nppnSubTree = OCR.n(.tCr,
                                OCR.n(.tL,
                                      OCR.n(.lC,
                                            .r("E"),
                                            OCR.n(.ratio(>=, 2),
                                                  OCR.n(.yRange(x: 0.9, y: 0...1, op: .or), .r("I"), .r("l")),
                                                  OCR.n(.xy(x: 0.8, y: 0),
                                                        Z_2Tree,
                                                        OCR.n(.yRange(x: 0.9, y: 1...5, op: .or), .r("2"), .r("l"))))),
                                      OCR.n(.bL,
                                            OCR.n(.r3,
                                                  .r("2"),
                                                  OCR.n(.xy(x: 0.8, y: 0),
                                                        .r("Z"),
                                                        OCR.n(.yRange(x: 0, y: 5...6, op: .and), .r("&"), l_1Tree))),
                                            OCR.n(.lC,
                                                  OCR.n(.sobaka,
                                                        .r("@"),
                                                        OCR.n(.xRange(x: 8...10, y: 0.35, op: .or),
                                                              OCR.n(.xy(x:0.05, y: 0.1),
                                                                    .r("Q"),
                                                                    OCR.n(.yRange(x: 0.85, y: 3...6, op: .someFalse),
                                                                          .r("6"),
                                                                          .r("d"))),
                                                              OCR.n(.yRange(x:0, y:2...4, op: .someFalse), .r("&"), .r("G")))),
                                                  t84AndTree))),
                                OCR.n(.tL,
                                      OCR.n(.ratio(>, 1.3),
                                            OCR.n(.xy(x: 0.05, y: 0.5),
                                                  OCR.n(.xRange(x: 4...10, y: 0.5, op: .or),
                                                        OCR.n(.xRange(x: 6...10, y: 0.7, op: .or),
                                                              OCR.n(.xRange(x: 4...5, y: 0.95, op: .and), .r("b"), .r("k")),
                                                              //sc11 l там она не такая как все
                                                            .r("l")),
                                                        OCR.n(.yRangeP(x: 0.7, y: 0...3, op: .or, p: 110),
                                                              .r("t"),
                                                              OCR.n(.L_l, .r("L"), .r("l")))),
                                                  .r("l")),
                                            .r("M")),
                                      OCR.n(.bL,
                                            .r("1"),
                                            OCR.n(.yRange(x: 0.9, y: 4...7, op: .and),
                                                  .r("d"),
                                                  t4AndTree))))
// MARK: nnpp
private let nnppSubTree = OCR.n(.bC,
                                OCR.n(.tL,
                                      OCR.n(.tR,
                                            OCR.n(.yRange(x: 0.05, y: 6...7, op: .and),
                                                  .r("B"),
                                                  OCR.n(.Z_S,
                                                        .r("Z"),
                                                        OCR.n(.xy(x: 0.1, y: 0.3), .r("S"), .r("3")))),
                                            OCR.n(.lC,
                                                  OCR.n(.tCr,
                                                        OCR.n(.botCircleLeft,
                                                              .r("B"),
                                                              nS_5Tree),
                                                        .r("b")),
                                                  OCR.n(.xy(x:1, y:0.7), .r("3"), .r("}")))),
                                    OCR.n(.yRange(x: 0.05, y: 6...7, op: .and),
                                          .r("B"),
                                          OCR.n(.Z_S,
                                                .r("Z"),

                                                OCR.n(.S_Dollar,
                                                      .r("S"),
                                                      OCR.n(.vLine(l: 7...8, x: 4...6, op: .and, mainOp: .or),
                                                            .r("$"),
                                                            .r("6")))))),
                                OCR.n(.tR,
                                      OCR.n(.tL, PF75Tree, .r("/")),
                                      OCR.n(.xy(x:0.95, y: 0.3), .r("P"), .r("}"))))
// MARK: nnpn
private let nnpnSubTree = OCR.n(.bC,
                                OCR.n(.tL,
                                      OCR.n(.r6,
                                            OCR.n(.botCircleLeft,
                                                  OCR.n(.yRange(x: 0.05, y: 4...6, op: .and),
                                                        .r("0"),
                                                        OCR.n(.vLine(l: 1...3, x: 4...6, op: .and, mainOp: .or), .r("$"), .r("8"))),
                                                  OCR.n(.topCircleRight,
                                                        OCR.n(.topCircleLeft, .r("9"), .r("3")),
                                                        nS_5Tree)),
                                            OCR.n(.tCr,
                                                  .r("T"),
                                                  OCR.n(.vLine(l: 6...9, x: 7...8, op: .allFalse, mainOp: .or),
                                                        .r("Y"),
                                                        .r("V")))),
                                      OCR.n(.lC,
                                            OCR.n(.sobaka,
                                                  .r("@"),
                                                  OCR.n(.xy(x: 0, y: 0.45),
                                                        n469GTree,
                                                        .r("8"))),
                                            OCR.n(.xy(x:0.95, y: 2/3),
                                                  OCR.n(.xy(x:0.1, y: 1/3),
                                                        asterixOr83SDollarTree,
                                                        OCR.n(.xy(x:0.1, y: 1/5),
                                                              n83SDollarTree,
                                                              OCR.n(.not5, n83Tree, .r("5")))),
                                                  f_tTree))),
                                n7fWDollarSlashTree)
// MARK: nnnp
private let nnnpSubTree = OCR.n(.xy(x:0.05, y: 0.95),
                                OCR.n(.rCr,
                                      OCR.n(.tCr,
                                            OCR.n(.lC,
                                                  OCR.n(.p_d,
                                                        OCR.n(.yRange(x: 0.9, y: 8...9, op: .or), nB5Tree, PF7Tree),
                                                        OCR.n(.yRange(x:0, y: 7...9, op: .someFalse),
                                                              .r("9"),
                                                              OCR.n(.xRange(x: 8...10, y: 0.8, op: .or), .r("D"), .r("P")))),
                                                  OCR.n(.xy(x:0.05, y: 0.3),
                                                        .r("5"),
                                                        OCR.n(.yRange(x: 1, y: 6...8, op: .and), .r("J"), .r("}")))),
                                            OCR.n(.tR,
                                                  .r("U"),
                                                  OCR.n(.lCr, .r("b"), .r("}")))),
                                      BbPF75Tree),
                                OCR.n(.bC,
                                      OCR.n(.lC,
                                            OCR.n(.tCr, .r("5"), .r("U")),
                                            OCR.n(.xRange(x: 8...10, y: 0.05, op: .or),
                                                  .r("V"),
                                                  .r("l"))),
                                      n7fWDollarTree))
private let nnnnSubTree = OCR.n(.rCr,
                                OCR.n(.lC,
                                      OCR.n(.bC,
                                            OCR.n(.not5,
                                                  OCR.n(.O_G,
                                                        OCR.n(.xRange(x: 1...2, y: 0.1, op: .or),
                                                              O_0Tree, .r("d")),
                                                        G6Tree),
                                                  n59Tree),
                                            OCR.n(.xy(x: 0, y: 0.3), QP4AndTree, .r("4"))),
                                      OCR.n(.tR,
                                            .r("J"),
                                            OCR.n(.xRange(x: 6...9, y: 0.6, op: .allFalse),
                                                  .r("r"),
                                                  n59Tree))),
                                OCR.n(.G_C,
                                      OCR.n(.left4,
                                            .r("4"),
                                            OCR.n(.botCircleLeft, G6Tree, .r("5"))),
                                      OCR.n(.lC,
                                            OCR.n(.bC, .r("C"), Q4AndfTree),
                                            OCR.n(.yRange(x: 0.5, y: 1...4, op: .or),
                                                  OCR.n(.n4_f,
                                                        OCR.n(.xRange(x: 5...9, y: 0.6, op: .or),
                                                              .r("4"),
                                                              OCR.n(.yRange(x: 0.05, y: 4...6, op: .and),
                                                                    .r("("),
                                                                    .r("t"))),
                                                        f_tTree),
                                                  .r("l")))))

// MARK: Helper
private let asterixOr83SDollarTree = OCR.n(.ratio(<, 1.2), .r("*"), n83SDollarTree)
private let O_0Tree = OCR.n(.yRange(x:0.5, y: 4...6, op: .allFalse ), .r("O"), .r("0"))
private let l_1Tree = OCR.n(.l_1,
                            .r("l"),
                            OCR.n(.i_1, .r("i"), .r("1")))
private let f_tTree = OCR.n(.f_t, .r("f"), .r("t"))
private let RKkTree = OCR.n(.R_K,
                            .r("R"),
                            OCR.n(.K_k, .r("K"), .r("k")))

private let nS_5Tree = OCR.n(.S_5, .r("S"), .r("5"))
private let Q4AndTree = OCR.n(.yRange(x:0, y: 2...6, op: .and ),
                              OCR.n(.yRange(x: 0.5, y: 4...5, op: .allFalse), .r("Q"), .r("N")),
                              OCR.n(.xRange(x: 1...3, y: 0.95, op: .allFalse), .r("4"), .r("&")))
private let Q4AndfTree = OCR.n(.yRange(x:0, y: 2...6, op: .and ),
                               OCR.n(.yRange(x: 0.5, y: 4...5, op: .allFalse),
                                     .r("Q"),
                                     OCR.n(.xRange(x: 9...10, y: 0.7, op: .or), .r("N"), .r("f"))),
                               OCR.n(.xRange(x: 1...3, y: 0.95, op: .allFalse), .r("4"), .r("&")))
private let QP4AndTree = OCR.n(.yRange(x:0, y: 2...6, op: .and ),
                               OCR.n(.yRange(x: 0.5, y: 4...5, op: .allFalse),
                                     OCR.n(.yRange(x: 0.5, y: 7...9, op: .or), .r("Q"), .r("P")),
                                     .r("N")),
                               OCR.n(.xRange(x: 1...3, y: 0.95, op: .allFalse), .r("4"), .r("&")))

private let G_0Tree = OCR.n(.G_0, .r("G"), .r("0"))
private let G6Tree = OCR.n(.vLine(l: 4...6, x: 2...4, op: .allFalse, mainOp: .or), .r("G"), .r("6"))
private let G_8Tree = OCR.n(.G_8, .r("G"), .r("8"))
private let BbPF75Tree = OCR.n(.tCr,
                               OCR.n(.yRange(x:0.05, y: 6...7, op: .someFalse),
                                     OCR.n(.botCircleLeft, .r("C"), .r("5")),
                                     OCR.n(.xy(x: 0.5, y: 0.95), .r("B"), PF75Tree)),
                               .r("b"))
private let PF7Tree = OCR.n(.topCircleRight,
                            OCR.n(.lCr, .r("P"), .r("7")),
                            .r("F"))
private let PF75Tree = OCR.n(.topCircleRight,
                             OCR.n(.lCr, .r("P"), .r("7")),
                             OCR.n(.xRange(x:8...10, y: 0.8, op: .or), .r("5"), .r("F")))

private let n7fWDollarTree = OCR.n(.n7_W, OCR.n(.xy(x: 0.05, y: 0.5), .r("P"), .r("7")),
                                   OCR.n(.ratio(>, 1.4),
                                         OCR.n(.yRange(x: 0.95, y: 7...9, op: .or), .r("$"), .r("f")),
                                         OCR.n(.xRange(x:7...10, y: 0.3, op: .or), .r("W"), .r("$")) ))

private let n7fWDollarSlashTree = OCR.n(.n7_W,
                                        OCR.n(.xRange(x: 7...9, y: 0.3, op: .or), .r("7"), .r("T")),
                                        OCR.n(.ratio(>, 1.4),
                                              OCR.n(.yRange(x: 0.95, y: 7...9, op: .or),
                                                    .r("$"),
                                                    OCR.n(.yRange(x: 0.1, y: 2...3, op: .or), .r("f"), .r("/"))),
                                              OCR.n(.xRange(x:7...10, y: 0.3, op: .or), .r("W"), .r("$")) ))
private let braceOrRoundL = OCR.n(.yRange(x: 0.1, y: 3...6, op: .and), roundOrSquareL, .r("{"))
private let braceOrRoundLOne = OCR.n(.yRange(x: 0.05, y: 3...6, op: .and), roundOrSquareL, .r("{"))
private let roundOrSquareR = OCR.n(.yRange(x: 1, y: 7...9, op: .and), .r("]"), .r(")"))
private let roundOrSquareL = OCR.n(.yRange(x: 0, y: 7...9, op: .and), .r("["), .r("("))
private let n59Tree = OCR.n(.topCircleRight, .r("9"), .r("5"))
private let nB5Tree = OCR.n(.topCircleRight, .r("B"), .r("5"))
private let n83SDollarTree = OCR.n(.r3, n83Tree, SDollarTree)
//2 места
private let n83Tree = OCR.n(.botCircleLeft, .r("8"), .r("3"))
private let SDollarTree = OCR.n(.S_Dollar, .r("S"), .r("$"))
private let  Z_2Tree = OCR.n(.xy(x: 0.9, y: 0.3), .r("2"), .r("Z"))
//2 места
private let t84AndTree = OCR.n(.t_4,
                               OCR.n(.vLine(l: 3...7, x: 3...5, op: .and, mainOp: .or),
                                     OCR.n(.i_t, .r("i"), .r("t")),
                                     OCR.n(.botCircleLeft, .r("8"), .r("S"))),
                               OCR.n(.xRange(x:2...6, y:0.9, op: .and),
                                     OCR.n(.yRange(x: 0.9, y: 1...4, op: .and), .r("d"), .r("&")),
                                     OCR.n(.xRange(x: 1...3, y: 0.95, op: .allFalse), .r("4"), .r("&"))))
private let t4AndTree = OCR.n(.t_4,
                              .r("t"),
                              OCR.n(.xRange(x:2...6, y:0.9, op: .and),
                                    OCR.n(.yRange(x: 0.9, y: 1...4, op: .and), .r("d"), .r("&")),
                                    OCR.n(.xRange(x: 1...3, y: 0.95, op: .allFalse), .r("4"), .r("&"))))

private let n469GTree =  OCR.n(.yRange(x: 0.95, y: 4...7, op: .and),
                               OCR.n(.topCircleRight,
                                     OCR.n(.G_0,
                                           .r("G"),
                                           OCR.n(.botCircleLeft, .r("0"), .r("9"))),
                                     .r("6")),
                               OCR.n(.botCircleLeft,
                                     OCR.n(.xRange(x: 0...3, y: 0.95, op: .or),
                                           G6Tree,
                                           .r("4")),
                                     .r("9")))
