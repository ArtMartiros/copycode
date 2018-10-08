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
        let lines: [SimpleLine] = block.lines.map { convert($0, typography: block.typography) }
        let newBlock = Block(lines: lines, frame: block.frame, column: block.column, typography: block.typography)
        return newBlock
    }
    
    func convert(_ line: SimpleLine, typography: Typography) -> SimpleLine {
        return  Line(words: convert(line.words, typography: typography))
    }
    
    ///Конвертирует в слово с типом
    func convert(_ rectangles: [SimpleWord], typography: Typography) -> [SimpleWord] {
        var words: [SimpleWord] = []
        for (index, word) in rectangles.enumerated() {
            print("***************************************TypeConverter wordIndex \(index)***************************************")
            words.append(getWord(from: word, typography: typography))
        }
        return words
    }
    
    private func getWord(from word: SimpleWord, typography: Typography) -> SimpleWord {
        guard word.type != .same(type: .allCustom) else { return word }
        let information = WordInformation(max: word.letterWithMaxHeight!,
                                          lowerY: word.letterLowerY!,
                                          word: word)
        let recognizer = LetterRecognizer(bitmap, word: word)
        let classification = LetterTypeIdentifier(information: information, recognizer: recognizer)
        let letters = getLetters(from: word.letters, using: classification, typography: typography)
        return Word(rect: word, type: .mix, letters: letters)
    }
    
    private func getLetters(from letters: [LetterRectangle],
                               using classification: LetterTypeIdentifier,
                               typography: Typography ) -> [LetterRectangle] {
        let types = classification.detectType(for: letters, typography: typography)
        var newLetters: [LetterRectangle] = []
        for (index, item) in letters.enumerated() {
            newLetters.append(LetterRectangle(rect: item, type: types[index]))
        }
        return newLetters
    }
    

    
}
