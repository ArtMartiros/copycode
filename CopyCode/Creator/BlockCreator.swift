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
    func create(from rectangles: [Word<Child>]) -> [Block<Child>]
}

final class BlockCreator: BlockCreatorProtocol {
    typealias ColumnsWithWords = (column: ColumnProtocol, words: [Word<LetterRectangle>])
    
    private let lineCreator = LineCreator<LetterRectangle>()
    private let digitalColumnSplitter: DigitColumnSplitter
    private let customColumnCreator = CustomColumnCreator<LetterRectangle>()
    private let missingElementsRestorer: MissingElementsRestorer
    
    init(digitalColumnCreator: DigitColumnSplitter, elementsRestorer: MissingElementsRestorer) {
        self.digitalColumnSplitter = digitalColumnCreator
        self.missingElementsRestorer = elementsRestorer
    }
    
    func create(from rectangles: [Word<LetterRectangle>]) -> [Block<LetterRectangle>] {
        let columnsWithWords = getBlockWordsWithColumns(from: rectangles)
        let blocks: [Block<LetterRectangle>] = columnsWithWords.map {
            let line = lineCreator.create(from: $0.words)
            return Block.from(line, column: $0.column)
        }
        Timer.stop(text: "Block Created")
        let restoredBlocks = Block.blocksWithConstraints(from: blocks)
            .map { missingElementsRestorer.restore($0.block, constraint: $0.constraint) }
        Timer.stop(text: "Block Restored")
        return restoredBlocks
    }
    
    /// использует либо столбец с цифрами или если нет то кастомный
    private func getBlockWordsWithColumns(from words: [Word<LetterRectangle>]) -> ([ColumnsWithWords]) {
        let (columns, blockRectangles) = digitalColumnSplitter.spltted(from: words)
        var newColumns: [ColumnProtocol] = !columns.isEmpty ? columns : customColumnCreator.create(from: words)
        newColumns.sort { $0.frame.leftX < $1.frame.leftX }
        let blockWords = getBlocks(from: blockRectangles, by: newColumns )
            .sorted { $0[0].frame.leftX <  $1[0].frame.leftX }
        var columnsWithWords: [ColumnsWithWords] = []
        for (index, words) in blockWords.enumerated() {
            columnsWithWords.append((newColumns[index], words))
        }
        return columnsWithWords
    }
    
    // на данный момент ищет если удовлетворяет критерию правее и ниже, но нужен другой, просто правее
    private func getBlocks(from words: [Word<LetterRectangle>], by columns: [ColumnProtocol] ) -> [[Word<LetterRectangle>]] {
        let columns = columns.sorted { $0.frame.leftX > $1.frame.leftX }
        var blockDictionary: [Int:[Word<LetterRectangle>]] = [:]
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
    
   private func isInside(_  word: Word<LetterRectangle>, in column: ColumnProtocol) -> Bool {
        return word.frame.leftX > column.frame.rightX
    }
}




