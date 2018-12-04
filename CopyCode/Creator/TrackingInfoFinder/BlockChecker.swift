//
//  BlockChecker.swift
//  CopyCode
//
//  Created by Артем on 04/12/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

class BlockChecker {
    private let breackChecker = BreakChecker()
    enum SomeType {
        case blocked
        case allowed(LineRestriction?)
    }
    func isBlocked(current: TrackingInfo, and line: SimpleLine, lineIndex: Int, in block: SimpleBlock) -> SomeType {
        guard let currentXrange = current.xRange(at: block, type: .allowed) else { return .blocked }
        let nextRangeX = line.frame.leftX...line.frame.rightX
        if currentXrange.intesected(with: nextRangeX) == nil {
            let restriction: LineRestriction
            if nextRangeX.lowerBound < currentXrange.lowerBound {
                restriction = LineRestriction(leftX: nextRangeX.upperBound, rightX: nil)
            } else {
                restriction = LineRestriction(leftX: nil, rightX: nextRangeX.lowerBound)
            }
            return .allowed(restriction)
        }

        if exception(currentXrange, and: line) {
            return .allowed(nil)
        }

        let result = findForbidden(for: current, in: nextRangeX, block: block)
        switch result {
        case .failure: return .blocked
        case .success: return .allowed(nil)
        }
    }

    // если ни в одной линии нет слова больше чем с одной буквы
    private func exception(_ range: TrackingRange, and line: SimpleLine) -> Bool {
        let words = line.words
        let filteredWords = words.filter { $0.letters.count > 1 }
        return filteredWords.isEmpty
    }

    private func findForbidden(for blockingInfo: TrackingInfo, in range: TrackingRange, block: SimpleBlock) -> SimpleSuccess<LineRestrictionDictionary> {
        var forbidden: LineRestrictionDictionary = [:]
        let lineIndexes = blockingInfo.findLineIndexes(from: block, in: range)
        for lineIndex in lineIndexes {
            let words = blockingInfo.findWords(in: block, lineIndex: lineIndex, type: .allowed, restrictedAt: [.horizontal])

            for (wordIndex, word) in words.enumerated() {
                let wordRange = word.frame.leftX...word.frame.rightX
                let intersect = wordRange.intesected(with: range) != nil

                guard intersect else { continue }
                if wordIndex == 0 {
                    guard words.count > 1,
                        breackChecker.check(if: word, shouldBreakWith: words[wordIndex + 1])
                        else { return .failure }
                    //FIXMEF
                    forbidden[lineIndex] = LineRestriction(leftX: nil, rightX: word.frame.leftX)
                    break
                } else {
                    if breackChecker.check(if: word, shouldBreakWith: words[wordIndex - 1]) {
                        forbidden[lineIndex] = LineRestriction(leftX: nil, rightX: word.frame.leftX)
                        break
                    } else {
                        return .failure
                    }
                }
            }
        }
        return .success(forbidden)
    }
}
