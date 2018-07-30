//
//  TreeData.swift
//  CopyCode
//
//  Created by Артем on 18/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

private let BpTree: Tree = .n(.xy(x: 1, y: 4/6), .r("B"), .r("P"))
private let BpOrbTree: Tree = .n(.tCr, BpTree, .r("b"))
private let n7_WTree: Tree = .n(.n7_W, .r("7"),
                                .n(.f_W, .r("f"), .r("W")))
private let num83Tree: Tree = .n(.n8_3, .r("8"), .r("3"))
private let num83orSTree: Tree = .n(.r3, num83Tree, .r("S"))

private let nppSubTree: Tree = .n(.tR,
                                  .n(.bL,
                                     .n(.lC,
                                        .n(.tCr, .r("E"), .r("M")),
                                        .n(.I_Z, .r("I"), .r("Z"))),
                                     .n(.G_C,
                                        .n(.tCr, .r("G"), .r("d")),
                                        .r("C"))),
                                  .n(.tCr,
                                     .n(.tL,
                                        .n(.lC,
                                           .r("E"),
                                           .n(.xy(x: 0.8, y: 0),
                                              .n(.xy(x: 0, y: 0.3), .r("2"), .r("Z")),
                                              .r("l"))),
                                        .n(.bL,
                                           .n(.r3,
                                              .r("2"),
                                              .n(.xy(x: 0.8, y: 0), .r("Z"), .r("1"))),
                                           .n(.lC,
                                              .r("Q"),
                                              .n(.t_4, .r("t"), .r("4"))))),
                                     .n(.tL,
                                        .n(.ratio(1.3, <), .r("L"), .r("M")),
                                        .n(.bL, .r("1"), .r("4")))))

private let npnSubTree: Tree = .n(.tCr,
                                  .n(.tL,
                                     .r("R"),
                                     .n(.bL,
                                        .r("A"),
                                        .n(.lC, .r("Q"), .r("t")))),
                                  .n(.rC,
                                     .n(.tR,
                                        .n(.lC,
                                           .n(.H_N,
                                              .r("H"),
                                              .n(.c, .r("N"), .r("M"))),
                                           .r("1")),
                                        .r("h")),
                                     .n(.lC,
                                        .n(.r_k,
                                           .r("R"),
                                           .n(.K_k, .r("K"), .r("k"))),
                                        .r("X"))))

private let nnpSubTree: Tree = .n(.bL,
                                  .n(.bC,
                                     .n(.tL,
                                        .n(.tR,
                                           .r("Z"),
                                           .n(.tCr, .r("B"), .r("b"))),
                                        .n(.z_s, .r("Z"), .r("S"))), // если не прижат к краю
                                    .n(.tR, .r("F"), .r("P"))),
                                  .n(.bC,
                                     .n(.tL,
                                        .n(.r6,
                                            num83Tree,
                                            .n(.tCr, .r("T"), .r("Y"))),
                                        .n(.lC,
                                           .n(.xy(x: 0, y: 0.45),
                                              .n(.O_G, .r("0"), .r("G")),
                                              .r("8")),
                                           .n(.xy(x:1, y: 2/3),
                                              .n(.xy(x:0.1, y: 1/3),
                                                 num83orSTree,
                                                 .n(.xy(x:0.1, y: 1/5),
                                                    num83orSTree,
                                                    .n(.not5, num83Tree, .r("5")))),
                                              .n(.f_t, .r("f"), .r("t"))))),
                                        n7_WTree))


private let nnnSubTree: Tree = .n(.tL,
                                  .n(.bL,
                                     .n(.rC,
                                        .n(.tCr,
                                           .n(.p_d, .r("P"), .r("D")),
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
                                           .n(.xy(x: 0, y: 0.3), .r("Q"), .r("4"))),
                                        .n(.tR, .r("J"), .r("9"))),
                                     .n(.G_C,
                                        .n(.lCr,
                                           .n(.G_65,
                                              .r("G"),
                                              .n(.not5, .r("6"), .r("5"))),
                                           .r("4")),
                                        .n(.lC,
                                           .n(.bC, .r("C"), .r("Q")),
                                           .n(.n4_f, .r("4"), .r("f"))))))

private let nnSubTree: Tree = .n(.c, nnpSubTree, nnnSubTree )
private let npSubTree: Tree = .n(.bC, nppSubTree, npnSubTree)
private let nSubTree: Tree = .n(.bR, npSubTree, nnSubTree)
private let pSubTree: Tree =  .n(.bL, .r("I"), .r("1"))

let upperTree: Tree = .n(.ratio(2.5, <), pSubTree, nSubTree) //можно здесь заменить на проверку замкнутости

let lowTree: Tree = .n(.xy(x:0, y:0.05),
                         .n(.lC,
                            .n(.rC,
                               .n(.ratio(1.1, >),
                                  .r("m"),
                                  .n(.n_u, .r("n"), .r("u"))),
                               .r("r") ),
                            .n(.tCr,
                               .n(.bC,
                                  .n(.xy(x:0.95, y:0),
                                     .n(.bR, .r("z"), .r("r")),
                                     .n(.xy(x: 0.95, y: 0.6),.r("s"), .r("i"))),
                                  .r("w")),
                               .n(.xy(x:0.05, y:1),
                                  .n(.bC, .r("r"), .r("x")),
                                  .r("v")))),
                         .n(.c,
                            .n(.lC,
                               .r("e"),
                               .n(.xy(x:0, y: 0.3),
                                  .r("s"),
                                  .n(.bL, .r("z"), .r("a")))),
                            .n(.rC,
                               .n(.xy(x:1, y: 0.2), .r("a"), .r("o")),
                               .n(.bL, .r("r"), .r("c")))))

let lowWithTailTree: Tree = .n(.xy(x:0, y:0.05),
                               .n(.lC,
                                  .r("p"),
                                  .n(.rC, .r("j"), .r("y"))),
                               .n(.xy(x:0.1, y: 0.33),
                                  .n(.bC, .r("g"), .r("q")),
                                  .r("j")))
