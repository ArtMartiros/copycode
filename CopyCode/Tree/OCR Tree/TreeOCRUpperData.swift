//
//  TreeOCRUpperData.swift
//  CopyCode
//
//  Created by Артем on 17/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

private typealias T = TreeOCR
let upperOCRTree = T.n(.ratio(>, 2.55), pSubTree, nSubTree)

// MARK: - ------------------------1 LEVEL-----------------------------

private let pSubTree = T.n(.ratio(>, 3.5), ppSubTree, pnSubTree)

private let nSubTree = T.n(.bR, npSubTree, nnSubTree)

// MARK: - ------------------------2 LEVEL-----------------------------

private let npSubTree = T.n(.bC, nppSubTree, npnSubTree)
private let nnSubTree = T.n(.c, nnpSubTree, nnnSubTree )

private let ppSubTree = T.n(.expandFrame(.horizontal), pppSubTree, .empty)

private let pnSubTree = T.n(.rCr,
                            T.n(.tR,
                                T.n(.xy(x: 0.05, y: 0.95), .r("]"), .r("1")),
                                braceOrRoundR),
                            T.n(.lCr,
                                T.n(.tL, .r("["), braceOrRoundLOne),
                                T.n(.bL, .r("I"), .r("1"))))
// MARK: - ------------------------3 LEVEL-----------------------------
private let nppSubTree = T.n(.tR, npppSubTree, nppnSubTree)
private let npnSubTree = T.n(.tCr,
                             T.n(.tL,
                                 RKkTree,
                                 T.n(.bL,
                                     T.n(.N_A,
                                         T.n(.xRange(x: 5...7, y: 0.05, op: .and),
                                             .r("R"),
                                             .r("N")),
                                         .r("A")),
                                     T.n(.lC,
                                         T.n(.xRange(x: 6...9, y: 0.5, op: .allFalse),
                                             braceOrRoundL,
                                             Q4AndTree),
                                         .r("t")))),
                             T.n(.xy(x: 0.95, y: 0.7),
                                 T.n(.tR,
                                     T.n(.lC,
                                         T.n(.H_N,
                                             T.n(.M_H, .r("M"), .r("H")),
                                             T.n(.xRange(x: 7...9, y: 0.8, op: .and), .r("N"), .r("M"))),
                                         .r("1")),
                                     .r("h")),
                                 T.n(.lC,
                                     RKkTree,
                                     .r("X"))))

private let nnpSubTree = T.n(.bL, nnppSubTree, nnpnSubTree)
private let nnnSubTree = T.n(.tL, nnnpSubTree, nnnnSubTree)

private let pppSubTree = T.n(.ratio(>, 7.5),
                             .r("|"),
                             T.n(.rC,
                                 roundOrSquareR,
                                 T.n(.lCr,
                                     roundOrSquareL,
                                     T.n(.bL, .r("I"), .r("1")))))

// MARK: - ------------------------4 LEVEL-----------------------------
// MARK: nppp
private let npppSubTree = T.n(.bL,
                              T.n(.lC,
                                  T.n(.tCr,
                                      T.n(.topCircleRight,
                                          .r("B"),
                                          T.n(.E_5, .r("E"), nS_5Tree)),
                                      T.n(.tLr, .r("M"), .r("d"))),

                                  T.n(.I_Z,
                                      //f c ножкой
                                    T.n(.yRange(x: 0.05, y: 3...4, op: .or),
                                        .r("f"),
                                        .r("I")),
                                    T.n(.xy(x: 0.9, y: 0.3),
                                        T.n(.f_2,
                                            .r("f"),
                                            T.n(.yRange(x: 0.95, y: 6...8, op: .and),
                                                .r("J"),
                                                .r("2"))),
                                        .r("Z")))),
                              T.n(.G_C,
                                  T.n(.tCr,
                                      T.n(.yRange(x:0.95, y: 4...6, op: .someFalse),
                                          T.n(.botCircleLeft, G_8Tree, .r("S")),
                                          T.n(.O_Q,

                                              T.n(.yRange(x: 0.5, y: 4...6, op: .or),
                                                  T.n(.yRangeP(x: 0, y: 4...6, op: .and, p: 90),
                                                      .r("0"),
                                                      .r("8")),
                                                  .r("O")),
                                              .r("Q"))),
                                      T.n(.xRange(x: 0...1, y: 0.1, op: .or), .r("U"), .r("d"))),
                                  T.n(.ratio(>, 2),
                                      T.n(.xyp(x: 0.05, y: 0.3, p: 90),
                                          T.n(.hLine(l: 5...7, y: 2...4, op: .and, mainOp: .or),
                                              .r("t"),
                                              .r("(")),
                                          .r("{")),
                                      T.n(.hLine(l: 5...7, y: 2...4, op: .and, mainOp: .or),
                                          T.n(.yRange(x: 0.95, y: 7...9, op: .and),
                                              .r("d"),
                                              f_tTree),
                                          T.n(.xy(x: 0.05, y: 0.5),
                                              .r("C"),
                                              .r("I"))))))

// MARK: nppn
private let nppnSubTree = T.n(.tCr,
                              T.n(.tL,
                                  T.n(.lC,
                                      .r("E"),
                                      T.n(.ratio(>=, 2),
                                          T.n(.yRange(x: 0.9, y: 0...1, op: .or), .r("I"), .r("l")),
                                          T.n(.xy(x: 0.8, y: 0),
                                              Z_2Tree,
                                              T.n(.yRange(x: 0.9, y: 1...5, op: .or), .r("2"), .r("l"))))),
                                  T.n(.bL,
                                      T.n(.r3,
                                          .r("2"),
                                          T.n(.xy(x: 0.8, y: 0),
                                              .r("Z"),
                                              T.n(.yRange(x: 0, y: 5...6, op: .and), .r("&"), l_1Tree))),
                                      T.n(.lC,
                                          T.n(.sobaka,
                                              .r("@"),
                                              T.n(.xRange(x: 8...10, y: 0.35, op: .or),
                                                  T.n(.xy(x:0.05, y: 0.1),
                                                      .r("Q"),
                                                      T.n(.yRange(x: 0.85, y: 3...6, op: .someFalse),
                                                          .r("6"),
                                                          .r("d"))),
                                                  T.n(.yRange(x:0, y:2...4, op: .someFalse), .r("&"), .r("G")))),
                                          t84AndTree))),
                              T.n(.tL,
                                  T.n(.ratio(>, 1.3),
                                      T.n(.xy(x: 0.05, y: 0.5),
                                          T.n(.xRange(x: 4...10, y: 0.5, op: .or),
                                              T.n(.xRange(x: 6...10, y: 0.7, op: .or),
                                                  T.n(.xRange(x: 4...5, y: 0.95, op: .and), .r("b"), .r("k")),
                                                  //sc11 l там она не такая как все
                                                .r("l")),
                                              T.n(.yRangeP(x: 0.7, y: 0...3, op: .or, p: 110),
                                                  .r("t"),
                                                  T.n(.L_l, .r("L"), .r("l")))),
                                          .r("l")),
                                      .r("M")),
                                  T.n(.bL,
                                      .r("1"),
                                      T.n(.yRange(x: 0.9, y: 4...7, op: .and),
                                          .r("d"),
                                          t4AndTree))))
// MARK: nnpp
private let nnppSubTree = T.n(.bC,
                              T.n(.tL,
                                  T.n(.tR,
                                      T.n(.yRange(x: 0.05, y: 6...7, op: .and),
                                          .r("B"),
                                          T.n(.Z_S,
                                              .r("Z"),
                                              T.n(.xy(x: 0.1, y: 0.3), .r("S"), .r("3")))),
                                      T.n(.lC,
                                          T.n(.tCr,
                                              T.n(.botCircleLeft,
                                                  .r("B"),
                                                  nS_5Tree),
                                              .r("b")),
                                          T.n(.xy(x:1, y:0.7), .r("3"), .r("}")))),
                                  T.n(.yRange(x: 0.05, y: 6...7, op: .and),
                                      .r("B"),
                                      T.n(.Z_S,
                                          .r("Z"),

                                          T.n(.S_Dollar,
                                              .r("S"),
                                              T.n(.vLine(l: 7...8, x: 4...6, op: .and, mainOp: .or),
                                                  .r("$"),
                                                  .r("6")))))),
                              T.n(.tR,
                                  T.n(.tL, PF75Tree, .r("/")),
                                  T.n(.xy(x:0.95, y: 0.3), .r("P"), .r("}"))))
// MARK: nnpn
private let nnpnSubTree = T.n(.bC,
                              T.n(.tL,
                                  T.n(.r6,
                                      T.n(.botCircleLeft,
                                          T.n(.yRange(x: 0.05, y: 4...6, op: .and),
                                              T.n(.yRange(x: 0.9, y: 4...5, op: .and),
                                                  .r("0"), .r("B")),
                                              T.n(.vLine(l: 1...3, x: 4...6, op: .and, mainOp: .or), .r("$"), .r("8"))),
                                          T.n(.topCircleRight,
                                              T.n(.topCircleLeft, .r("9"), .r("3")),
                                              nS_5Tree)),
                                      T.n(.tCr,
                                          .r("T"),
                                          T.n(.vLine(l: 6...9, x: 7...8, op: .allFalse, mainOp: .or),
                                              .r("Y"),
                                              .r("V")))),
                                  T.n(.lC,
                                      T.n(.sobaka,
                                          .r("@"),
                                          T.n(.xy(x: 0, y: 0.45),
                                              n469GTree,
                                              .r("8"))),
                                      T.n(.xy(x:0.95, y: 2/3),
                                          T.n(.xy(x:0.1, y: 1/3),
                                              //sssss
                                              asterixOr83SDollarTree,
                                              T.n(.xy(x:0.1, y: 1/5),
                                                  n83SDollarTree,
                                                  T.n(.not5, n83Tree, .r("5")))),
                                          T.n(.f_t,
                                              .r("f"),
                                              T.n(.xy(x: 0.1, y: 0.1), .r("l"), .r("t")))))),
    n7fWDollarSlashTree)
// MARK: nnnp
private let nnnpSubTree = T.n(.xy(x:0.05, y: 0.95),
                              T.n(.rCr,
                                  T.n(.tCr,
                                      T.n(.lC,
                                          T.n(.p_d,
                                              T.n(.yRange(x: 0.9, y: 8...9, op: .or), nB5Tree, PF7Tree),
                                              T.n(.yRange(x:0, y: 7...9, op: .someFalse),
                                                  .r("9"),
                                                  T.n(.xRange(x: 8...10, y: 0.8, op: .or), .r("D"), .r("P")))),
                                          T.n(.xy(x:0.05, y: 0.3),
                                              .r("5"),
                                              T.n(.yRange(x: 1, y: 6...8, op: .and),
                                                  .r("J"),
                                                  braceOrRoundR))),
                                      T.n(.tR,
                                          .r("U"),
                                          T.n(.lCr, .r("b"), .r("}")))),
                                  BbPF75Tree),
                              T.n(.bC,
                                  T.n(.lC,
                                      T.n(.tCr, .r("5"), .r("U")),
                                      T.n(.xRange(x: 8...10, y: 0.05, op: .or),
                                          .r("V"),
                                          .r("l"))),
                                  n7fWDollarTree))
// MARK: nnnn
private let nnnnSubTree = T.n(.rCr,
                              T.n(.lC,
                                  T.n(.bC,
                                      T.n(.not5,
                                          T.n(.O_G,
                                              T.n(.xRange(x: 1...2, y: 0.1, op: .or),
                                                  O_0Tree, .r("d")),
                                              G6Tree),
                                          n59Tree),
                                      T.n(.xy(x: 0, y: 0.3),
                                          T.n(.yRange(x: 0.5, y: 0...1, op: .or), QP4AndTree, .r("U")),
                                          T.n(.yRange(x: 0.3, y: 9...20, op: .or), .r("d"), .r("4")))),
                                  T.n(.tR,
                                      .r("J"),
                                      T.n(.xRange(x: 6...9, y: 0.6, op: .allFalse),
                                          .r("r"),
                                          n59Tree))),
                              T.n(.G_C,
                                  T.n(.left4,
                                      .r("4"),
                                      T.n(.botCircleLeft, G6Tree, .r("5"))),
                                  T.n(.lC,
                                      T.n(.bC, .r("C"), Q4AndfTree),
                                      T.n(.yRange(x: 0.5, y: 1...4, op: .or),
                                          T.n(.n4_f,
                                              T.n(.xRange(x: 5...9, y: 0.6, op: .or),
                                                  .r("4"),
                                                  T.n(.yRange(x: 0.05, y: 4...6, op: .and),
                                                      .r("("),
                                                      .r("t"))),
                                              f_tTree),
                                          .r("l")))))

// MARK: Helper
private let asterixOr83SDollarTree = T.n(.ratio(<, 1.2), .r("*"), n83SDollarTree)
private let O_0Tree = T.n(.yRange(x:0.5, y: 4...6, op: .allFalse ), .r("O"), .r("0"))
private let l_1Tree = T.n(.l_1,
                          .r("l"),
                          T.n(.i_1, .r("i"), .r("1")))
private let f_tTree = T.n(.f_t, .r("f"), .r("t"))
private let RKkTree = T.n(.R_K,
                          .r("R"),
                          T.n(.K_k, .r("K"), .r("k")))

private let nS_5Tree = T.n(.S_5, .r("S"), .r("5"))
private let Q4AndTree = T.n(.yRange(x:0, y: 2...6, op: .and ),
                            T.n(.yRange(x: 0.5, y: 4...5, op: .allFalse), .r("Q"), .r("N")),
                            T.n(.xRange(x: 1...3, y: 0.95, op: .allFalse), .r("4"), .r("&")))
private let Q4AndfTree = T.n(.yRange(x:0, y: 2...6, op: .and ),
                             T.n(.yRange(x: 0.5, y: 4...5, op: .allFalse),
                                 .r("Q"),
                                 T.n(.xRange(x: 9...10, y: 0.7, op: .or), .r("N"), .r("f"))),
                             T.n(.xRange(x: 1...3, y: 0.95, op: .allFalse), .r("4"), .r("&")))
private let QP4AndTree = T.n(.yRange(x:0, y: 2...6, op: .and ),
                             T.n(.yRange(x: 0.5, y: 4...5, op: .allFalse),
                                 T.n(.yRange(x: 0.5, y: 7...9, op: .or), .r("Q"), .r("P")),
                                 .r("N")),
                             T.n(.xRange(x: 1...3, y: 0.95, op: .allFalse), .r("4"), .r("&")))

private let G_0Tree = T.n(.G_0, .r("G"), .r("0"))
private let G6Tree = T.n(.vLine(l: 4...6, x: 2...4, op: .allFalse, mainOp: .or), .r("G"), .r("6"))
private let G_8Tree = T.n(.G_8, .r("G"), .r("8"))
private let BbPF75Tree = T.n(.tCr,
                             T.n(.yRange(x:0.05, y: 6...7, op: .someFalse),
                                 T.n(.botCircleLeft, .r("C"), .r("5")),
                                 T.n(.xy(x: 0.5, y: 0.95), .r("B"), PF75Tree)),
                             .r("b"))
private let PF7Tree = T.n(.topCircleRight,
                          T.n(.lCr, .r("P"), .r("7")),
                          .r("F"))
private let PF75Tree = T.n(.topCircleRight,
                           T.n(.lCr, .r("P"), .r("7")),
                           T.n(.xRange(x:8...10, y: 0.8, op: .or), .r("5"), .r("F")))

private let n7fWDollarTree = T.n(.n7_W, T.n(.xy(x: 0.05, y: 0.5), .r("P"), .r("7")),
                                 T.n(.ratio(>, 1.4),
                                     T.n(.yRange(x: 0.95, y: 7...9, op: .or), .r("$"), .r("f")),
                                     T.n(.xRange(x:7...10, y: 0.3, op: .or), .r("W"), .r("$")) ))

private let n7fWDollarSlashTree = T.n(.n7_W,
                                      T.n(.xRange(x: 7...9, y: 0.3, op: .or),
                                          .r("7"),
                                          T.n(.xy(x: 0.9, y: 0.1), .r("T"), .r("l"))),
                                      T.n(.ratio(>, 1.4),
                                          T.n(.yRange(x: 0.95, y: 7...9, op: .or),
                                              dollarOrWTree,
                                              T.n(.yRange(x: 0.1, y: 2...3, op: .or),
                                                  T.n(.xy(x: 0.9, y: 0.7), .r("H"), .r("f")),
                                                  .r("/"))),
                                          dollarOrWTree))
private let dollarOrWTree = T.n(.xRange(x:7...10, y: 0.3, op: .or), .r("W"), .r("$"))
private let braceOrRoundL = T.n(.yRange(x: 0.1, y: 3...6, op: .and), roundOrSquareL, .r("{"))
private let braceOrRoundLOne = T.n(.yRange(x: 0.05, y: 3...6, op: .and), roundOrSquareL, .r("{"))
private let braceOrRoundR = T.n(.yRange(x: 0.85, y: 3...6, op: .and), .r(")"), .r("}"))
private let roundOrSquareR = T.n(.yRange(x: 1, y: 7...9, op: .and), .r("]"), .r(")"))
private let roundOrSquareL = T.n(.yRange(x: 0, y: 7...9, op: .and), .r("["), .r("("))
private let n59Tree = T.n(.topCircleRight, .r("9"), .r("5"))
private let nB5Tree = T.n(.topCircleRight, .r("B"), .r("5"))
private let n83SDollarTree = T.n(.r3, n893Tree, SDollarTree)
//2 места
private let n893Tree = T.n(.botCircleLeft,
                           .r("8"),
                           T.n(.topCircleLeft, .r("9"), .r("3")))
private let n83Tree = T.n(.botCircleLeft, .r("8"), .r("3"))
private let SDollarTree = T.n(.S_Dollar, .r("S"), .r("$"))
private let  Z_2Tree = T.n(.xy(x: 0.9, y: 0.3), .r("2"), .r("Z"))
//2 места
private let t84AndTree = T.n(.t_4,
                             T.n(.vLine(l: 3...7, x: 3...5, op: .and, mainOp: .or),
                                 T.n(.i_t, .r("i"), .r("t")),
                                 T.n(.botCircleLeft, .r("8"), .r("S"))),
                             T.n(.xRange(x:2...6, y:0.9, op: .and),
                                 T.n(.yRange(x: 0.9, y: 1...4, op: .and), .r("d"), .r("&")),
                                 T.n(.xRange(x: 1...3, y: 0.95, op: .allFalse), .r("4"), .r("&"))))
private let t4AndTree = T.n(.t_4,
                            .r("t"),
                            T.n(.xRange(x:2...6, y:0.9, op: .and),
                                T.n(.yRange(x: 0.9, y: 1...4, op: .and), .r("d"), .r("&")),
                                T.n(.xRange(x: 1...3, y: 0.95, op: .allFalse), .r("4"), .r("&"))))

private let n469GTree =  T.n(.yRange(x: 0.95, y: 4...7, op: .and),
                             T.n(.topCircleRight,
                                 T.n(.G_0,
                                     .r("G"),
                                     T.n(.botCircleLeft, .r("0"), .r("9"))),
                                 .r("6")),
                             T.n(.botCircleLeft,
                                 T.n(.xRange(x: 0...3, y: 0.95, op: .or),
                                     G6Tree,
                                     .r("4")),
                                 .r("9")))
