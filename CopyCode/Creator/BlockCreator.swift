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

    private let columnCreator: DigitColumnCreator<LetterRectangle>!
    init(columnCreator: DigitColumnCreator<LetterRectangle>) {
        self.columnCreator = columnCreator
    }
    
    func create(from rectangles: [Word<LetterRectangle>]) -> [Block<LetterRectangle>] {
        let (columns, blockRectangles) = columnCreator.create(from: rectangles)
        let blockWords = getBlocks(from: blockRectangles, by: columns )
        let creator = LineCreator<LetterRectangle>()
        let lines = blockWords.map { creator.create(from: $0) }
        return lines.map { Block.from($0) }
    }
    
    private func getBlocks(from words: [Word<LetterRectangle>], by columns: [Column<LetterRectangle>] ) -> [[Word<LetterRectangle>]] {
        let columns = columns.sorted { $0.frame.leftX < $1.frame.leftX }
        var blockDictionary: [Int:[Word<LetterRectangle>]] = [:]
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
    
   private func isInside(_  word: Word<LetterRectangle>, in column: Column<LetterRectangle>) -> Bool {
        return word.frame.leftX > column.frame.rightX && word.frame.bottomY < column.frame.topY
    }
}




