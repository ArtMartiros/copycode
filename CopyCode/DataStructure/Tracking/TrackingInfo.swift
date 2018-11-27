//
//  TrackingInfo.swift
//  CopyCode
//
//  Created by Артем on 27/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

typealias LineRestrictionDictionary = [Int: LineRestriction]
struct TrackingInfo: Codable {
    let tracking: Tracking?
    var forbiddens: LineRestrictionDictionary
    let startIndex: Int
    let endIndex: Int

    init(tracking: Tracking? = nil, forbiddens: LineRestrictionDictionary = [:],
         startAt startIndex: Int, endAt endIndex: Int) {
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
            let words = findWords(in: block, lineIndex: index, type: type, restrictedAt: [.horizontal])
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

    func findWord(in range: TrackingRange, at lineIndex: Int, with block: SimpleBlock) -> [SimpleWord] {
        let line = block.lines[lineIndex]
        return line.words.filter {
            let wordRange = $0.frame.leftX...$0.frame.rightX
            return wordRange.intesected(with: range) != nil
        }
    }

    ///Возвращает слова в линии которые соответствуют критериям TrackingInfo либо nil
    func findWords(in block: SimpleBlock, lineIndex: Int, type: WordsFinderType, restrictedAt restricted: DirectionOptions) -> [SimpleWord]? {
        guard block.lines.count > lineIndex, startIndex <= lineIndex, endIndex >= lineIndex else { return nil }
        let words = block.lines[lineIndex].words

        var filteredWords: [SimpleWord] = []
        let restriction = forbiddens[lineIndex]
        if restricted.contains(.right) {
           filteredWords = filter(words: words, restriction: restriction, type: type, direction: .right)
        }
        if restricted.contains(.left) {
            filteredWords = filter(words: filteredWords, restriction: restriction, type: type, direction: .left)
        }

        return filteredWords
    }

   private func filter(words: [SimpleWord], restriction: LineRestriction?, type: WordsFinderType, direction: Direction) -> [SimpleWord] {
        switch direction {
        case .left:
            let forbiddenX = restriction?.leftX
            switch type {
            case .allowed: return forbiddenX != nil ? words.filter { $0.frame.leftX >= forbiddenX! } : words
            case .disallowed: return forbiddenX != nil ? words.filter { $0.frame.leftX < forbiddenX! } : []
            case .all: return words
            }
        case .right:
            let forbiddenX = restriction?.rightX
            switch type {
            case .allowed: return forbiddenX != nil ? words.filter { $0.frame.rightX < forbiddenX! } : words
            case .disallowed: return forbiddenX != nil ? words.filter { $0.frame.rightX >= forbiddenX! } : []
            case .all: return words
            }
        default: break
        }
        return []
    }

    func findArrayOfWords(in block: SimpleBlock, type: WordsFinderType) -> [[SimpleWord]?] {
        let indexes = Array(startIndex...endIndex)
        let arrayOfWords = indexes.map { findWords(in: block, lineIndex: $0, type: type, restrictedAt: [.horizontal]) }
        return arrayOfWords
    }

    enum WordsFinderType {
        case allowed
        case disallowed
        case all
    }
}
