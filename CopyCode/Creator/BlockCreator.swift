//
//  BlockCreator.swift
//  CopyCode
//
//  Created by Артем on 22/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

protocol BlockCreatorProtocol {
    func create(from rectangles: [WordRectangle_]) -> [Block]
}

final class BlockCreator: BlockCreatorProtocol {
    private let columnCreator: DigitColumnCreator!
    init(columnCreator: DigitColumnCreator) {
        self.columnCreator = columnCreator
    }
    
    func create(from rectangles: [WordRectangle_]) -> [Block] {
        let (columns, blockRectangles) = columnCreator.create(from: rectangles)
        let blockWords = getBlocks(from: blockRectangles, by: columns )
        let creator = LineCreator()
        let lines = blockWords.map { creator.create(from: $0) }
        return lines.map { Block.from($0) }
    }
    
    private func getBlocks(from words: [WordRectangle_], by columns: [ColumnProtocol] ) -> [[WordRectangle_]] {
        let columns = columns.sorted { $0.frame.leftX < $1.frame.leftX }
        var blockDictionary: [Int:[WordRectangle_]] = [:]
        var startIndex = 0
        for (columnIndex, column) in columns.enumerated() {
            guard startIndex < words.count else { break }
            let nextIndex = columnIndex + 1
            for index in startIndex..<words.count {
                let word = words[index]
                if isInside(word, in: column) {
                    if columns.count > nextIndex {
                        let nextColumn = columns[nextIndex]
                        if word.frame.leftX > nextColumn.frame.rightX {
                            startIndex = index
                            break
                        } else if word.frame.rightX > nextColumn.frame.leftX  {
                            continue
                        }
                    }
                    blockDictionary.append(element: word, toKey: columnIndex)
                    
                }
                startIndex = index + 1
            }
        }
        return Array(blockDictionary.values)
    }
    
   private func isInside(_  word: WordRectangle_, in column: ColumnProtocol) -> Bool {
        return word.frame.leftX > column.frame.rightX && word.frame.bottomY < column.frame.topY
    }
}




