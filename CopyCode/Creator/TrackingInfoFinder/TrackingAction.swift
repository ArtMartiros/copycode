//
//  TrackingAction.swift
//  CopyCode
//
//  Created by Артем on 01/11/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

extension TrackingInfoFinder {
    enum ActionType {
        case update([TrackingError], restrictedX: CGFloat?)
        case split
    }

    struct Action {
        private let trackingFinder = TrackingFinder()
        private let updater = TrackingErrorUpdater()
        private let posInfoWithForbiddenCreator = PosInfoWithForbiddensCreator()
        private let blockChecker = BlockChecker()
        private let samenessChecker = WordHeightSamenessChecker()
        private let wordStandartHeight: CGFloat

        init(wordStandartHeight: CGFloat) {
            self.wordStandartHeight = wordStandartHeight
        }

        func action(with info: TrackingInfo, at block: SimpleBlock) -> SimpleSuccess<TrackingInfo> {
            var info = info
            var posInfoWithForbidden: [PositionInfoWithForbidden] = []
            let lineIndex = info.endIndex + 1 //текущий
            let line = block.lines[lineIndex]
            wordLoop: for (wordIndex, word) in line.words.enumerated() where isAllowed(word, in: info.restrictionDic[lineIndex]) {
                let type = action(for: info, in: lineIndex, and: wordIndex, at: block)
                switch type {
                case .different:
                    //есть все таки такой же тракинг
                    posInfoWithForbidden = posInfoWithForbiddenCreator.create(line, index: lineIndex)
                    if let posInfo = getPos(from: posInfoWithForbidden, similarTo: info.trackingErrors[0].tracking) {
                        info.restrictionDic[lineIndex] = posInfo.forbiddens[lineIndex]
                        continue wordLoop
                    }

                    let blocked = blockChecker.isBlocked(current: info, and: line, lineIndex: lineIndex, in: block)
                    switch blocked {
                    case .blocked: return .failure
                    case .allowed(let restriction): info.restrictionDic[lineIndex] = restriction
                    }
                    return .success(info)
                case .similarTracking: return .failure  //мы его отделим так как можно найти намного лучший тракинг для него
                case .forbidden:
                    var temporaryRestriction = info.restrictionDic[lineIndex] ?? LineRestriction()
                    temporaryRestriction.rightX = word.frame.leftX
                    info.restrictionDic[lineIndex] = temporaryRestriction
                    return .success(info)
                case .update(let updatedTrackings): info.trackingErrors = updatedTrackings
                case .quote: continue wordLoop
                case .shitWord: info.restrictionDic[lineIndex] = LineRestriction(leftX: word.frame.rightX, rightX: nil)

                }
            }
            return .success(info)
        }

        private func action(for info: TrackingInfo, in lineIndex: Int, and wordIndex: Int, at block: SimpleBlock) -> WordActionType {
            let trackings = info.trackingErrors
            assert(lineIndex != 0, "TrackingInfoFinder lineIndex cannot be equal 0")
            assert(!trackings.isEmpty, "TrackingInfoFinder trackings cannot be empty")

            let line = block.lines[lineIndex]
            let word = line.words[wordIndex]

            if isShit(word, in: wordIndex, with: info, at: block) {
                return .shitWord
            }
            if word.isQuoteWord(trackingWidth: trackings[0].tracking.width) {
                return .quote
            }

            let trackingErrors = updater.remained(trackings, after: word)
            let previous = trackings[0].tracking

            guard trackingErrors.isEmpty else { return .update(trackingErrors) }
            if let tracking = trackingFinder.findTrackings(from: word).first, isEqual(tracking, with: previous) {
                return .similarTracking
            }
            return wordIndex == 0 ? .different : .forbidden
        }

        private func getPos(from infos: [PositionInfoWithForbidden], similarTo tracking: Tracking) -> PositionInfoWithForbidden? {
            for info in infos where !info.posInfo.trackings.isEmpty {
                if isEqual(tracking, with: info.posInfo.trackings[0]) { return info }
            }
            return nil
        }

        private func isAllowed(_ word: SimpleWord, in area: LineRestriction?) -> Bool {
            guard let area = area else { return true }
            if let leftX = area.leftX, word.frame.leftX < leftX { return false }
            if let rightX = area.rightX, word.frame.rightX > rightX { return false }
            return true
        }

        private func isEqual(_ first: Tracking, with second: Tracking) -> Bool {
            return EqualityChecker.check(of: first.width, with: second.width, errorPercentRate: 3)
        }

        private func isShit(_ word: SimpleWord, in wordIndex: Int, with info: TrackingInfo, at block: SimpleBlock) -> Bool {
            guard wordIndex == 0,
                let allowedRange = info.xRange(at: block, type: .allowed),
                word.frame.xRange().intesected(with: allowedRange) == nil,
                !samenessChecker.check(wordStandartHeight, with: word) else  {
                    return false
            }
            return true
        }

        enum WordActionType {
            case update([TrackingError])
            case different
            case similarTracking
            case forbidden
            case quote
            case shitWord
        }
    }
}

extension TrackingInfoFinder {
    class PosInfoWithForbiddensCreator {
        private let posFinder = PositionInfoFinder()
        private let forbiddensCreator = RestrictionsCreator()
        func create(_ line: SimpleLine, index: Int) -> [PositionInfoWithForbidden] {
            let posInfos = posFinder.find(from: line.words).sorted { $0.startX < $1.startX }
            let posInfosWithForbiddens = forbiddensCreator.create(from: posInfos, lineIndex: index)
            return posInfosWithForbiddens
        }
    }
}
