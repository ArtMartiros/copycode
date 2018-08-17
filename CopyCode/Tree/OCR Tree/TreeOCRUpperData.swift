//
//  TreeOCRUpperData.swift
//  CopyCode
//
//  Created by Артем on 17/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

let upperOCRTree: TreeOCR = .n(.ratio(>, 2.63), pSubTree, nSubTree)


//MARK:-------------------------1 LEVEL-----------------------------
private let pSubTree: TreeOCR = .n(.rCr,
                                   .n(.tR, .r("]") , .r(")")),
                                   .n(.lCr,
                                      .n(.tL, .r("["), .r("(")),
                                      .n(.bL, .r("I"), .r("1"))))


private let nSubTree: TreeOCR = .n(.bR, npSubTree, nnSubTree)


//MARK:-------------------------2 LEVEL-----------------------------

private let npSubTree: TreeOCR = .n(.bC, nppSubTree, npnSubTree)
private let nnSubTree: TreeOCR = .n(.c, nnpSubTree, nnnSubTree )



//MARK: -------------------------3 LEVEL-----------------------------

private let nppSubTree: TreeOCR = .n(.tR, npppSubTree, nppnSubTree)
private let npnSubTree: TreeOCR = .n(.tCr,
                                     .n(.tL,
                                        RKkTree,
                                        .n(.bL,
                                           .r("A"),
                                           .n(.lC, Q4AndTree, .r("t")))),
                                     .n(.xy(x: 0.95, y: 0.7),
                                        .n(.tR,
                                           .n(.lC,
                                              .n(.notH,
                                                 .n(.xRange(x: 7...9, y: 0.8, op: .and), .r("N"), .r("M")),
                                                 .r("H")),
                                              .r("1")),
                                           .r("h")),
                                        .n(.lC,
                                           RKkTree,
                                           .r("X"))))

private let nnpSubTree: TreeOCR = .n(.bL, nnppSubTree, nnpnSubTree)
private let nnnSubTree: TreeOCR = .n(.tL,
                                     .n(.xy(x:0.05, y: 0.95),
                                        .n(.rCr,
                                           .n(.tCr,
                                              .n(.lC,
                                                 .n(.p_d,
                                                    PF75Tree,
                                                    .n(.yRange(x:0, y: 7...9, op: .someFalse), .r("9"), .r("D"))),
                                                 .n(.xy(x:0.05, y: 0.3), .r("5"), .r("}"))),
                                              .n(.tR, .r("U"), .r("b"))),
                                           BbPF75Tree),
                                        .n(.bC,
                                           .n(.lC,
                                              .n(.tCr, .r("5"), .r("U")),
                                              .r("V")),
                                           n7fWDollarTree)),
                                     .n(.rCr,
                                        .n(.lC,
                                           .n(.bC,
                                              .n(.not5,
                                                 .n(.O_G,
                                                    .n(.yRange(x:0.5, y: 4...6, op: .allFalse ), .r("O"), .r("0")),
                                                    G6Tree),
                                                 n59Tree),
                                              .n(.xy(x: 0, y: 0.3), Q4AndTree, .r("4"))),
                                           .n(.tR, .r("J"), n59Tree)),
                                        .n(.G_C,
                                           .n(.left4,
                                              .r("4"),
                                              .n(.botCircleLeft, G6Tree, .r("5"))),
                                           .n(.lC,
                                              .n(.bC, .r("C"), Q4AndTree),
                                              .n(.n4_f, .r("4"), .r("f"))))))


//MARK: -------------------------4 LEVEL-----------------------------

private let npppSubTree: TreeOCR = .n(.bL,
                                      .n(.lC,
                                         .n(.tCr,
                                            .n(.topCircleRight, .r("B"), .r("E")),
                                            .r("M")),
                                         .n(.I_Z, .r("I"), .r("Z"))),
                                      .n(.G_C,
                                         .n(.tCr,
                                            .n(.yRange(x:0.95, y: 4...6, op: .someFalse),
                                               .n(.botCircleLeft, .r("G"), .r("S")),
                                               .n(.O_Q, .r("O"), .r("Q"))),
                                            .r("d")),
                                         .n(.ratio(>, 2), .r("{"), .r("C"))))

private let nppnSubTree: TreeOCR = .n(.tCr,
                                      .n(.tL,
                                         .n(.lC,
                                            .r("E"),
                                            .n(.xy(x: 0.8, y: 0),
                                               .n(.xy(x: 0.9, y: 0.3), .r("2"), .r("Z")),
                                               .n(.yRange(x: 0.95, y: 1...5, op: .or), .r("2"), .r("l")))),
                                         .n(.bL,
                                            .n(.r3,
                                               .r("2"),
                                               .n(.xy(x: 0.8, y: 0), .r("Z"), .r("1"))),
                                            .n(.lC,
                                               .n(.asterix,
                                                  .r("@"),
                                                  .n(.xRange(x: 8...10, y: 0.35, op: .or),
                                                     .r("Q"),
                                                     .n(.yRange(x:0, y:2...4, op: .someFalse), .r("&"), .r("G")))),
                                               t4AndTree))),
                                      .n(.tL,
                                         .n(.ratio(>, 1.3),
                                            .n(.xy(x: 0.05, y: 0.5),
                                               .n(.xRange(x: 4...10, y: 0.5, op: .or), .r("b"), .r("L"))
                                                , .r("l")),
                                            .r("M")),
                                         .n(.bL,
                                            .r("1"), t4AndTree)))


private let nnppSubTree: TreeOCR = .n(.bC,
                                      .n(.tL,
                                         .n(.tR,
                                            .r("Z"),
                                            .n(.lC,
                                               .n(.tCr, .r("B"), .r("b")),
                                               .n(.xy(x:1, y:0.7), .r("3"), .r("}")))),
                                         .n(.Z_S, .r("Z"), SDollarTree)),
                                      .n(.tR,
                                         .n(.tL, PF75Tree,.r("/")),
                                         .n(.xy(x:0.95, y: 0.3), .r("P"), .r("}"))))

private let nnpnSubTree: TreeOCR = .n(.bC,
                                      .n(.tL,
                                         .n(.r6,
                                            .n(.botCircleLeft,
                                               .r("8"),
                                               .n(.topCircleRight,
                                                  .n(.topCircleLeft, .r("9"), .r("3")),
                                                  nS_5Tree)),
                                            .n(.tCr, .r("T"), .r("Y"))),
                                         .n(.lC,
                                            .n(.asterix,
                                               .r("@"),
                                               .n(.xy(x: 0, y: 0.45),
                                                  n469GTree,
                                                  .r("8"))),
                                            .n(.xy(x:0.95, y: 2/3),
                                               .n(.xy(x:0.1, y: 1/3),
                                                  n83SDollarTree,
                                                  .n(.xy(x:0.1, y: 1/5),
                                                     n83SDollarTree,
                                                     .n(.not5, n83Tree, .r("5")))),
                                               .n(.f_t, .r("f"), .r("t"))))),
                                      n7fWDollarTree)

//MARK: Helper

private let RKkTree: TreeOCR = .n(.R_K,
                                  .r("R"),
                                  .n(.K_k, .r("K"), .r("k")))

private let nS_5Tree: TreeOCR = .n(.xRange(x: 7...10, y: 0.2, op: .or), .r("S"), .r("5"))
private let Q4AndTree: TreeOCR = .n(.yRange(x:0, y: 2...6, op: .and ),
                                    .r("Q"),
                                    .n(.xRange(x: 1...3, y: 0.95, op: .allFalse), .r("4"), .r("&")))

private let G_0Tree: TreeOCR = .n(.G_0, .r("G"), .r("0"))
private let G6Tree: TreeOCR = .n(.G_6, .r("G"), .r("6"))

private let BbPF75Tree: TreeOCR = .n(.tCr,
                                    .n(.yRange(x:0.05, y: 6...7, op: .someFalse), .r("5"),
                                       .n(.xy(x: 0.5, y: 0.95), .r("B"), PF75Tree)),
                                    .r("b"))

private let PF75Tree: TreeOCR = .n(.topCircleRight,
                                   .n(.lCr, .r("P"), .r("7")),
                                   .n(.xRange(x:8...10, y: 0.8, op: .or), .r("5"), .r("F")))

private let n7fWDollarTree: TreeOCR = .n(.n7_W, .r("7"),
                                   .n(.f_W,
                                      .r("f"),
                                      .n(.xRange(x:7...10, y: 0.3, op: .or), .r("W"), .r("$")) ))
private let n59Tree: TreeOCR = .n(.topCircleRight, .r("9"), .r("5"))


private let n83SDollarTree: TreeOCR = .n(.r3, n83Tree, SDollarTree)
//2 места
private let n83Tree: TreeOCR = .n(.botCircleLeft, .r("8"), .r("3"))
private let SDollarTree: TreeOCR = .n(.S_Dollar, .r("S"), .r("$"))

//2 места
private let t4AndTree: TreeOCR = .n(.t_4,
                                      .r("t"),
                                      .n(.xRange(x:2...6, y:0.9, op: .and),
                                         .r("&"),
                                         .n(.xRange(x: 1...3, y: 0.95, op: .allFalse), .r("4"), .r("&"))))





private let n469GTree: TreeOCR =  .n(.yRange(x: 0.95, y: 4...7, op: .and),
                                       .n(.topCircleRight,
                                          .n(.G_0,
                                             .r("G"),
                                             .n(.botCircleLeft, .r("0"), .r("9"))),
                                          .r("6")),
                                       .n(.botCircleLeft,
                                          .n(.xRange(x: 0...3, y: 0.95, op: .or), .r("G"), .r("4")),
                                          .r("9")))










