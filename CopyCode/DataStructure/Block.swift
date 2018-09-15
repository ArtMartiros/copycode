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
    var trackingData: TrackingData?
    var leading: Leading?
    
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
        let heights = lines.map { $0.frame.height }.sorted { $0 > $1 }
        return heights[0]
    }
    
    init(lines: [Line<WordChild>], frame: CGRect, column: ColumnType,
         trackingData: TrackingData?, leading: Leading?) {
        self.lines = lines
        self.frame = frame
        self.column = column
        self.trackingData = trackingData
        self.leading = leading
    }
    
    static func from(_ lines: [Line<WordChild>], column: ColumnType,
                     trackingData: TrackingData?, leading: Leading?) -> Block {
        let frame = lines.map { $0.frame }.compoundFrame
        return Block(lines: lines, frame: frame, column: column, trackingData: trackingData, leading: leading)
    }
}

