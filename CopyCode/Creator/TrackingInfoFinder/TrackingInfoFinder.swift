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
    private let posInfoWithForbiddenCreator = PosInfoWithForbiddensCreator()
    func find(from block: Block<LetterRectangle>) -> [TrackingInfo] {
        var trackingInfos: [TrackingInfo] = []

        for lineIndex in block.lines.indices where shouldSearch(at: lineIndex, with: trackingInfos) {
            let trackingInfo = completeFindTrackingInfo(at: lineIndex, at: block)
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

    private func completeFindTrackingInfo(at index: Int, at block: SimpleBlock) -> TrackingInfo {
        let line = block.lines[index]
        let posInfosWithForbiddens = posInfoWithForbiddenCreator.create(line, index: index)
        //по факту первый не пустой пос инфо работает
        let wordIndex = line.words.getBiggestWordIndex(excluded: [])
        let wordHeight = line.words[wordIndex].frame.height
        let action = Action(wordStandartHeight: wordHeight)
        for info in posInfosWithForbiddens where !info.posInfo.trackings.isEmpty {
            let temporaryInfo = TrackingInfo(info, startAt: index, endAt: index)
            let trackingInfo = findTrackingInfo(at: block, with: temporaryInfo, using: action)
            return trackingInfo
        }
        return TrackingInfo(startAt: index, endAt: index)
    }

    func findTrackingInfo(at block: SimpleBlock, with temporaryInfo: TrackingInfo, using action: Action) -> TrackingInfo {
        var info = temporaryInfo
        lineLoop: for lineIndex in block.lines.indices where info.endIndex < lineIndex {
            print("lineIndex \(lineIndex)\n\n")
            let type = action.action(with: info, at: block)
            switch type {
            case .failure: break lineLoop
            case .success(let updatedInfo):
                info = updatedInfo
                info.endIndex = getEndIndex(for: updatedInfo, in: lineIndex, at: block)
            }
        }
        return info
    }

    private func getEndIndex(for trackingInfo: TrackingInfo, in lineIndex: Int, at block: SimpleBlock) -> Int {
        guard lineIndex == block.lines.count - 1 else { return lineIndex }
        let words = trackingInfo.findWords(in: block, lineIndex: lineIndex, type: .allowed, restrictedAt: [.horizontal])
        return words.isExistElement ? lineIndex : trackingInfo.endIndex
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

struct TrackingError: ErrorRateProtocol {
    let tracking: Tracking
    let errorRate: CGFloat
}

extension Array where Element == TrackingError {
    var smallestErrorRate: TrackingError? {
        let trackings = sorted { $0.errorRate < $1.errorRate }
        return trackings.first
    }
}
