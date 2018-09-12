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
    typealias ColumnsWithWords = (column: ColumnType, words: [Word<LetterRectangle>])
    
    private let lineCreator = LineCreator<LetterRectangle>()
    private let digitalColumnSplitter: DigitColumnSplitter
    private let customColumnCreator = CustomColumnCreator<LetterRectangle>()
    private let missingElementsRestorer: MissingElementsRestorer
    private let trackingInfoFinder = TrackingInfoFinder()
    
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
        let blocksWithTracking = blocksUpdatedAfterTracking(blocks)
        Timer.stop(text: "Block Tracking")
        let restoredBlocks = blocksWithTracking
            .map { missingElementsRestorer.restore($0) }
        Timer.stop(text: "Block Restored")
        return restoredBlocks
    }
    
    private func blocksUpdatedAfterTracking(_ blocks: [Block<LetterRectangle>]) -> [Block<LetterRectangle>] {
        var newBlocks: [Block<LetterRectangle>] = []
        for block in blocks {
            let trackingInfos = trackingInfoFinder.find(from: block)
            for info in trackingInfos {
                let lines = Array(block.lines[info.startIndex...info.endIndex])
                var newBlock = Block.from(lines, column: block.column)
                newBlock.tracking = info.tracking
                newBlocks.append(newBlock)
            }
        }
        return newBlocks
    }
    
    /// использует либо столбец с цифрами или если нет то кастомный
    private func getBlockWordsWithColumns(from words: [Word<LetterRectangle>]) -> ([ColumnsWithWords]) {
        let (columns, blockRectangles) = digitalColumnSplitter.spltted(from: words)
        let newColumns = getNewColumnsIfDigitNotExist(columns, words: words)
        let blockWords = getBlocks(from: blockRectangles, by: newColumns.sortedFromLeftToRight  )
            .sorted { $0[0].frame.leftX <  $1[0].frame.leftX }
        var columnsWithWords: [ColumnsWithWords] = []
        for (index, words) in blockWords.enumerated() {
            columnsWithWords.append((newColumns[index], words))
        }
        return columnsWithWords
    }
    
    private func getNewColumnsIfDigitNotExist(_ columns: [DigitColumn<LetterRectangle>],
                                              words: [Word<LetterRectangle>]) -> [ColumnType] {
        if !columns.isEmpty {
            return columns.map { ColumnType.digit(column: $0) }
        } else {
            return customColumnCreator.create(from: words).map { ColumnType.standart(column: $0) }
        }
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




