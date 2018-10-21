//
//  TypeConverter.swift
//  CopyCode
//
//  Created by Артем on 20/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

enum ActionForLetterType {
    case all
    case onlyLow
    case withOutLow
}

///Класс конвертирует слова из неизвестного типа в конкретный тип
final class TypeConverter {

    private let typeAction: ActionForLetterType
    private let bitmap: NSBitmapImageRep
    private let grid: TypographicalGrid

    init(in bitmap: NSBitmapImageRep, grid: TypographicalGrid, type: ActionForLetterType) {
        self.bitmap = bitmap
        self.grid = grid
        self.typeAction = type
    }

    func convert(_ block: SimpleBlock) -> SimpleBlock {
        let lines: [SimpleLine] = block.lines.map { convert($0) }
        let newBlock = Block(lines: lines, frame: block.frame, column: block.column, typography: block.typography)
        return newBlock
    }

    func convert(_ line: SimpleLine) -> SimpleLine {
        var words: [SimpleWord] = []
        for (index, word) in line.words.enumerated() {
            print("***************************************TypeConverter wordIndex \(index)***************************************")
            words.append(convert(word))
        }
        return Line(words: words)
    }

    private func convert(_ word: SimpleWord) -> SimpleWord {
        guard word.type != .same(type: .allCustom) else { return word }
        let information = getInformation(from: word)
        let recognizer = LetterRecognizer(bitmap, word: word)
        let classification = LetterTypeIdentifier(information, recognizer: recognizer)
        let convertedLetters = convert(word.letters, using: classification)
        return Word(rect: word, type: .mix, letters: convertedLetters)
    }

    private func convert(_ letters: [LetterRectangle], using classification: LetterTypeIdentifier) -> [LetterRectangle] {
        let types = classification.detectType(for: letters, grid: grid, actionType: typeAction)
        var newLetters: [LetterRectangle] = []
        for (index, item) in letters.enumerated() {
            newLetters.append(LetterRectangle(rect: item, type: types[index]))
        }
        return newLetters
    }

    private func getInformation(from word: SimpleWord) -> WordInformation {

        let information = WordInformation(leading: grid.leading, letterFrame: word.letters[0].frame)
        return information
    }

}
