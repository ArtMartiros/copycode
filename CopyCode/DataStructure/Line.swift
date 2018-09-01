//
//  Line.swift
//  CopyCode
//
//  Created by Артем on 02/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct Line<WordChild: Rectangle>: StandartRectangle, Layerable, Gapable {
    typealias WordAlias = Word<WordChild>
    let words: [WordAlias]
    
    var gaps: [StandartRectangle] {
        var gaps: [StandartRectangle] = []
        for (index, word) in words.enumerated() where index != 0 {
            let previousWord = words[index - 1]
            let gapFrame = CGRect(left: previousWord.frame.rightX, right: word.frame.leftX,
                                  top: frame.topY, bottom: frame.bottomY)
            gaps.append(Gap(frame: gapFrame))
        }
        return gaps
    }
    
    var frame: CGRect {
        return words.map { $0.frame }.compoundFrame
    }

    init(words: [WordAlias]) {
        self.words = words
    }
}
