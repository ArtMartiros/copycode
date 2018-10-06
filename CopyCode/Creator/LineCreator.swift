//
//  LineCreator.swift
//  CopyCode
//
//  Created by Артем on 02/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

protocol LineChecker_ {
    func same(_ first: StandartRectangle, with second: StandartRectangle) -> Bool
}

struct LineChecker: LineChecker_ {
    func same(_ first: StandartRectangle, with second: StandartRectangle) -> Bool {
        return first.intersectByY(with: second)
    }
}

final class LineCreator<WordChild: Rectangle> {
    let checker: LineChecker_
    init(checker: LineChecker_ = LineChecker() ) {
        self.checker = checker
    }
    
    func create(from rectangles: [Word<WordChild>]) ->  [Line<WordChild>] {
        let rectanglesSortebByY = rectangles.sortedFromTopToBottom()
        let lines = rectanglesSortebByY.chunkForSorted { checker.same($0, with: $1) }
        
        let sortedLines = lines.map { Line(words: $0.sortedFromLeftToRight()) }
        return sortedLines
    }
}
