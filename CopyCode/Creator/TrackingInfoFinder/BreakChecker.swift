//
//  BreakChecker.swift
//  CopyCode
//
//  Created by Артем on 04/12/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

final class BreakChecker {
    ///сколько высот слова должно быть в ширине между словами, чтоб разделить линию
    private let kBreakLineRate: CGFloat = 6
    func check(if word: SimpleWord, shouldBreakWith second: SimpleWord) -> Bool {
        let differentOne = abs(word.frame.leftX - second.frame.rightX)
        let differentTwo = abs(word.frame.rightX - second.frame.leftX)
        let different = min(differentOne, differentTwo)
        let shouldBreak = different / word.frame.height > kBreakLineRate
        return shouldBreak
    }
}
