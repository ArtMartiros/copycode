//
//  Block.swift
//  CopyCode
//
//  Created by Артем on 02/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct Block<WordChild: Rectangle>: BlockProtocol, Gapable {
    
    let frame: CGRect
    let lines: [Line<WordChild>]
    let column: ColumnProtocol
    
    var gaps: [StandartRectangle] {
        var gaps: [StandartRectangle] = []
        for (index, line) in lines.enumerated() where index != 0 {
            let previousLine = lines[index - 1]
            let gapFrame = CGRect(left: frame.leftX, right: frame.rightX,
                             top: previousLine.frame.bottomY, bottom: line.frame.topY)
            gaps.append(Gap(frame: gapFrame))
        }
        
        return gaps
    }
    
    var averageLineHeight: CGFloat {
        let sum = lines.map { $0.frame.height }.reduce(0, +)
        return (sum / CGFloat(lines.count)).rounded()
    }
    
    /// исключая аномальные результаты дает самую высокую линию
    func maxLineHeight() -> CGFloat {
        let heights = lines.map { $0.frame.height }.sorted { $0 > $1 }.chunkForSorted { $0 == $1 }
        let sameHeightArray = heights.first { $0.count > 3 } ?? heights.first { $0.count > 2 }
        return sameHeightArray?[0] ?? averageLineHeight
    }
    
    init(lines: [Line<WordChild>], frame: CGRect, column: ColumnProtocol) {
        self.lines = lines
        self.frame = frame
        self.column = column
    }
    
    static func from(_ lines: [Line<WordChild>], column: ColumnProtocol) -> Block {
        let frame = lines.map { $0.frame }.compoundFrame
        return Block(lines: lines, frame: frame, column: column)
    }
    
    typealias BlockWithConstraint = (block: Block<WordChild>, constraint: CGRect?)
    
    static func blocksWithConstraints(from blocks: [Block<WordChild>]) -> ([BlockWithConstraint]) {
        let blocks = blocks.sortedFromLeftToRight
        var newBlocks: [BlockWithConstraint] = []
        for (index, block) in blocks.enumerated() {
            let nextIndex = index + 1
            if nextIndex < blocks.count,
                let constraint = block.frame.optionalIntersection(blocks[nextIndex].column.frame) {
                let updatedConstraint = CGRect(left: constraint.leftX, right: constraint.rightX,
                                               top: block.frame.topY, bottom: constraint.bottomY)
                newBlocks.append((block, updatedConstraint))
            } else {
                newBlocks.append((block, nil))
            }
        }
        return newBlocks
    }
}


