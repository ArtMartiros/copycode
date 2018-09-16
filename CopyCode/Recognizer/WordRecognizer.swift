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
    
    func recognize(_ block: SimpleBlock) -> CompletedBlock {
        let lines: [CompletedLine] = block.lines.map { recognize($0) }
        let newBlock = Block(lines: lines, frame: block.frame, column: block.column, typography: block.typography )
        return newBlock
    }
    
    func recognize(_ line: SimpleLine) -> CompletedLine {
        let words: [CompletedWord] = line.words.map { recognize($0) }
        let line = Line(words: words)
        return line
    }
    
    func recognize(_ word: SimpleWord) -> CompletedWord {
        let recognizer = LetterRecognizer(bitmap, rectangle: word)
        let letters: [Letter] = word.letters.map {
            let value = recognizer.recognize(from: $0)
            return Letter(rectangle: $0, value: value)
        }
        let word = Word(rect: word, type: word.type, letters: letters)
        return word
    }
    
    func recognize(_ rectangle: SimpleWord, with type: WordType.SameType) -> Word<Letter> {
        let letterRecognizer = LetterRecognizer(bitmap, rectangle: rectangle)
        let letters: [Letter] = rectangle.letters.map {
            let value = letterRecognizer.recognize(from: $0.pixelFrame, with: LetterType(type))
            return Letter(rectangle: $0, value: value)
        }
        return Word(rect: rectangle, type: .same(type: type), letters: letters)
    }

    
}
