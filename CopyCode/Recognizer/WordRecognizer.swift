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
    
    func recognize(_ rectangle: WordRectangle_, with type: WordType.SameType) -> Word {
        let colorFinder = UniversalWhiteColorFinder(picker: ColorPicker(bitmap))
        let bgColor = colorFinder.findedBackgroundColor(rectangle)
        let recognizer = LetterRecognizer(in: bitmap, backgroundWhiteColor: bgColor, letterColorFinder: colorFinder)
        let letters: [Letter] = rectangle.letters.map {
            let value = recognizer.recognize(from: $0.pixelFrame, with: LetterType(type))
            return Letter(rectangle: $0, value: value)
        }
        return Word(wordRectangle: rectangle, letters: letters)
    }


    
}
