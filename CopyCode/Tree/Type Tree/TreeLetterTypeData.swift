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

private let lowAndLowerTree = TreeType.n(.maxHRatio(>, kGridLowMaxRatio), .r(.low), quotesOrDots)

private let notSureTree = TreeType.n(.maxHRatio(>, kGridLowMaxRatio),
                                     notSureUpperOrLowTree,
                                     lowAndLowerTree)
private let notSureUpperOrLowTree = TreeType.n(.upperOrLowForNotSure, .r(.upper), .r(.low))

private let quotesOrColumnTree: TreeType = .n(.quotesOrColumn,
                                              .r(.quote),
                                              .n(.dashOrComma, .r(.dashOrHyphen), .r(.comma)))
private let dotsOrDash: TreeType = .n(.squareForDot,
                                      .r(.dot),
                                      .n(.bottomY, .r(.underscore), .r(.dashOrHyphen)))

private let kGridOnlyUpperMaxRatio: CGFloat = 0.8
private let kGridUpperSureMaxRatio: CGFloat = 0.64
private let kGridUpperMaxRatio: CGFloat = 0.59
private let kGridLowMaxRatio: CGFloat = 0.44
private let kGridCommaMaxRatio: CGFloat = 0.24

let quotesOrDots: TreeType = .n(.maxHRatio(>, kGridCommaMaxRatio),
                                quotesOrColumnTree,
                                dotsOrDash)

let gridTailOrUpper: TreeType = .n(.isLowWithTailCustom, .r(.lowWithTail), .r(.upper))

let gridUndefineType = TreeType.n(.maxHRatio(>, kGridOnlyUpperMaxRatio),
                                  TreeType.r(.upper),
                                  TreeType.n(.maxHRatio(>, kGridUpperSureMaxRatio),
                                             gridTailOrUpper,
                                             TreeType.n(.maxHRatio(>, kGridUpperMaxRatio),
                                                        notSureTree,
                                                        lowAndLowerTree)))
//еще не обновлял с нот сур
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
