//
//  BlockPreparator.swift
//  CopyCode
//
//  Created by Артем on 22/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

extension BlockCreator {

    final class BlockPreparator {
        // swiftlint:disable nesting
        typealias ColumnsWithWords = (column: ColumnType, words: [SimpleWord])
        private let kNumberOfCustomColums = 3
        private let digitalColumnSplitter: DigitColumnSplitter
        private let customColumnCreator: CustomColumnCreator<LetterRectangle>
        private let lineCreator = LineCreator<LetterRectangle>()

        init(digitalColumnSplitter: DigitColumnSplitter, customColumnCreator: CustomColumnCreator<LetterRectangle>) {
            self.digitalColumnSplitter = digitalColumnSplitter
            self.customColumnCreator = customColumnCreator

        }

        init(in bitmap: NSBitmapImageRep) {
            self.digitalColumnSplitter = DigitColumnSplitter(in: bitmap)
            self.customColumnCreator = CustomColumnCreator<LetterRectangle>(imageWidth: bitmap.pixelSize.width)
        }

        func initialPrepare(from words: [Word<LetterRectangle>]) -> [Block<LetterRectangle>] {
            let columnsWithWords = getBlockWordsWithColumns(from: words)
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
            let blockWords = getBlockWordsUnsorted(from: blockRectangles, by: newColumns.sortedFromLeftToRight()  )
                .sorted { $0[0].frame.leftX <  $1[0].frame.leftX }

            var columnsWithWords: [ColumnsWithWords] = []
            for (index, words) in blockWords.enumerated() {
                columnsWithWords.append((newColumns[index], words))
            }
            return columnsWithWords
        }

        // на данный момент ищет если удовлетворяет критерию правее и ниже, но нужен другой, просто правее
        private func getBlockWordsUnsorted(from words: [SimpleWord], by columns: [ColumnProtocol] ) -> [[SimpleWord]] {
            let columns = columns.sorted { $0.frame.leftX > $1.frame.leftX }
            var blockDictionary: [Int: [Word<LetterRectangle>]] = [:]
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
