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
        private let formattter = TrackingInfoFormatter()
        private let kErrorPercentRate: CGFloat = 2
        ///Splite blocks and update its tracking Information
        func splitAndUpdate(_ block: SimpleBlock, by infos: [TrackingInfo]) -> [SimpleBlock] {
            let arrayOfInfos = formattter.chunkTrackingInfo(infos, block: block)
            let createdBlocks = splitToNewBlocks(from: block, using: arrayOfInfos)
            return createdBlocks
        }

        private func splitToNewBlocks(from block: SimpleBlock, using arrayOfInfos: [[TrackingInfo]]) -> [SimpleBlock] {
            var newBlocks: [SimpleBlock] = []
            for infos in arrayOfInfos {
                if let first = infos.last, first.tracking == nil {
                    let lines = Array(block.lines[first.startIndex...first.endIndex])
                    let newBlock = Block.from(lines, column: block.column, typography: .empty)
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
            
            var allLines: [SimpleLine] = []
            
            for info in infos {
                let arrayOfWords = info.findArrayOfWords(in: block, type: .allowed).compactMap { $0 }
                let lines: [SimpleLine] = arrayOfWords.compactMap {
                    guard !$0.isEmpty else { return nil }
                    return Line(words: $0)
                    
                }
                
                allLines.append(contentsOf: lines)
            }
            
            guard let firstLine = allLines.first, let lastLine = allLines.last, let info = infos.first
                else { return nil }
            
            let range = rangeOf(one: firstLine.frame.topY, two: lastLine.frame.bottomY)
            
            var data = TrackingData(range: range, defaultTracking: info.tracking!)
            for (index, info) in infos.enumerated() where index > 0 {
                let yPosition = block.lines[info.startIndex].frame.topY
                data[yPosition] = info.tracking!
            }
            
            allLines.forEach {
                print($0.frame)
            }
            let newBlock = Block.from(allLines, column: block.column, typography: .tracking(data))
            return newBlock
        }
    }
}
