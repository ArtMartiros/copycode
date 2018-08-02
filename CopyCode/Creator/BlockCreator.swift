//
//  BlockCreator.swift
//  CopyCode
//
//  Created by Артем on 22/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

protocol BlockCreatorProtocol {
    func create(from rectangles: [WordRectangle_]) -> [BlockProtocol]
}

final class BlockCreator: BlockCreatorProtocol {
    private let columnCreator: DigitColumnCreator!
    init(columnCreator: DigitColumnCreator) {
        self.columnCreator = columnCreator
    }
    
    func create(from rectangles: [WordRectangle_]) -> [BlockProtocol] {
        let (columns, blockRectangles) = columnCreator.create(from: rectangles)
        return  getBlocks(from: blockRectangles, by: columns )
    }
    
    private func getBlocks(from words: [WordRectangle_], by columns: [ColumnProtocol] ) -> [Block] {
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
        return Array(blockDictionary.values).map { Block.from($0) }
    }
    
    func isInside(_  word: WordRectangle_, in column: ColumnProtocol) -> Bool {
        return word.frame.leftX > column.frame.rightX && word.frame.bottomY < column.frame.topY
    }
}



struct Line {
    let wordsRectangles: [WordRectangle_]
    let gaps: [ClosedRange<CGFloat>]
    
    var frame: CGRect {
        return wordsRectangles.map { $0.frame }.compoundFrame
    }

    var pixelFrame: CGRect {
        return wordsRectangles.map { $0.pixelFrame }.compoundFrame
    }
    
    init(rectangles: [WordRectangle_]) {
        self.wordsRectangles = rectangles
        self.gaps = Line.gaps(from: rectangles)
    }
    
    static func gaps(from rectangles: [WordRectangle_]) -> [ClosedRange<CGFloat>] {
        var gaps: [ClosedRange<CGFloat>] = []
        for (index, word) in rectangles.enumerated() {
            if index == 0 { gaps.append(0.0...word.frame.minX) }
            let nextIndex = index + 1
            if rectangles.count > nextIndex {
                let nextWord = rectangles[nextIndex]
                gaps.append(word.frame.maxX...nextWord.frame.minX)
            } else {
                gaps.append(word.frame.maxX...40000)
            }
        }
        return gaps
    }
}


