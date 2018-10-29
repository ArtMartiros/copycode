//
//  TreeLetterType.swift
//  CopyCode
//
//  Created by Артем on 03/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation
//Бинарное древо, отвечающее за определение типа буквы
typealias TreeType = Tree<LetterTypeOperations, LetterType>

private let kUpperMaxRatio: CGFloat = 0.78
private let kLowMaxRatio: CGFloat = 0.5//0.622
private let kCommaMaxRatio: CGFloat = 0.37

private let tailOrUpper: TreeType = .n(.isLowWithTail, .r(.lowWithTail), .r(.upper))
private let quotesOrColumnTree: TreeType = .n(.quotesOrColumn,
                                              .r(.quote),
                                              .n(.dashOrComma, .r(.dashOrHyphen), .r(.comma)))
private let dotsOrDash: TreeType = .n(.squareForDot,
                                      .r(.dot),
                                      .n(.bottomY, .r(.underscore), .r(.dashOrHyphen)))

let undefinedTypeTree: TreeType = TreeType.n(.maxHRatio(>, kUpperMaxRatio),
                                             tailOrUpper,
                                             TreeType.n(.maxHRatio(>, kLowMaxRatio),
                                                        .r(.low),
                                                        TreeType.n(.maxHRatio(>, kCommaMaxRatio),
                                                                   quotesOrColumnTree,
                                                                   dotsOrDash)))

private let kGridOnlyUpperMaxRatio: CGFloat = 0.8
private let kGridUpperMaxRatio: CGFloat = 0.59
private let kGridLowMaxRatio: CGFloat = 0.45
private let kGridCommaMaxRatio: CGFloat = 0.24

let quotesOrDots: TreeType = .n(.maxHRatio(>, kGridCommaMaxRatio),
                                quotesOrColumnTree,
                                dotsOrDash)

let gridTailOrUpper: TreeType = .n(.isLowWithTailCustom, .r(.lowWithTail), .r(.upper))

let gridUndefineType: TreeType = TreeType.n(.maxHRatio(>, kGridOnlyUpperMaxRatio),
                                            TreeType.r(.upper),
                                            TreeType.n(.maxHRatio(>, kGridUpperMaxRatio),
                                                       gridTailOrUpper,
                                                       TreeType.n(.maxHRatio(>, kGridLowMaxRatio),
                                                                  .r(.low),
                                                                  quotesOrDots)))

let gridOnlyLowType: TreeType = .n(.maxHRatio(>, kGridUpperMaxRatio),
                                   .r(.undefined),
                                   .n(.maxHRatio(>, kGridLowMaxRatio),
                                      .r(.low),
                                      .r(.undefined)))
let gridWithOutLowType: TreeType = .n(.maxHRatio(>, kGridUpperMaxRatio),
                                      .r(.undefined),
                                      .n(.maxHRatio(>, kGridLowMaxRatio),
                                         .r(.low),
                                         .r(.undefined)))
