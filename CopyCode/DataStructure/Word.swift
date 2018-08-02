//
//  Word.swift
//  CopyCode
//
//  Created by Артем on 02/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct WordRectangle: WordRectangle_ {
    let frame: CGRect
    let pixelFrame: CGRect
    let letters: [Rectangle]
    init(frame: CGRect, pixelFrame: CGRect, letters: [Rectangle]) {
        self.frame = frame
        self.pixelFrame = pixelFrame
        self.letters = letters
    }
    
    static func from(_ letters: [Rectangle]) -> WordRectangle {
        let frame = letters.map { $0.frame }.compoundFrame
        let pixelFrame = letters.map { $0.pixelFrame }.compoundFrame
        return WordRectangle(frame: frame, pixelFrame: pixelFrame, letters: letters)
    }
}


// MARK: Proto
struct WordRectangleWithType: Rectangle {
    let frame: CGRect
    let pixelFrame: CGRect
    let type: WordType
    let letters: [LetterRectangleWithType]
    
    init(rectangle: Rectangle, type: WordType, letters: [LetterRectangleWithType]) {
        self.frame = rectangle.frame
        self.pixelFrame = rectangle.pixelFrame
        self.type = type
        self.letters = letters
    }
}


struct Word: Rectangle, ValueProtocol {
    var frame: CGRect { return wordRectangle.frame }
    var pixelFrame: CGRect { return wordRectangle.pixelFrame }
    var value: String { return letters.map { $0.value }.joined() }
    let letters: [Letter]
    private let wordRectangle: WordRectangle_
    init(wordRectangle:  WordRectangle_, letters: [Letter]) {
        self.wordRectangle = wordRectangle
        self.letters = letters
    }
}
