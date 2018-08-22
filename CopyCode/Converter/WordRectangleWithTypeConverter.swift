//
//  ProtoWordConverter.swift
//  CopyCode
//
//  Created by Артем on 20/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

class WordRectangleWithTypeConverter {
    typealias WordAlias = Word<LetterRectangle>
    private var mixedWordRectangle: Word<LetterRectangle>!
    private let wordClassification = WordTypeClassification()
    
    func convertNew(_ rectangles: [WordAlias], in bitmap: NSBitmapImageRep) -> [Word<LetterRectangleWithType>] {
        return rectangles.map {
            return getNewWord(from: $0, in: bitmap)
        }
    }
    
    private func getNewWord(from word: WordAlias, in bitmap: NSBitmapImageRep ) -> Word<LetterRectangleWithType> {
        let information = WordInformation(max: word.letterWithMaxHeight!,
                                          lowerY: word.letterLowerY!,
                                          word: word)
        let recognizer = LetterRecognizer(bitmap, rectangle: word)
        let classification = NewLetterTypeClassification(information: information, recognizer: recognizer)
        let letters = getNewLetters(from: word.letters, using: classification)
        return Word(rect: word, type: .mix, letters: letters)
    }
    
    private func getNewLetters(from letters: [LetterRectangle],
                               using classification: NewLetterTypeClassification) -> [LetterRectangleWithType] {
        let types = classification.detectType(for: letters)
        var letters: [LetterRectangleWithType] = []
        for (index, item) in letters.enumerated() {
            letters.append(LetterRectangleWithType(rectangle: item, type: types[index]))
        }
        return letters
    }
    

    
}
