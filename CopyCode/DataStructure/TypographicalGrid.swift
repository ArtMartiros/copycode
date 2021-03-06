//
//  TypographicalGrid.swift
//  CopyCode
//
//  Created by Артем on 16/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct TypographicalGrid: Codable, RatioUpdatable {
    let trackingData: TrackingData
    private (set) var leading: Leading

    init(data: TrackingData, leading: Leading) {
        self.trackingData = data
        self.leading = leading
    }

    mutating func update(_ leading: Leading) {
        self.leading = leading
    }

    func updated(by rate: Int) -> TypographicalGrid {
        let data = trackingData.updated(by: rate)
        let leading = self.leading.updated(by: rate)
        return TypographicalGrid(data: data, leading: leading)
    }

}

extension TypographicalGrid {

    func getUpdatedFrame(from blockFrame: CGRect) -> CGRect {
        let frames = getArrayOfFrames(from: blockFrame)
        guard let first = frames.first?.first,
            let last = frames.last?.last else { return blockFrame }
        return CGRect(left: first.leftX, right: last.rightX, top: first.topY, bottom: last.bottomY)
    }

    ///breaks the frame into parts using leading and tracking
    func getArrayOfFrames(from frame: CGRect) -> [[CGRect]] {
        let lineFrames = leading.missingLinesWithStandartFrame(in: frame)
        let arrayOfFrames: [[CGRect]] = lineFrames.map {
            let tracking = trackingData[$0.bottomY]
            return tracking.missingCharFrames(in: $0)
        }
        return arrayOfFrames
    }

    func getTestBlock(from block: SimpleBlock) -> SimpleBlock {
        let lines: [SimpleLine] = getArrayOfFrames(from: block.frame).map {
            let letters: [LetterRectangle] =  $0.map {
                LetterRectangle(frame: $0, type: .custom)
            }
            let word = Word.from(letters, type: .same(type: .allCustom))
            let line = Line(words: [word])
            return line
        }
        let block = Block(lines: lines, frame: block.frame, column: block.column, typography: block.typography)
        return block
    }
    }
