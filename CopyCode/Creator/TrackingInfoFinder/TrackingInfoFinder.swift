//
//  TrackingInfoFinder.swift
//  CopyCode
//
//  Created by Артем on 06/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct TrackingInfoFinder {
    typealias SplittedWords = (biggestWord: Word<LetterRectangle>, otherWords: [Word<LetterRectangle>])
    private let posFinder = PositionInfoFinder()
    private let action = Action()
    private let forbiddensCreator = RestrictionsCreator()

    func find(from block: Block<LetterRectangle>) -> [TrackingInfo] {
        var trackingInfos: [TrackingInfo] = []

        for lineIndex in block.lines.indices where shouldSearch(at: lineIndex, with: trackingInfos) {
            let trackingInfo = completeFindTrackingInfo(at: lineIndex, with: block.lines)
            trackingInfos.append(trackingInfo)
        }

        trackingInfos = sumSequenceOfNil(trackingInfos)
        return trackingInfos
    }

    private func shouldSearch(at currentIndex: Int, with infos: [TrackingInfo] ) -> Bool {
        if let endIndex = infos.last?.endIndex {
            return currentIndex == endIndex + 1
        } else {
            return currentIndex == 0
        }
    }

    private func completeFindTrackingInfo(at index: Int, with lines: [SimpleLine]) -> TrackingInfo {
        let line = lines[index]
        let posInfos = posFinder.find(from: line.words).sorted { $0.startX < $1.startX }
        let posInfosWithForbiddens = forbiddensCreator.create2(from: posInfos, lineIndex: index)

        for info in posInfosWithForbiddens where !info.posInfo.trackings.isEmpty {
            let trackings = info.posInfo.trackings.map { TrackingError(tracking: $0, errorRate: 0) }
            let trackingInfo = findTrackingInfo(in: lines, startAt: index, with: info.forbiddens, and: trackings)
            return trackingInfo
        }

        return TrackingInfo(startAt: index, endAt: index)
    }
    enum NewType {
        case update([TrackingError], restrictedX: CGFloat?)
        case split
    }

    func findTrackingInfo(in lines: [SimpleLine],
                          startAt startIndex: Int,
                          with forbiddens: [Int: LineRestriction],
                          and trackings: [TrackingError]) -> TrackingInfo {
        var lineTrackings = trackings
        var lastIndex = startIndex
        var forbiddens = forbiddens

        lineLoop: for lineIndex in lines.indices where startIndex < lineIndex {
            print("lineIndex \(lineIndex)\n\n")
            let type = getAction(for: lineTrackings, in: lines, at: lineIndex)
            switch type {
            case .split: break lineLoop
            case let .update(updatedTrackings, restrictedX: x):
                if let restrictedX = x {
                    //FIXMEF
                    forbiddens[lineIndex] = LineRestriction(leftX: nil, rightX: restrictedX)
                }
                lineTrackings = updatedTrackings
                lastIndex = lineIndex
            }
        }
        let info = infoWithSmallestErrorRate(from: lineTrackings, with: forbiddens, startAt: startIndex, endAt: lastIndex)
        return info
    }


    func getAction(for trackings: [TrackingError], in lines: [SimpleLine], at lineIndex: Int) -> NewType {
        var wordTrackings = trackings
        wordLoop: for wordIndex in lines[lineIndex].words.indices {
            print("wordIndex \(wordIndex)\n")
            let type = action.getAction(for: wordTrackings, in: lines, at: lineIndex, and: wordIndex)
            switch type {
            case .split: return .split
            case .forbidden(let x): return .update(wordTrackings, restrictedX: x)
            case .update(let updatedTrackings): wordTrackings = updatedTrackings
            }
        }
        return .update(wordTrackings, restrictedX: nil)
    }

    func test(in lines: [SimpleLine],
              startAt startIndex: Int,
              and trackings: [TrackingError]) {
        //через одну линию

    }
    private func infoWithSmallestErrorRate(from trackingErrors: [TrackingError],
                                           with forbiddens: [Int: LineRestriction],
                                           startAt start: Int,
                                           endAt end: Int) -> TrackingInfo {
        let trackings = trackingErrors.sorted { $0.errorRate < $1.errorRate }
        guard let smallestErrorRate = trackings.first else {
            return TrackingInfo(startAt: start, endAt: start)
        }

        return TrackingInfo(tracking: smallestErrorRate.tracking, forbiddens: forbiddens, startAt: start, endAt: end)
    }

    private func sumSequenceOfNil(_ trackingInfos: [TrackingInfo]) -> [TrackingInfo] {
        let infos = trackingInfos.reduce([TrackingInfo]()) { (result, info) -> [TrackingInfo] in
            var newResult = result
            if let lastInfo = result.last, lastInfo.tracking == nil, info.tracking == nil {
                let newInfo = TrackingInfo(startAt: lastInfo.startIndex, endAt: info.endIndex)
                newResult.removeLast()
                newResult.append(newInfo)
            } else {
                newResult.append(info)
            }
            return newResult
        }
        return infos
    }
}

extension TrackingInfoFinder {
    struct TrackingError: ErrorRateProtocol {
        let tracking: Tracking
        let errorRate: CGFloat
    }
}
