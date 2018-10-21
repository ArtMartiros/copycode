//
//  WordSplitter.swift
//  CopyCode
//
//  Created by Артем on 22/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

final class WordSplitter<WordChild: Rectangle> {
    typealias WordAlias = Word<WordChild>
    typealias SplittedWord = (word: WordAlias, shitWord: WordAlias?)
    typealias SplittedWords = (words: [WordAlias], shitWords: [WordAlias])

    static func split(_ rectangle: WordAlias, after number: Int) -> SplittedWord {
        let letters = rectangle.letters
        guard letters.count >= number else { return (Word.from(letters), nil) }
        let first = Array(letters[0..<number])
        let second = Array(letters[number..<letters.count])
        return (Word.from(first), Word.from(second))
    }

    static func split(_ rectangles: [WordAlias], after number: Int) -> SplittedWords {
        let splitted = rectangles.map { split($0, after: number) }
        return (splitted.map { $0.word }, splitted.compactMap { $0.shitWord })
    }
}
