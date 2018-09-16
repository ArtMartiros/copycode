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
    
    let bitmap: NSBitmapImageRep
    init(in bitmap: NSBitmapImageRep) {
        self.bitmap = bitmap
    }
    
    func convert(_ block: SimpleBlock) -> SimpleBlock {
        let lines: [SimpleLine] = block.lines.map { convert($0) }
        let newBlock = Block(lines: lines, frame: block.frame, column: block.column, typography: block.typography)
        return newBlock
    }
    
    func convert(_ line: SimpleLine) -> SimpleLine {
        return  Line(words: convert(line.words))
    }
    
    ///Конвертирует в слово с типом
    func convert(_ rectangles: [SimpleWord]) -> [SimpleWord] {
        return rectangles.map { getWord(from: $0) }
    }
    
    private func getWord(from word: SimpleWord) -> SimpleWord {
        guard word.type != .same(type: .allCustom) else { return word }
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
        var newLetters: [LetterRectangle] = []
        for (index, item) in letters.enumerated() {
            newLetters.append(LetterRectangle(rect: item, type: types[index]))
        }
        return newLetters
    }
    

    
}
