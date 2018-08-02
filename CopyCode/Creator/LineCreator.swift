//
//  LineCreator.swift
//  CopyCode
//
//  Created by Артем on 02/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

protocol LineChecker_ {
    func same(_ first: Rectangle, with second: Rectangle) -> Bool
}

struct LineChecker: LineChecker_ {
    func same(_ first: Rectangle, with second: Rectangle) -> Bool {
        return first.intersectByY(with: second)
    }
}

final class LineCreator {
    let checker: LineChecker
    init(checker: LineChecker = LineChecker() ) {
        self.checker = checker
    }
    
    func create(from rectangles: [WordRectangle] ) ->  [Line] {
        let rectanglesSortebByY = rectangles.sorted { $0.frame.bottomY < $1.frame.bottomY }
        let lines = rectanglesSortebByY.chunkForSorted { checker.same($0, with: $1) }
        let sortedLines = lines.map { Line(rectangles: $0.sorted { $0.frame.minX < $1.frame.minX  }) }
        return sortedLines
    }
}
