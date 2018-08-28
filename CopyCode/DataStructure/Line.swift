//
//  Line.swift
//  CopyCode
//
//  Created by Артем on 02/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct Line<WordChild: Rectangle>: StandartRectangle, Layerable {
    typealias WordAlias = Word<WordChild>
    let words: [WordAlias]
    var frame: CGRect {
        return words.map { $0.frame }.compoundFrame
    }

    init(words: [WordAlias]) {
        self.words = words
    }
}
