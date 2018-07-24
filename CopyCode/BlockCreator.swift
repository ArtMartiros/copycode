//
//  BlockCreator.swift
//  CopyCode
//
//  Created by Артем on 22/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

final class BlockCreator {
    
}

struct Line: RectangleProtocol {
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
                gaps.append(word.frame.maxX...4000)
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
        let checker = Checker(height: 12)
        var value: CGFloat = 0
        var lines: [[WordRectangleProtocol]] = []
        var words: [WordRectangleProtocol] = []
        for each in rectangles {
            if checker.isSame(first: value, with: each.frame.bottomY) {
                words.append(each)
            } else {
                value = each.frame.bottomY
                lines.append(words)
                words = []
            }
        }
        lines.append(words)
        let sortedLines = lines.map { Line(rectangles: $0.sorted { $0.frame.minX < $1.frame.minX  }) }
        return sortedLines
    }
    
    
}
