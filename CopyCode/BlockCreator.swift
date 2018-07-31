//
//  BlockCreator.swift
//  CopyCode
//
//  Created by Артем on 22/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

protocol BlockCreatorProtocol {
    func create(from rectangles: [WordRectangleProtocol]) -> [BlockProtocol]
}

final class BlockCreator: BlockCreatorProtocol {
    private let columnCreator: DigitColumnCreator!
    init(columnCreator: DigitColumnCreator) {
        self.columnCreator = columnCreator
    }
    

    func create(from rectangles: [WordRectangleProtocol]) -> [BlockProtocol] {
        let (columns, blockRectangles) = columnCreator.create(from: rectangles)
        return  getBlocks(from: blockRectangles, by: columns )
    }
    
    private func getBlocks(from words: [WordRectangleProtocol], by columns: [ColumnProtocol] ) -> [Block] {
        let columns = columns.sorted { $0.leftX < $1.leftX }
        var blockDictionary: [Int:[WordRectangleProtocol]] = [:]
        //FIXME это лишние фразы
        var shitWords: [WordRectangleProtocol] = []
        var startIndex = 0
        for (columnIndex, column) in columns.enumerated() {
            guard startIndex < words.count else { break }
            let nextIndex = columnIndex + 1
            for index in startIndex..<words.count {
                let word = words[index]
                if isInside(word, in: column) {
                    if columns.count > nextIndex {
                        let nextColumn = columns[nextIndex]
                        if word.leftX > nextColumn.rightX {
                            startIndex = index
                            break
                        } else if word.rightX > nextColumn.leftX  {
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
    
    func isInside(_  word: WordRectangleProtocol, in column: ColumnProtocol) -> Bool {
        return word.leftX > column.rightX && word.bottomY < column.topY
    }
}



struct Line {
    let wordsRectangles: [WordRectangleProtocol]
    let gaps: [ClosedRange<CGFloat>]
    
    var frame: CGRect {
        return wordsRectangles.map { $0.frame }.compoundFrame
    }

    var pixelFrame: CGRect {
        return wordsRectangles.map { $0.pixelFrame }.compoundFrame
    }
    
    init(rectangles: [WordRectangleProtocol]) {
        self.wordsRectangles = rectangles
        self.gaps = Line.gaps(from: rectangles)
    }
    
    static func gaps(from rectangles: [WordRectangleProtocol]) -> [ClosedRange<CGFloat>] {
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


final class LineCreator {
    private let rectangles: [WordRectangleProtocol]
    init(rectangles: [WordRectangleProtocol]) {
        self.rectangles = rectangles
    }
    
    func create() ->  [Line] {
        //сортировка
        let rectanglesSortebByY = rectangles.sorted { $0.frame.bottomY < $1.frame.bottomY }
        return getLines(from: rectanglesSortebByY)
    }
    
   private func getLines(from rectangles: [WordRectangleProtocol] ) -> [Line] {
//        Merger.merge(rectangles, valueToCheck: { $0.bottomY } )
        let checker = Checker(height: 20)
        var value: CGFloat = 0
        var lines: [[WordRectangleProtocol]] = []
        var words: [WordRectangleProtocol] = []
        for each in rectangles {
            if checker.isSame(first: value, with: each.bottomY) {
                words.append(each)
            } else {
                value = each.bottomY
                lines.append(words)
                words = [each]
            }
        }
    

        lines.append(words)
        let sortedLines = lines.map { Line(rectangles: $0.sorted { $0.frame.minX < $1.frame.minX  }) }
    for (index, item) in sortedLines.enumerated() {
//        print("Line frame \(item.frame)")
//        item.wordsRectangles.forEach {
//            print("Line number: \(index), frame: \($0.frame)")
//        }
//        print("\n\n")
    }
        return sortedLines
    }
    
    
}
