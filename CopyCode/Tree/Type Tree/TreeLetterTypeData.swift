//
//  TreeLetterType.swift
//  CopyCode
//
//  Created by Артем on 03/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation
//Бинарное древо, отвечающее за определение типа буквы
typealias TreeLetterType = Tree<LetterTypeOperations, LetterType>

private let kUpperMaxRatio: CGFloat = 0.78
private let kLowMaxRatio: CGFloat = 0.5//0.622
private let kCommaMaxRatio: CGFloat = 0.37

private let tailOrUpper: TreeLetterType = .n(.isLowWIthTail, .r(.lowWithTail), .r(.upper))
private let quotesOrColumnTree: TreeLetterType = .n(.quotesOrColumn, .r(.quote), .r(.comma))
private let dotsOrDash: TreeLetterType = .n(.squareForDot,
                                            .r(.dot),
                                            .n(.bottomY, .r(.underscore), .r(.dashOrHyphen)))

let undefinedTypeTree: TreeLetterType = .n(.maxHRatio(>, kUpperMaxRatio),
                                                   tailOrUpper,
                                                   .n(.maxHRatio(>, kLowMaxRatio),
                                                      .r(.low),
                                                      .n(.maxHRatio(>, kCommaMaxRatio),
                                                         quotesOrColumnTree,
                                                         dotsOrDash)))


private let kGridUpperMaxRatio: CGFloat = 0.6
private let kGridLowMaxRatio: CGFloat = 0.45
private let kGridCommaMaxRatio: CGFloat = 0.37

let gridUndefineType: TreeLetterType = .n(.maxHRatio(>, kGridUpperMaxRatio),
                                          tailOrUpper,
                                          .n(.maxHRatio(>, kGridLowMaxRatio),
                                             .r(.low),
                                             .n(.maxHRatio(>, kGridCommaMaxRatio),
                                                quotesOrColumnTree,
                                                dotsOrDash)))
