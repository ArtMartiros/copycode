//
//  WordRecognizer.swift
//  CopyCode
//
//  Created by Артем on 27/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

class WordRecognizer {
    private let recognizer: LetterRecognizer
    init(in bitmap: NSBitmapImageRep) {
        self.recognizer = LetterRecognizer(in: bitmap)
    }
    
    func recognize(_ rectangle: WordRectangleProtocol, with type: WordType.SameType) -> Word {
        let type = LetterType(type)
        let letters: [Letter] = rectangle.letters.map {
            let value = recognizer.recognize(from: $0.pixelFrame, with: type)
            return Letter(rectangle: $0, value: value)
        }
        return Word(wordRectangle: rectangle, letters: letters)
    }
}
