//
//  TypeConverter.swift
//  CopyCode
//
//  Created by Артем on 20/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

///Класс конвертирует слова из неизвестного типа в конкретный тип
class TypeConverter {
    private var mixedWordRectangle: SimpleWord!
    private let wordClassification = WordTypeIdentifier()
    
    ///Конвертирует в слово с типом
    func convert(_ rectangles: [SimpleWord], in bitmap: NSBitmapImageRep) -> [SimpleWord] {
        return rectangles.map {
            return getWord(from: $0, in: bitmap)
        }
    }
    
    private func getWord(from word: SimpleWord, in bitmap: NSBitmapImageRep ) -> SimpleWord {
        let information = WordInformation(max: word.letterWithMaxHeight!,
                                          lowerY: word.letterLowerY!,
                                          word: word)
        let recognizer = LetterRecognizer(bitmap, rectangle: word)
        let classification = LetterTypeIdentifier(information: information, recognizer: recognizer)
        let letters = getLetters(from: word.letters, using: classification)
        return Word(rect: word, type: .mix, letters: letters)
    }
    
    private func getLetters(from letters: [LetterRectangle],
                               using classification: LetterTypeIdentifier) -> [LetterRectangle] {
        let types = classification.detectType(for: letters)
        var letters: [LetterRectangle] = []
        for (index, item) in letters.enumerated() {
            letters.append(LetterRectangle(rect: item, type: types[index]))
        }
        return letters
    }
    

    
}
