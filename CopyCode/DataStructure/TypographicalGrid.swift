//
//  TypographicalGrid.swift
//  CopyCode
//
//  Created by Артем on 16/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct TypographicalGrid: Codable {
    let trackingData: TrackingData
    private (set) var leading: Leading
    
    init(data: TrackingData, leading: Leading) {
        self.trackingData = data
        self.leading = leading
    }
    
    mutating func update(_ leading: Leading) {
        self.leading = leading
    }
    
}

extension TypographicalGrid {
    ///breaks the frame into parts using leading and tracking
    func getArrayOfFrames(from frame: CGRect) -> [[CGRect]] {
        let lineFrames = leading.missingLinesWithStandartFrame(in: frame)
        let arrayOfFrames: [[CGRect]] = lineFrames.map {
            let tracking = trackingData[$0.topY]
            return tracking.missingCharFrames(in: $0)
        }
        return arrayOfFrames
    }
    
    func getTestBlock(from block: SimpleBlock) -> SimpleBlock {
        let lines: [SimpleLine] = getArrayOfFrames(from: block.frame).map {
            let letters: [LetterRectangle] =  $0.map {
                LetterRectangle(frame: $0, pixelFrame: $0, type: .custom)
            }
            let word = Word.from(letters, type: .same(type: .allCustom))
            let line = Line(words: [word])
            return line
        }
        let block = Block(lines: lines, frame: block.frame, column: block.column, typography: block.typography)
        return block
    }
    }


