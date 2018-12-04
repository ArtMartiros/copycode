//
//  TrackingInfoFormatter.swift
//  CopyCode
//
//  Created by Артем on 06/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

///соединяет только тракинги идующие подряд с одинаковым тракингом
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
            guard isEqual(main: currentInfo, with: info) else { break }
            temporaryBlocked.insert(index)
            temporaryChunk.append(info)
            blocked = temporaryBlocked
            chunk = temporaryChunk
        }

        blocked = temporaryBlocked
        chunk = temporaryChunk

        return (chunk, blocked)
    }

    private func isEqual(main: TrackingInfo, with second: TrackingInfo) -> Bool {
        guard let mainTracking = main.tracking else { return false }
        let exist = second.trackingErrors.first { EqualityChecker.check(of: mainTracking.width, with: $0.tracking.width,
                                                                        errorPercentRate: kErrorPercentAdditionalCheckRate) } != nil
        return exist
    }
}
