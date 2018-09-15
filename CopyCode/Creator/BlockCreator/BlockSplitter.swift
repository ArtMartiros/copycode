//
//  BlockSplitter.swift
//  CopyCode
//
//  Created by Артем on 15/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

extension BlockCreator {
    ///Отвечает за то чтобы разделять Блоки на более мелкие смысловые части основываясь на TrackingInfo
    struct BlockSplitter {
        
        private let kErrorPercentRate: CGFloat = 2
        ///Splite blocks and update its tracking Information
        func splitAndUpdate(_ block: SimpleBlock, by infos: [TrackingInfo]) -> [SimpleBlock] {
            let arrayOfInfos = chunkTrackingInfo(infos)
            let createdBlocks = splitToNewBlocks(from: block, using: arrayOfInfos)
            return createdBlocks
        }
        
        private func chunkTrackingInfo(_ infos: [TrackingInfo]) -> [[TrackingInfo]] {
            let arrayOfInfos = infos.chunkForSorted {
                if let previous = $0.tracking, let current = $1.tracking,
                    EqualityChecker.check(of: previous.width, with: current.width, errorPercentRate: kErrorPercentRate) {
                    return true
                }
                return false
            }
            return arrayOfInfos
        }
        
        private func splitToNewBlocks(from block: SimpleBlock, using arrayOfInfos: [[TrackingInfo]]) -> [SimpleBlock] {
            var newBlocks: [SimpleBlock] = []
            for infos in arrayOfInfos {
                if let first = infos.last, first.tracking == nil {
                    let lines = Array(block.lines[first.startIndex...first.endIndex])
                    let newBlock = Block.from(lines, column: block.column, trackingData: nil, leading: nil)
                    newBlocks.append(newBlock)
                } else {
                    if let blockWithTrackingData = createNewBlock(from: block, using: infos) {
                        newBlocks.append(blockWithTrackingData)
                    }
                }
            }
            return newBlocks
        }
        
        private func createNewBlock(from block: SimpleBlock, using infos: [TrackingInfo]) -> SimpleBlock? {
            let infos = infos.filter { $0.tracking != nil }
            guard let first = infos.first, let last = infos.last else { return nil }
            
            let lines = Array(block.lines[first.startIndex...last.endIndex])
            var newBlock = Block.from(lines, column: block.column, trackingData: nil, leading: nil)
            let range = rangeOf(one: newBlock.frame.bottomY, two: newBlock.frame.topY)
            
            var data = TrackingData(range: range, defaultTracking: first.tracking!)
            for (index, info) in infos.enumerated() where index > 0 {
                let yPosition = block.lines[info.startIndex].frame.topY
                data[yPosition] = info.tracking!
            }
            newBlock.trackingData = data
            return newBlock
        }
    }
}
