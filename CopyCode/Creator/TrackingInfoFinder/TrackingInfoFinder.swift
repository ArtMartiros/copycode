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
    private let forbiddensCreator = ForbiddensCreator()

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
        guard let (posInfo, forbiddens) = positionWithForbiddens(from: line.words, at: index) else {
            return TrackingInfo(startAt: index, endAt: index)
        }

        let trackings = posInfo.trackings.map { TrackingError(tracking: $0, errorRate: 0) }
        let trackingInfo = findTrackingInfo(in: lines, startAt: index, with: forbiddens, and: trackings)

        return trackingInfo
    }

    private func positionWithForbiddens(from words: [SimpleWord], at index: Int) -> (PositionInfo, [Int: CGFloat])? {
        let posInfos = posFinder.find(from: words).sorted { $0.startX < $1.startX }
        guard let posInfo = posInfos.first, !posInfo.trackings.isEmpty else {
            return nil
        }

        let forbiddens = forbiddensCreator.create(from: posInfos, lineIndex: index)
        return (posInfo, forbiddens)
    }

    private func findTrackingInfo(in lines: [SimpleLine], startAt startIndex: Int, with forbiddens: Forbidden,
                                  and trackings: [TrackingError]) -> TrackingInfo {
        var lineTrackings = trackings
        var lastIndex = startIndex
        var forbiddens = forbiddens

        lineLoop: for (lineIndex, line) in lines.enumerated() where startIndex < lineIndex {
            print("lineIndex \(lineIndex)\n\n")
            var wordTrackings = lineTrackings

            wordLoop: for wordIndex in line.words.indices {
                print("wordIndex \(wordIndex)\n")

                let type = action.getAction(for: wordTrackings, in: lines, at: lineIndex, and: wordIndex)
                switch type {
                case .split:
                    break lineLoop

                case .sum(let updatedTrackings):
                    wordTrackings = updatedTrackings

                case .forbidden(let forbiddenX):
                    forbiddens[lineIndex] = forbiddenX
                    break wordLoop
                }
            }

            lineTrackings = wordTrackings
            lastIndex = lineIndex
        }

        let info = infoWithSmallestErrorRate(from: lineTrackings, with: forbiddens, startAt: startIndex, endAt: lastIndex)
        return info
    }

    private func infoWithSmallestErrorRate(from trackingErrors: [TrackingError], with forbiddens: Forbidden,
                                           startAt start: Int, endAt end: Int) -> TrackingInfo {
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
