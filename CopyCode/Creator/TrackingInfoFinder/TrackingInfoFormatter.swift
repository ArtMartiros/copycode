//
//  TrackingInfoFormatter.swift
//  CopyCode
//
//  Created by Артем on 06/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

//требует доработки файл, так как часто тут код который в других местах использую, поэтому надо эту тему исправить
struct TrackingInfoFormatter {
    private let kErrorPercentRate: CGFloat = 2
    private let kErrorPercentAdditionalCheckRate: CGFloat = 6
    private let breackChecker = BreakChecker()

    private let checker = TrackingChecker()
    private let preliminaryChecker = PreliminaryTrackingChecker()
    private let updater = TrackingErrorUpdater()

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

        guard currentInfo.tracking?.width != nil else { return (chunk, blocked) }

        var temporaryChunk = chunk
        var temporaryBlocked = blockedIndexes

        for (index, info) in infos.enumerated() where index > current && !blocked.contains(index) {
            guard isSameTracking(between: currentInfo, and: info, block: block) else { break }
            temporaryBlocked.insert(index)
            temporaryChunk.append(info)
            blocked = temporaryBlocked
            chunk = temporaryChunk
            continue
        }

        blocked = temporaryBlocked
        chunk = temporaryChunk

        return (chunk, blocked)
    }

    private func isSameTracking(between current: TrackingInfo, and compared: TrackingInfo, block: SimpleBlock) -> Bool {
        guard let currentWidth = current.tracking?.width, let comparedWidth = compared.tracking?.width
            else { return false }

        if isEqual(main: current, with: compared) { return true }
        //по идее это надо удалить потому что эта херня решается в актион
        // может быть такое что тракинги отличаются но, на самом деле проходит проверка checkom поэтому стоит просто всю линию проверить в исключительных случаях
        if EqualityChecker.check(of: currentWidth, with: comparedWidth,
                                 errorPercentRate: kErrorPercentAdditionalCheckRate) {
            let words = compared.findWords(in: block, lineIndex: compared.startIndex,
                                           type: .allowed, restrictedAt: [.horizontal])
            for word in words {
                let wordGaps = word.corrrectedGapsWithOutside()
                guard preliminaryChecker.check(word, trackingWidth: currentWidth),
                    let gaps = Gap.updatedOutside(wordGaps, with: currentWidth) else { continue }

                let result = checker.check(gaps, with: current.tracking!)
                if !result.result { return false }
            }
            return true
        }
        return false

    }

    private func isEqual(main: TrackingInfo, with second: TrackingInfo) -> Bool {
        guard let mainTracking = main.tracking else { return false }

       let exist = second.trackingErrors.first { EqualityChecker.check(of: mainTracking.width, with: $0.tracking.width,
                                                               errorPercentRate: kErrorPercentAdditionalCheckRate) } != nil
        return exist
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
