//
//  BlockCreator.swift
//  CopyCode
//
//  Created by Артем on 22/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

protocol BlockCreatorProtocol {
    associatedtype Child: Rectangle
    func create(from rectangles: [Word<Child>]) -> [Block<Child>]
}

final class BlockCreator: BlockCreatorProtocol {
    
    private let missingElementsRestorer: MissingElementsRestorer
    private let leadingFinder = LeadingFinder()
    private let blockSplitter = BlockSplitter()
    private let trackingInfoFinder = TrackingInfoFinder()
    private let blockPreparator: BlockPreparator
    
    init(digitalColumnCreator: DigitColumnSplitter, elementsRestorer: MissingElementsRestorer) {
        self.blockPreparator = BlockPreparator(digitalColumnSplitter: digitalColumnCreator)
        self.missingElementsRestorer = elementsRestorer
    }
    
    func create(from rectangles: [Word<LetterRectangle>]) -> [Block<LetterRectangle>] {
        let blocks = blockPreparator.initialPrepare(from: rectangles)
        Timer.stop(text: "BlockCreator Initial Created")
        var updatedBlocks = blocksUpdatedAfterTracking(blocks)
        Timer.stop(text: "BlockCreator Tracking Created")
        updatedBlocks = blocksUpdatedAfterLeading(updatedBlocks)
        Timer.stop(text: "BlockCreator Leading Created")
        let restoredBlocks = updatedBlocks.map { missingElementsRestorer.restore($0) }
        Timer.stop(text: "BlockCreator Restored")
        return restoredBlocks
    }
    
    private func blocksUpdatedAfterTracking(_ blocks: [Block<LetterRectangle>]) -> [Block<LetterRectangle>] {
        let newBlocks = blocks.map {
            let infos = trackingInfoFinder.find(from: $0)
            return blockSplitter.splitAndUpdate($0, by: infos)
            }.reduce([SimpleBlock](),+)
        return newBlocks
    }
    
    private func blocksUpdatedAfterLeading(_ blocks: [Block<LetterRectangle>]) -> [Block<LetterRectangle>] {
        var newBlocks: [Block<LetterRectangle>] = []
        for block in blocks {
            let leading = leadingFinder.find(block)
            let newBlock = Block.updateTypography(block, with: leading)
            newBlocks.append(newBlock)
        }
        return newBlocks
    }
    
}

extension BlockCreator {
    convenience init(in bitmap: NSBitmapImageRep) {
        let recognizer = WordRecognizer(in: bitmap)
        let columnDetection = DigitColumnDetection(recognizer: recognizer)
        let columnMerger = DigitColumnMerger()
        let columnCreator = DigitColumnSplitter(columnDetection: columnDetection, columnMerger: columnMerger)
        let restorer = MissingElementsRestorer(bitmap: bitmap)
        self.init(digitalColumnCreator: columnCreator, elementsRestorer: restorer)
    }
}

extension BlockCreator {
    
    class BlockPreparator {
        
        typealias ColumnsWithWords = (column: ColumnType, words: [Word<LetterRectangle>])
        private let kNumberOfCustomColums = 3
        private let digitalColumnSplitter: DigitColumnSplitter
        private let customColumnCreator = CustomColumnCreator<LetterRectangle>()
        private let lineCreator = LineCreator<LetterRectangle>()
        
        init(digitalColumnSplitter: DigitColumnSplitter) {
            self.digitalColumnSplitter = digitalColumnSplitter
        }
        
        func initialPrepare(from words: [Word<LetterRectangle>]) -> [Block<LetterRectangle>] {
            var columnsWithWords = getBlockWordsWithColumns(from: words)
            columnsWithWords = cutLastBlock(columnWithWords: columnsWithWords)

            let blocks: [Block<LetterRectangle>] = columnsWithWords.map {
                let line = lineCreator.create(from: $0.words)
                return Block.from(line, column: $0.column, typography: .empty)
            }
            
            return blocks
        }
        
        /// использует либо столбец с цифрами или если нет то кастомный
        private func getBlockWordsWithColumns(from words: [Word<LetterRectangle>]) -> ([ColumnsWithWords]) {
            let (columns, blockRectangles) = digitalColumnSplitter.spltted(from: words)
            
            let newColumns = getNewColumnsIfDigitNotExist(columns, words: words)
            let blockWords = getBlockWords(from: blockRectangles, by: newColumns.sortedFromLeftToRight  )
                .sorted { $0[0].frame.leftX <  $1[0].frame.leftX }
            
            var columnsWithWords: [ColumnsWithWords] = []
            for (index, words) in blockWords.enumerated() {
                columnsWithWords.append((newColumns[index], words))
            }
            return columnsWithWords
        }
        
        // на данный момент ищет если удовлетворяет критерию правее и ниже, но нужен другой, просто правее
        private func getBlockWords(from words: [Word<LetterRectangle>],
                                   by columns: [ColumnProtocol] ) -> [[Word<LetterRectangle>]] {
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
            return word.frame.leftX > column.frame.leftX
        }
        
        private func cutLastBlock(columnWithWords: [ColumnsWithWords]) ->  [ColumnsWithWords] {
            var newColumnWithWords = columnWithWords
            let lastColumnWithWords = newColumnWithWords.removeFirst()
            let column = customColumnCreator.create(from: lastColumnWithWords.words, numberOfColumns: 2)
            let blocks = getBlockWords(from: lastColumnWithWords.words, by: column)
            let updatedColumnWithWords = (lastColumnWithWords.column, blocks[0])
            newColumnWithWords.insert(updatedColumnWithWords, at: 0)
            return newColumnWithWords
        }
        
        private func getNewColumnsIfDigitNotExist(_ columns: [DigitColumn<LetterRectangle>],
                                                  words: [Word<LetterRectangle>]) -> [ColumnType] {
            if !columns.isEmpty {
                return columns.map { ColumnType.digit(column: $0) }
            } else {
                return customColumnCreator.create(from: words, numberOfColumns: kNumberOfCustomColums)
                    .map { ColumnType.standart(column: $0) }
            }
        }
    }
}
