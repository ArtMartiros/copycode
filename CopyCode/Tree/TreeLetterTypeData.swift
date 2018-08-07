//
//  TreeLetterType.swift
//  CopyCode
//
//  Created by Артем on 03/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

typealias TreeLetterType = Tree<LetterTypeOperations, LetterType>

private let kUpperMaxRatio: CGFloat = 0.78
private let kLowMaxRatio: CGFloat = 0.5//0.622
private let kColonMaxRatio: CGFloat = 0.37

private let tailOrUpper: TreeLetterType = .n(.isLowWIthTail, .r(.lowWithTail), .r(.upper))
private let quotesOrColumnTree: TreeLetterType = .n(.quotesOrColumn, .r(.quote), .r(.colon))
private let dotsOrDash: TreeLetterType = .n(.square,
                                            .r(.dot),
                                            .n(.bottomY, .r(.underscore), .r(.dashOrHyphen)))
//private let dashOrUnderscore: TreeLetterType = .n(.bottomY,
//                                                  .r(.underscore),
//                                                  .n(.dashOrHyphen, .r(.dash), .r(.hyphen)))


let undefinedTypeTree: TreeLetterType = .n(.maxHRatio(>, kUpperMaxRatio),
                                                   tailOrUpper,
                                                   .n(.maxHRatio(>, kLowMaxRatio),
                                                      .r(.low),
                                                      .n(.maxHRatio(>, kColonMaxRatio),
                                                         quotesOrColumnTree,
                                                         dotsOrDash)))
