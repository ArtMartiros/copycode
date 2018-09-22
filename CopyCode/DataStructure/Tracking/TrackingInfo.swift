//
//  TrackingInfo.swift
//  CopyCode
//
//  Created by Артем on 27/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

typealias Forbidden = [Int: CGFloat]

struct TrackingInfo: Codable {
    let tracking: Tracking?
    var forbiddens: Forbidden
    let startIndex: Int
    let endIndex: Int
    init(tracking: Tracking? = nil, forbiddens: Forbidden = [:], startIndex: Int, endIndex: Int) {
        self.tracking = tracking
        self.startIndex = startIndex
        self.endIndex = endIndex
        self.forbiddens = forbiddens
    }
    
    func leftX(at block: SimpleBlock) -> CGFloat? {
        return xRange(at: block, type: .allowed)?.lowerBound
    }
    
    func rightX(at block: SimpleBlock) -> CGFloat? {
        return xRange(at: block, type: .allowed)?.upperBound
    }
    
    func xRange(at block: SimpleBlock, type: WordsFinderType) -> TrackingRange? {
        var maxX: CGFloat?
        var minX: CGFloat?
        for index in startIndex...endIndex {
            let words = findWords(in: block, lineIndex: index, type: type)
            if let last = words?.last {
                maxX = max(last.frame.rightX, maxX ?? last.frame.rightX)
            }
            
            if let first = words?.first {
                minX = min(first.frame.leftX, maxX ?? first.frame.leftX)
            }
        }
        guard let leftX = minX, let rightX = maxX else { return nil }
        return leftX...rightX
    }
    
    func findLineIndexes(from block: SimpleBlock, in range: TrackingRange) -> [Int] {
        var lineIndexes: [Int] = []
        for (lineIndex, line) in block.lines.enumerated() where lineIndex >= startIndex && lineIndex <= endIndex {
            let lineRange = line.frame.leftX...line.frame.rightX
            let intersected = lineRange.intesected(with: range) != nil
            if intersected {
                lineIndexes.append(lineIndex)
            }
        }
        return lineIndexes
    }
    
    ///Возвращает слова в линии которые соответствуют критериям TrackingInfo либо nil
    func findWords(in block: SimpleBlock, lineIndex: Int, type: WordsFinderType) -> [SimpleWord]? {
        guard block.lines.count > lineIndex, startIndex <= lineIndex, endIndex >= lineIndex else { return nil }
        let words = block.lines[lineIndex].words
        let forbiddenX = forbiddens[lineIndex]
        switch type {
        case .allowed:
            return forbiddenX != nil ? words.filter { $0.frame.rightX < forbiddenX! } : words
        case .disallowed:
            return forbiddenX != nil ? words.filter { $0.frame.rightX >= forbiddenX! } : []
        case .all:
            return words
        }

    }
    
    func findArrayOfWords(in block: SimpleBlock, type: WordsFinderType) -> [[SimpleWord]?] {
        let indexes = Array(startIndex...endIndex)
        let arrayOfWords = indexes.map { findWords(in: block, lineIndex: $0, type: type) }
        return arrayOfWords
    }
    
    enum WordsFinderType {
        case allowed
        case disallowed
        case all
    }
}
