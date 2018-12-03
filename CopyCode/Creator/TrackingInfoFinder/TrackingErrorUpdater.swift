//
//  TrackingErrorUpdater.swift
//  CopyCode
//
//  Created by Артем on 01/12/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

class TrackingErrorUpdater {
    private let preliminaryChecker = PreliminaryTrackingChecker()
    private let checker = TrackingChecker()

    func remained(_ trackingErrors: [TrackingError], after line: SimpleLine) -> [TrackingError] {
        return remained(trackingErrors, after: line.words)
    }

    func remained(_ trackingErrors: [TrackingError], after words: [SimpleWord]) -> [TrackingError] {
        var errors = trackingErrors
        words.forEach { errors = remained(errors, after: $0) }
        return errors
    }

    func remained(_ trackingErrors: [TrackingError], after word: SimpleWord) -> [TrackingError] {
        var updatedTrackings: [TrackingError] = []
        let wordGaps = word.corrrectedGapsWithOutside()
        for trackingError in trackingErrors {
            let trackingWidth = trackingError.tracking.width
            guard preliminaryChecker.check(word, trackingWidth: trackingWidth),
                let gaps = Gap.updatedOutside(wordGaps, with: trackingWidth) else { continue }

            let result = checker.check(gaps, with: trackingError.tracking)
            if result.result {
                let newRate = trackingError.errorRate + result.errorRate
                let newTracking = TrackingError(tracking: trackingError.tracking, errorRate: newRate)
                updatedTrackings.append(newTracking)
            }
        }
        return updatedTrackings
    }
}
