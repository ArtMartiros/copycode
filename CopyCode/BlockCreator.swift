//
//  BlockCreator.swift
//  CopyCode
//
//  Created by Артем on 22/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

struct Column {
    
    var maxX: CGFloat {
        return 0
    }
    
    var minX: CGFloat {
        return 0
    }
    
    var topY: CGFloat {
        return 0
    }
    var botY: CGFloat {
        return 0
    }
    var pixelFrame: CGRect {
        return .zero
    }
    let columnWords: [WordRectangleProtocol]
    init(words: [WordRectangleProtocol]) {
        self.columnWords = words
    }
    
}

struct Block {
    var blockWords: [WordRectangleProtocol]
    init(words: [WordRectangleProtocol]) {
        self.blockWords = words
    }
}


final class BlockCreator {
    private let rectangles: [WordRectangleProtocol]
    private let bitmap: NSBitmapImageRep
    init(rectangles: [WordRectangleProtocol], in bitmap: NSBitmapImageRep) {
        self.rectangles = rectangles
        self.bitmap = bitmap
    }
    
    func test() {
        let sortedRectangles = rectangles.sorted { $0.frame.minX < $1.frame.minX }
        
        var dictionary: [CGFloat: [WordRectangleProtocol]] = [:]
        
        sortedRectangles.forEach {
            dictionary.append(element: $0, toKey: $0.pixelFrame.minX)
            
        }

        let recognizer = WordRecognizer(in: bitmap)
        let columnDetection = DigitColumnDetection(recognizer: recognizer)
        let digitColumnsStart = dictionary.values
            .sorted { $0.count > $1.count }
            .filter { $0.count > 5 }
        
        let digitColumns = digitColumnsStart.filter { columnDetection.detecte($0) }
        
        
        let columns = mergeSameColumn(digitColumns).map { Column(words: $0) }
        let blocks = getBlocks(from: sortedRectangles, by: columns )
    }
    
    private func getBlocks(from words: [WordRectangleProtocol], by columns: [Column] ) -> [[WordRectangleProtocol]] {
        var blockDictionary: [Int:[WordRectangleProtocol]] = [:]
        var startIndex = 0
        for (columnIndex, column) in columns.enumerated() {
            guard startIndex < words.count else { break }
            for index in startIndex...words.count {
                let word = words[index]
                if isInside(word, in: column) {
                    let nextIndex = columnIndex + 1
                    if columns.count > nextIndex,  word.frame.minX > columns[nextIndex].maxX {
                        startIndex = index
                        continue
                    }
                    blockDictionary.append(element: word, toKey: columnIndex)
                    
                }
                startIndex = index + 1
            }
        }
        return Array(blockDictionary.values)
        
    }
    
    func isInside(_  word: WordRectangleProtocol, in column: Column) -> Bool {
        return word.frame.minX > column.maxX && word.frame.minY < column.topY
    }

   
    
    func mergeSameColumn( _ things: [[WordRectangleProtocol]]) -> [[WordRectangleProtocol]] {
        return []
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
        let checker = Checker(height: 20)
        var value: CGFloat = 0
        var lines: [[WordRectangleProtocol]] = []
        var words: [WordRectangleProtocol] = []
        for each in rectangles {
            if checker.isSame(first: value, with: each.frame.bottomY) {
                words.append(each)
            } else {
                value = each.frame.bottomY
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
