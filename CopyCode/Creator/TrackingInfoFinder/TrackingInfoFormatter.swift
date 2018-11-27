//
//  TrackingInfoFormatter.swift
//  CopyCode
//
//  Created by Артем on 06/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct TrackingInfoFormatter {
    private let kErrorPercentRate: CGFloat = 2
    private let breackChecker = BreakChecker()
    typealias Result = (chunkInfos: [TrackingInfo], blockedIndexes: Set<Int>)

    func chunk(_ infos: [TrackingInfo], with block: SimpleBlock) -> [[TrackingInfo]] {
        var blockedIndexes = Set<Int>()
        var chunks: [[TrackingInfo]] = []

        for index in infos.indices where !blockedIndexes.contains(index) {
            let (chunk, blocked) = getChunkInfo(at: index, from: infos, and: block, excluding: blockedIndexes)
            blockedIndexes.formUnion(blocked)
            chunks.append(chunk)
        }
        return chunks
    }

    private func getChunkInfo(at current: Int, from infos: [TrackingInfo], and block: SimpleBlock,
                              excluding blockedIndexes: Set<Int>) -> Result {

        let currentInfo = infos[current]

        var chunk = [currentInfo]
        var blocked = blockedIndexes

        guard currentInfo.tracking?.width != nil,
            let range = currentInfo.xRange(at: block, type: .allowed)
            else { return (chunk, blocked) }

        var temporaryChunk = chunk
        var temporaryBlocked = blockedIndexes

        for (index, info) in infos.enumerated() where index > current && !blocked.contains(index) {

            if isSameTracking(between: currentInfo, and: info) {
                temporaryBlocked.insert(index)
                temporaryChunk.append(info)
                blocked = temporaryBlocked
                chunk = temporaryChunk
                continue
            }

            if isIntersect(between: range, with: info, block: block) {
                if case .success(let forbidden) = findForbidden(for: info, in: range, block: block) {
                    var newInfo = currentInfo
                    //FIXMEF
                    newInfo.forbiddens.merge(forbidden) { (_, new) in new }
                    temporaryChunk.removeFirst()
                    temporaryChunk.insert(newInfo, at: 0)
                    temporaryChunk.append(info)
                    temporaryBlocked.insert(index)
                }
            }

            if isBlocked(current: currentInfo, and: info, in: block) {
                return (chunk, blocked)
            }
        }

        blocked = temporaryBlocked
        chunk = temporaryChunk

        return (chunk, blocked)
    }

    private func isIntersect(between currentRange: TrackingRange, with next: TrackingInfo, block: SimpleBlock) -> Bool {
        guard let nextRange = next.xRange(at: block, type: .allowed) else { return false }
        return  currentRange.intesected(with: nextRange) != nil
    }

    private func isSameTracking(between current: TrackingInfo, and compared: TrackingInfo) -> Bool {
        guard let currentWidth = current.tracking?.width,
            let comparedWidth = compared.tracking?.width,
            EqualityChecker.check(of: currentWidth, with: comparedWidth, errorPercentRate: kErrorPercentRate)
            else { return false }
        return true

    }

   private func exception(_ range: TrackingRange, and blockingInfo: TrackingInfo, in block: SimpleBlock) -> Bool {
        let lineNumbers = blockingInfo.findLineIndexes(from: block, in: range)
        for number in lineNumbers {
            let words = blockingInfo.findWord(in: range, at: number, with: block)
            let filteredWords = words.filter { $0.letters.count > 1 }
            if !filteredWords.isEmpty {
                return false
            }
        }
        return true
    }

    private func isBlocked(current: TrackingInfo, and blockingInfo: TrackingInfo, in block: SimpleBlock) -> Bool {
        guard let currentXrange = current.xRange(at: block, type: .allowed),
            let nextRangeX = blockingInfo.xRange(at: block, type: .all) else { return true }

        if currentXrange.intesected(with: nextRangeX) == nil {
            return false
        }

        if exception(currentXrange, and: blockingInfo, in: block) {
            return false
        }

        let result = findForbidden(for: current, in: nextRangeX, block: block)
        switch result {
        case .failure: return true
        case .success: return false
        }
    }

    private func findForbidden(for blockingInfo: TrackingInfo, in range: TrackingRange, block: SimpleBlock) -> SimpleSuccess<LineRestrictionDictionary> {
        var forbidden: LineRestrictionDictionary = [:]
        let lineIndexes = blockingInfo.findLineIndexes(from: block, in: range)
        for lineIndex in lineIndexes {
            let words = block.lines[lineIndex].words

            for (wordIndex, word) in words.enumerated() {
                let wordRange = word.frame.leftX...word.frame.rightX
                let intersect = wordRange.intesected(with: range) != nil

                guard intersect else { continue }
                if wordIndex == 0 {
                    guard words.count > 1,
                        breackChecker.check(if: word, shouldBreakWith: words[wordIndex + 1]),
                        exception(range, and: blockingInfo, in: block)
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

final class BreakChecker {
    ///сколько высот слова должно быть в ширине между словами, чтоб разделить линию
    private let kBreakLineRate: CGFloat = 6
    func check(if word: SimpleWord, shouldBreakWith second: SimpleWord) -> Bool {
        let differentOne = abs(word.frame.leftX - second.frame.rightX)
        let differentTwo = abs(word.frame.rightX - second.frame.leftX)
        let different = min(differentOne, differentTwo)
        let shouldBreak = different / word.frame.height > kBreakLineRate
        return shouldBreak
    }
}
