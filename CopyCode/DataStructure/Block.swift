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
    let column: ColumnType
    var tracking: Tracking?
    
    var gaps: [Gap] {
        var gaps: [Gap] = []
        lines.forEachPair {
            let gapFrame = CGRect(left: frame.leftX, right: frame.rightX,
                                  top: $0.frame.bottomY, bottom: $1.frame.topY)
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
    
    init(lines: [Line<WordChild>], frame: CGRect, column: ColumnType, tracking: Tracking? = nil) {
        self.lines = lines
        self.frame = frame
        self.column = column
        self.tracking = tracking
    }
    
    static func from(_ lines: [Line<WordChild>], column: ColumnType, tracking: Tracking? = nil) -> Block {
        let frame = lines.map { $0.frame }.compoundFrame
        return Block(lines: lines, frame: frame, column: column)
    }
    
    typealias BlockWithConstraint = (block: Block<WordChild>, constraint: CGRect?)
    
    ///Если два блока пересекаются то он возвращает то что пересекается
//    static func blocksWithConstraints(from blocks: [Block<WordChild>]) -> ([BlockWithConstraint]) {
//        let blocks = blocks.sortedFromLeftToRight
//        var newBlocks: [BlockWithConstraint] = []
//        blocks.forEachPair {
//            if let constraint = $0.frame.optionalIntersection($1.column.frame) {
//                let updatedConstraint = CGRect(left: constraint.leftX, right: constraint.rightX,
//                                               top: $0.frame.topY, bottom: constraint.bottomY)
//                newBlocks.append(($0, updatedConstraint))
//            }
//        }
//        newBlocks.append((blocks.last!, nil))
//        return newBlocks
//    }
}

