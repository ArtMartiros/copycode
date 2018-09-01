//
//  WordRecognizer.swift
//  CopyCode
//
//  Created by Артем on 27/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

class WordRecognizer {
    private let bitmap: NSBitmapImageRep
    init(in bitmap: NSBitmapImageRep) {
        self.bitmap = bitmap
    }
    
    func recognize(_ rectangle: Word<LetterRectangle>, with type: WordType.SameType) -> Word<Letter> {
        let letterRecognizer = LetterRecognizer(bitmap, rectangle: rectangle)
        let letters: [Letter] = rectangle.letters.map {
            let value = letterRecognizer.recognize(from: $0.pixelFrame, with: LetterType(type))
            return Letter(rectangle: $0, value: value)
        }
        return Word(rect: rectangle, type: .same(type: type), letters: letters)
    }

    
}
