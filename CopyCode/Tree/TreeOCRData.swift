//
//  TreeOCRData.swift
//  CopyCode
//
//  Created by Артем on 03/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

typealias TreeOCR = Tree<OCROperations, String>
private let s_rTree:TreeOCR = .n(.xy(x: 0.95, y: 0.6), .r("s"), .r("r"))
private let n4_AndTree: TreeOCR =  .n(.xRange(x: 1...3, y: 0.95, op: .allFalse), .r("4"), .r("&"))
private let n5_3Tree: TreeOCR = .n(.n5_9, .r("5"), .r("3"))
private let nS_5Tree: TreeOCR = .n(.xRange(x: 7...10, y: 0.2, op: .or), .r("S"), .r("5"))
private let Q_AndTree: TreeOCR = .n(.yRange(x:0, y: 2...6, op: .and ), .r("Q"), n4_AndTree)
private let OOr0Tree: TreeOCR = .n(.yRange(x:0.5, y: 4...6, op: .allFalse ), .r("O"), .r("0"))
private let G_0Tree: TreeOCR =  .n(.G_0, .r("G"), .r("0"))
private let FPTree: TreeOCR = .n(.F_P,
                                 .n(.xRange(x:8...10, y: 0.8, op: .or), .r("5"), .r("F")),
                                 .n(.lCr, .r("P"), .r("7")))
private let EBTree: TreeOCR = .n(.F_P, .r("E"), .r("B"))
private let BpTree: TreeOCR = .n(.xy(x: 0.5, y: 0.95), .r("B"), FPTree)
private let n5_BpTree: TreeOCR = .n(.yRange(x:0.05, y: 6...7, op: .someFalse), .r("5"), BpTree)
private let BpOrbTree: TreeOCR = .n(.tCr, n5_BpTree, .r("b"))
private let b_LTree: TreeOCR = .n(.xRange(x: 4...10, y: 0.5, op: .or), .r("b"), .r("L"))
private let n7_WTree: TreeOCR = .n(.n7_W, .r("7"),
                                   .n(.f_W,
                                      .r("f"),
                                      .n(.xRange(x:7...10, y: 0.3, op: .or), .r("W"), .r("$")) ))
private let num59Tree: TreeOCR = .n(.n5_9, .r("5"), .r("9"))
private let num83Tree: TreeOCR = .n(.n8_3, .r("8"), .r("3"))
private let SOrDollarTree: TreeOCR = .n(.S_dollar, .r("S"), .r("$"))
private let num83orSTree: TreeOCR = .n(.r3, num83Tree, SOrDollarTree)
private let n4_9Tree: TreeOCR =  .n(.yRange(x: 0.95, y: 0...3, op: .allFalse),
                                    .r("4"),
                                    .r("9"))
private let tOr4SubTree: TreeOCR = .n(.t_4,
                                      .r("t"),
                                      .n(.xRange(x:2...6, y:0.9, op: .and),
                                         .r("&"),
                                         .n(.xRange(x: 1...3, y: 0.95, op: .allFalse), .r("4"), .r("&"))))
private let npppSubTree: TreeOCR = .n(.bL,
                                      .n(.lC,
                                         .n(.tCr, EBTree, .r("M")),
                                         .n(.I_Z, .r("I"), .r("Z"))),
                                      .n(.G_C,
                                         .n(.tCr,
                                            .n(.yRange(x:0.95, y: 4...6, op: .someFalse),
                                               .n(.G_S, .r("G"), .r("S")),
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
                                               
                                               tOr4SubTree))),
                                      .n(.tL,
                                         .n(.ratio(>, 1.3),
                                            .n(.xy(x: 0.05, y: 0.5), b_LTree, .r("l")),
                                            .r("M")),
                                         .n(.bL,
                                            .r("1"), tOr4SubTree)))
private let nppSubTree: TreeOCR = .n(.tR, npppSubTree, nppnSubTree)

private let npnSubTree: TreeOCR = .n(.tCr,
                                     .n(.tL,
                                        .n(.R_K, .r("R"), .r("K")),
                                        .n(.bL,
                                           .r("A"),
                                           .n(.lC, Q_AndTree, .r("t")))),
                                     .n(.xy(x: 0.95, y: 0.7),
                                        .n(.tR,
                                           .n(.lC,
                                              .n(.H_N,
                                                 .r("H"),
                                                 .n(.xRange(x: 7...9, y: 0.8, op: .and), .r("N"), .r("M"))),
                                              .r("1")),
                                           .r("h")),
                                        .n(.lC,
                                           .n(.r_k,
                                              .r("R"),
                                              .n(.K_k, .r("K"), .r("k"))),
                                           .r("X"))))
private let nnppSubTree: TreeOCR = .n(.bC,
                                        .n(.tL,
                                           .n(.tR,
                                              .r("Z"),
                                              .n(.lC,
                                                 .n(.tCr, .r("B"), .r("b")),
                                                 .n(.xy(x:1, y:0.7), .r("3"), .r("}")))),
                                           .n(.z_s, .r("Z"), SOrDollarTree)), // если не прижат к краю
                                        .n(.tR,
                                           .n(.tL, FPTree,.r("/")),
                                           .n(.xy(x:0.95, y: 0.3), .r("P"), .r("}"))))
private let n469gTree: TreeOCR =    .n(.yRange(x: 0.95, y: 4...7, op: .and),
                                       .n(.n6_zero,
                                          .r("6"),
                                          .n(.G_0,
                                             .r("G"),
                                             .n(.n9_zero, .r("9"), .r("0")))),
                                       .n(.G_9, .r("G"), n4_9Tree))
private let nnpnSubTree: TreeOCR = .n(.bC,
                                        .n(.tL,
                                           .n(.r6,
                                              .n(.n8_3,
                                                 .r("8"),
                                                 .n(.n9_3,
                                                    .n(.n5_9,
                                                       nS_5Tree,
                                                       .r("9")),
                                                    .r("3"))),
                                              .n(.tCr, .r("T"), .r("Y"))),
                                           .n(.lC,
                                              .n(.asterix,
                                                 .r("@"),
                                                 .n(.xy(x: 0, y: 0.45),
                                                    n469gTree,
                                                    .r("8"))),
                                              .n(.xy(x:0.95, y: 2/3),
                                                 .n(.xy(x:0.1, y: 1/3),
                                                    num83orSTree,
                                                    .n(.xy(x:0.1, y: 1/5),
                                                       num83orSTree,
                                                       .n(.not5, num83Tree, .r("5")))),
                                                 .n(.f_t, .r("f"), .r("t"))))),
                                        n7_WTree)
private let nnpSubTree: TreeOCR = .n(.bL, nnppSubTree, nnpnSubTree)


private let nnnSubTree: TreeOCR = .n(.tL,
                                     .n(.xy(x:0.05, y: 0.95),
                                        .n(.rC,
                                           .n(.tCr,
                                              .n(.lC,
                                                 .n(.p_d,
                                                    FPTree,
                                                    .n(.yRange(x:0, y: 7...9, op: .someFalse), .r("9"), .r("D"))),
                                                 .n(.xy(x:0.05, y: 0.3), .r("5"), .r("}"))),
                                              .n(.tR, .r("U"), .r("b"))),
                                           BpOrbTree),
                                        .n(.bC,
                                           .n(.lC,
                                              .n(.tCr, .r("5"), .r("U")),
                                              .r("V")),
                                           n7_WTree)),
                                     .n(.rCr,
                                        .n(.lC,
                                           .n(.bC,
                                              .n(.not5,
                                                 .n(.O_G,
                                                    OOr0Tree,
                                                    .n(.G_65, .r("G"), .r("6"))),
                                                 num59Tree),
                                              .n(.xy(x: 0, y: 0.3), Q_AndTree, .r("4"))),
                                           .n(.tR,.r("J"), num59Tree)),
                                        .n(.G_C,
                                           .n(.l4,
                                              .r("4"),
                                              .n(.G_65,
                                                 .r("G"),
                                                 .n(.not5, .r("6"), .r("5")))),
                                           .n(.lC,
                                              .n(.bC, .r("C"), Q_AndTree),
                                              .n(.n4_f, .r("4"), .r("f"))))))

private let nnSubTree: TreeOCR = .n(.c, nnpSubTree, nnnSubTree )
private let npSubTree: TreeOCR = .n(.bC, nppSubTree, npnSubTree)
private let nSubTree: TreeOCR = .n(.bR, npSubTree, nnSubTree)
private let pSubTree: TreeOCR = .n(.rCr,
                                   .n(.tR, .r("]") , .r(")")),
                                   .n(.lCr,
                                      .n(.tL, .r("["), .r("(")),
                                      .n(.bL, .r("I"), .r("1"))))

fileprivate let upperOCRTree: TreeOCR = .n(.ratio(>, 2.63), pSubTree, nSubTree) //можно здесь заменить на проверку замкнутости






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
                                         .n(.bC,
                                            .n(.xy(x:0.95, y:0),
                                               .n(.bR, .r("z"), s_rTree),
                                               .n(.yRange(x: 0.95, y: 6...7, op: .or),
                                                  .r("s"),
                                                  .n(.question, .r("?"), .r("i")))),
                                            .n(.question, .r("?"), .r("w"))),
                                         .n(.xy(x:0.05, y:0.95),
                                            .n(.bC,
                                               .r("r"),
                                               .n(.tR, .r("x"), .r(">"))),
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
                                      .n(.rC,
                                         .n(.yRange(x:0.5, y: 4...6, op: .or),
                                            .n(.question, .r("?"), .r("a")),
                                            .r("o")),
                                         .n(.bL,
                                            .r("r"),
                                            .n(.xy(x:0.5, y: 0.4),
                                               .r("e"),
                                               .n(.question, .r("?"),
                                                  .n(.xy(x:0.3, y: 0), .r("c"), .r("<")))))))
private let nLowSubTree: TreeOCR = .n(.xy(x:0, y:0.05), npLowSubTree, nnLowSubTree)
fileprivate let lowOCRTree: TreeOCR = .n(.ratio(>, 5), .r("!"), nLowSubTree)
private let g_qTree: TreeOCR = .n(.bC, .r("g"), .r("q"))
fileprivate let lowWithTailOCRTree: TreeOCR = .n(.xy(x:0, y:0.05),
                                                 .n(.lC,
                                                    .n(.xy(x:0.9, y: 0.8),
                                                       g_qTree,
                                                       .r("p")),
                                                    .n(.rC, .r("j"), .r("y"))),
                                                 .n(.xy(x:0.1, y: 0.33),
                                                    .n(.xy(x:0.9, y: 0.8),
                                                       g_qTree,
                                                       .r("p")) ,
                                                    .r("j")))
let dashOrHyphenOCRTree: TreeOCR = .n(.hyphenOrDash,
                                      .r("~"),
                                      .n(.equalOrDash, .r("="), .r("-")))

let commaOCRTree: TreeOCR = .n(.semicolon, .r(";"), .r(","))
let colonOCRTree: TreeOCR = .n(.colon, .r(":"), .r("."))
let quoteOCRTree: TreeOCR = .n(.ratio(>, 1), .r("'"), .r("^"))
extension LetterType {
    /// Собраны все бинарные деревья по логике определения буквы
    var treeOCR: TreeOCR {
        switch self {
        case .upper: return upperOCRTree
        case .low: return lowOCRTree
        case .lowWithTail: return lowWithTailOCRTree
        case .dashOrHyphen: return dashOrHyphenOCRTree
        case .dot: return .r(".")
        case .underscore: return .r("_")
        case .comma: return commaOCRTree
        case .quote: return quoteOCRTree
        case .undefined: return .r("...")
        }
    }
}
