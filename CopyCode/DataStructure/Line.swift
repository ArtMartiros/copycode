//
//  Line.swift
//  CopyCode
//
//  Created by Артем on 02/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct Line<WordChild: Rectangle>: Rectangle {
    typealias WordAlias = Word<WordChild>
    let wordsRectangles: [WordAlias]
//    let gaps: [ClosedRange<CGFloat>]
    
    var frame: CGRect {
        return wordsRectangles.map { $0.frame }.compoundFrame
    }
    
    var pixelFrame: CGRect {
        return wordsRectangles.map { $0.pixelFrame }.compoundFrame
    }
    
    init(rectangles: [WordAlias]) {
        self.wordsRectangles = rectangles
//        self.gaps = Line.gaps(from: rectangles)
    }
    
//    static func gaps(from rectangles: [WordAlias]) -> [ClosedRange<CGFloat>] {
//        var gaps: [ClosedRange<CGFloat>] = []
//        for (index, word) in rectangles.enumerated() {
//            if index == 0 { gaps.append(0.0...word.frame.minX) }
//            let nextIndex = index + 1
//            if rectangles.count > nextIndex {
//                let nextWord = rectangles[nextIndex]
//                gaps.append(word.frame.maxX...nextWord.frame.minX)
//            } else {
//                gaps.append(word.frame.maxX...40000)
//            }
//        }
//        return gaps
//    }
}
