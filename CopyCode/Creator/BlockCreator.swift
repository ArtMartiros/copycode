//
//  BlockCreator.swift
//  CopyCode
//
//  Created by Артем on 22/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

protocol BlockCreatorProtocol {
    associatedtype Child: Rectangle
    func create(from rectangles: [Word<Child>]) -> ([Block<Child>], [Column_])
}

final class BlockCreator: BlockCreatorProtocol {

    private let digitalColumnCreator: DigitColumnCreator
    init(digitalColumnCreator: DigitColumnCreator) {
        self.digitalColumnCreator = digitalColumnCreator
    }
    
    func create(from rectangles: [Word<LetterRectangle>]) -> ([Block<LetterRectangle>], [Column_]) {
        let (blockWords, columns) = getBlockWordsWithColumns(from: rectangles)
        let creator = LineCreator<LetterRectangle>()
        let lines = blockWords.map { creator.create(from: $0) }
        return (lines.map { Block.from($0) }, columns)
    }
    
    /// использует либо столбец с цифрами или если нет то кастомный
    
    private func getBlockWordsWithColumns(from words: [Word<LetterRectangle>]) -> ([[Word<LetterRectangle>]], [Column_]) {
        let (columns, blockRectangles) = digitalColumnCreator.create(from: words)
        let blockWords: [[Word<LetterRectangle>]]
        if !columns.isEmpty {
            blockWords = getBlocks(from: blockRectangles, by: columns )
            return (blockWords, columns)
        } else {
            let creator = CustomColumnCreator<LetterRectangle>()
            let customColums = creator.create(from: words)
            blockWords = getBlocks(from: words, by: customColums )
            return (blockWords, customColums)
        }
    }
    
    // на данный момент ищет если удовлетворяет критерию правее и ниже, но нужен другой, просто правее
    private func getBlocks(from words: [Word<LetterRectangle>], by columns: [Column_] ) -> [[Word<LetterRectangle>]] {
        let columns = columns.sorted { $0.frame.leftX > $1.frame.leftX }
        var blockDictionary: [Int:[Word<LetterRectangle>]] = [:]
        var startIndex = 0
        for word in words {
            for (index, column) in columns.enumerated() {
                if isInside(word, in: column) {
                    blockDictionary.append(element: word, toKey: index)
                    break
                }
            }
        }
        return Array(blockDictionary.values)
    }
    
   private func isInside(_  word: Word<LetterRectangle>, in column: Column_) -> Bool {
        return word.frame.leftX > column.frame.rightX
            //&& word.frame.bottomY < column.frame.topY
    }
}




