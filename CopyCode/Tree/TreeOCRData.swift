//
//  TreeOCRData.swift
//  CopyCode
//
//  Created by Артем on 03/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

typealias TreeOCR = Tree<OCROperations, String>
private let QOrAndTree: TreeOCR = .n(.yRange(x:0, y: 2...6, op: .and ), .r("Q"), .r("&"))
private let FPTree: TreeOCR = .n(.tR, .r("F"), .r("P"))
private let BpTree: TreeOCR = .n(.xy(x: 0.5, y: 0.95), .r("B"), FPTree)
private let n5_BpTree: TreeOCR = .n(.yRange(x:0.05, y: 6...7, op: .someFalse), .r("5"), BpTree)
private let BpOrbTree: TreeOCR = .n(.tCr, n5_BpTree, .r("b"))
private let n7_WTree: TreeOCR = .n(.n7_W, .r("7"),
                                   .n(.f_W, .r("f"), .r("W")))
private let num83Tree: TreeOCR = .n(.n8_3, .r("8"), .r("3"))
private let SOrDollarTree: TreeOCR = .n(.S_dollar, .r("S"), .r("$"))
private let num83orSTree: TreeOCR = .n(.r3, num83Tree, SOrDollarTree)

private let nppSubTree: TreeOCR = .n(.tR,
                                     .n(.bL,
                                        .n(.lC,
                                           .n(.tCr, .r("E"), .r("M")),
                                           .n(.I_Z, .r("I"), .r("Z"))),
                                        .n(.G_C,
                                           .n(.tCr, .r("G"), .r("d")),
                                           .n(.ratio(>, 2), .r("{"), .r("C")))),
                                     .n(.tCr,
                                        .n(.tL,
                                           .n(.lC,
                                              .r("E"),
                                              .n(.xy(x: 0.8, y: 0),
                                                 .n(.xy(x: 0, y: 0.3), .r("2"), .r("Z")),
                                                 .n(.yRange(x: 0.95, y: 1...5, op: .or), .r("2"), .r("l")))),
                                           .n(.bL,
                                              .n(.r3,
                                                 .r("2"),
                                                 .n(.xy(x: 0.8, y: 0), .r("Z"), .r("1"))),
                                              .n(.lC,
                                                 .n(.asterix, .r("@"), QOrAndTree),
                                                 tOr4SubTree))),
                                        .n(.tL,
                                           .n(.ratio(>, 1.3),
                                              .n(.xy(x: 0.05, y:0.5 ), .r("L"), .r("l")),
                                              .r("M")),
                                           .n(.bL,
                                              .r("1"), tOr4SubTree))))
private let tOr4SubTree: TreeOCR = .n(.t_4,
                                      .r("t"),
                                      .n(.xRange(x:2...6, y:0.9, op: .and), .r("&"), .r("4")))
private let npnSubTree: TreeOCR = .n(.tCr,
                                     .n(.tL,
                                        .r("R"),
                                        .n(.bL,
                                           .r("A"),
                                           .n(.lC, QOrAndTree, .r("t")))),
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

private let nnpSubTree: TreeOCR = .n(.bL,
                                     .n(.bC,
                                        .n(.tL,
                                           .n(.tR,
                                              .r("Z"),
                                              .n(.lC,
                                                 .n(.tCr, .r("B"), .r("b")),
                                                 .r("}"))),
                                           .n(.z_s, .r("Z"), SOrDollarTree)), // если не прижат к краю
                                        .n(.tR,
                                           .n(.tL, .r("F"), .r("/")),
                                           .n(.xy(x:0.95, y: 0.3), .r("P"), .r("}")))),
                                     .n(.bC,
                                        .n(.tL,
                                           .n(.r6,
                                              num83Tree,
                                              .n(.tCr, .r("T"), .r("Y"))),
                                           .n(.lC,
                                              .n(.asterix,
                                                 .r("@"),
                                                 .n(.xy(x: 0, y: 0.45),
                                                    .n(.O_G, .r("0"), .r("G")),
                                                    .r("8"))),
                                              .n(.xy(x:0.95, y: 2/3),
                                                 .n(.xy(x:0.1, y: 1/3),
                                                    num83orSTree,
                                                    .n(.xy(x:0.1, y: 1/5),
                                                       num83orSTree,
                                                       .n(.not5, num83Tree, .r("5")))),
                                                 .n(.f_t, .r("f"), .r("t"))))),
                                        n7_WTree))


private let nnnSubTree: TreeOCR = .n(.tL,
                                     .n(.xy(x:0.05, y: 0.95),
                                        .n(.rC,
                                           .n(.tCr,
                                              .n(.lC,
                                                 .n(.p_d, FPTree, .r("D")),
                                                 .r("}")),
                                              .r("b")),
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
                                                 .n(.O_G, .r("O"),
                                                    .n(.G_65, .r("G"), .r("6"))),
                                                 .n(.n5_9, .r("5"), .r("9"))),
                                              .n(.xy(x: 0, y: 0.3), QOrAndTree, .r("4"))),
                                           .n(.tR, .r("J"), .r("9"))),
                                        .n(.G_C,
                                           .n(.l4,
                                              .r("4"),
                                              .n(.G_65,
                                                 .r("G"),
                                                 .n(.not5, .r("6"), .r("5")))),
                                           .n(.lC,
                                              .n(.bC, .r("C"), QOrAndTree),
                                              .n(.n4_f, .r("4"), .r("f"))))))

private let nnSubTree: TreeOCR = .n(.c, nnpSubTree, nnnSubTree )
private let npSubTree: TreeOCR = .n(.bC, nppSubTree, npnSubTree)
private let nSubTree: TreeOCR = .n(.bR, npSubTree, nnSubTree)
private let pSubTree: TreeOCR = .n(.rCr,
                                   .n(.tR, .r("]") , .r(")")),
                                   .n(.lCr,
                                      .n(.tL, .r("["), .r("(")),
                                      .n(.bL, .r("I"), .r("1"))))

fileprivate let upperOCRTree: TreeOCR = .n(.ratio(>, 2.5), pSubTree, nSubTree) //можно здесь заменить на проверку замкнутости
private let npLowSubTree:TreeOCR = .n(.lC,
                              .n(.rC,
                                 .n(.ratio(<, 1.13),
                                    .r("m"),
                                    .n(.n_u, .r("n"), .r("u"))),
                                 .r("r") ),
                              .n(.tCr,
                                 .n(.bC,
                                    .n(.xy(x:0.95, y:0),
                                       .n(.bR,
                                          .r("z"),
                                          .n(.xy(x: 0.95, y: 0.6), .r("s"), .r("r"))),
                                       .n(.xy(x: 0.95, y: 0.6),
                                          .r("s"),
                                          .n(.question, .r("?"), .r("i")))),
                                    .n(.question, .r("?"), .r("w"))),
                                 .n(.xy(x:0.05, y:0.95),
                                    .n(.bC,
                                       .r("r"),
                                       .n(.tR, .r("x"), .r(">"))),
                                    .n(.yRange(x: 0.5, y: 3...6, op: .or),
                                       .r("w"),
                                       .r("v")))))
private let nnLowSubTree:TreeOCR = .n(.c,
                                      .n(.lC,
                                         //бывает такое что первая проверка неудачна
                                        .n(.bR,
                                           .r("a"),
                                           .n(.yRange(x: 0.3, y: 0...3, op: .or), .r("e"), .r("+"))),
                                        //было изначально .xy(x:0, y: 0.23)
                                        .n(.xy(x:0.1, y: 0.25),
                                           .n(.xRange(x: 7...10, y: 0.1, op: .allFalse),
                                              .r("*"),
                                              .r("s")),
                                           .n(.bL,
                                              .n(.bC,
                                                 .n(.xy(x:0.8, y: 0.1), .r("z"), .r("i")),
                                                 .r("x")),
                                              .r("a")))),
                                      .n(.rC,
                                         .n(.yRange(x:0.5, y: 4...6, op: .or),
                                            .r("a"), .r("o")),
                                         .n(.bL,
                                            .r("r"),
                                            .n(.xy(x:0.5, y: 0.4),
                                               .r("e"),
                                               .n(.question, .r("?"),
                                                  .n(.tCr, .r("c"), .r("<")))))))
private let nLowSubTree: TreeOCR = .n(.xy(x:0, y:0.05), npLowSubTree, nnLowSubTree)
fileprivate let lowOCRTree: TreeOCR = .n(.ratio(>, 5), .r("!"), nLowSubTree)

fileprivate let lowWithTailOCRTree: TreeOCR = .n(.xy(x:0, y:0.05),
                                                 .n(.lC,
                                                    .n(.xy(x:0.9, y: 0.7), .r("g"), .r("p")),
                                                    .n(.rC, .r("j"), .r("y"))),
                                                 .n(.xy(x:0.1, y: 0.33),
                                                    .n(.xy(x:0.9, y: 0.7),
                                                       .n(.bC, .r("g"), .r("q")),
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
