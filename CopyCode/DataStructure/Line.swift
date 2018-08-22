//
//  Line.swift
//  CopyCode
//
//  Created by Артем on 02/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct Line<WordChild: Rectangle>: StandartRectangle, Layerable {
    typealias WordAlias = Word<WordChild>
    let wordsRectangles: [WordAlias]
    var frame: CGRect {
        return wordsRectangles.map { $0.frame }.compoundFrame
    }

    init(rectangles: [WordAlias]) {
        self.wordsRectangles = rectangles
    }
}
