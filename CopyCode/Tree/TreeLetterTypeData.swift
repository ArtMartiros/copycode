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
private let kCommaMaxRatio: CGFloat = 0.37

private let tailOrUpper: TreeLetterType = .n(.isLowWIthTail, .r(.lowWithTail), .r(.upper))
private let quotesOrColumnTree: TreeLetterType = .n(.quotesOrColumn, .r(.quote), .r(.comma))
private let dotsOrDash: TreeLetterType = .n(.square,
                                            .r(.dot),
                                            .n(.bottomY, .r(.underscore), .r(.dashOrHyphen)))

let undefinedTypeTree: TreeLetterType = .n(.maxHRatio(>, kUpperMaxRatio),
                                                   tailOrUpper,
                                                   .n(.maxHRatio(>, kLowMaxRatio),
                                                      .r(.low),
                                                      .n(.maxHRatio(>, kCommaMaxRatio),
                                                         quotesOrColumnTree,
                                                         dotsOrDash)))
