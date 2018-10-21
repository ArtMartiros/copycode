//
//  LetterWithPosition.swift
//  CopyCode
//
//  Created by Артем on 15/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct LetterWithPosition<T: Rectangle>: Codable {
    let l: Int
    let w: Int
    let c: Int
    let lineCharCount: Int
    let letter: T

    init(l: Int, w: Int, c: Int, lineCharCount: Int, letter: T) {
        self.l = l
        self.w = w
        self.c = c
        self.lineCharCount = lineCharCount
        self.letter = letter
    }

    init(position: SimpleLetterPosition, letter: T) {
        self.init(l: position.l, w: position.w, c: position.c,
                  lineCharCount: position.lineCharCount, letter: letter)
    }
}
