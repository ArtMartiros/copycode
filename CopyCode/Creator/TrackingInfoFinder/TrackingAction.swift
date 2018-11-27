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
        case update([TrackingError])
        case split
        case forbidden(x: CGFloat)
    }

    struct Action {
        private let trackingFinder = TrackingFinder()
        private let checker = TrackingChecker()
        private let preliminaryChecker = PreliminaryTrackingChecker()

        func getAction(for trackings: [TrackingError], in lines: [SimpleLine], at lineIndex: Int,
                       and wordIndex: Int) -> ActionType {

            assert(lineIndex != 0, "TrackingInfoFinder lineIndex cannot be equal 0")
            assert(!trackings.isEmpty, "TrackingInfoFinder trackings cannot be empty")

            let line = lines[lineIndex]
            let word = line.words[wordIndex]
            let trackingErrors = updateTrackingErrors(word, with: trackings)

            guard trackingErrors.isEmpty else {
                return .update(trackingErrors)
            }

            // Если нет результатов
            let previousWidth = trackings[0].tracking.width

            if wordIndex == 0 {
                guard !intersected(frame: word.frame, with: lines[lineIndex - 1].frame),
                    let tracking = trackingFinder.findTrackings(from: word).first,
                    !EqualityChecker.check(of: tracking.width, with: previousWidth, errorPercentRate: 3) else {
                        return .split
                }

                let allOk = checkNextLine(in: lines, currentLineIndex: lineIndex, errors: trackings)
                return allOk ? .forbidden(x: word.frame.leftX) : .split

            } else {
                guard let tracking = trackingFinder.findTrackings(from: word).first else {
                    return .forbidden(x: word.frame.leftX)
                }

                let isSimilar = EqualityChecker.check(of: tracking.width, with: previousWidth, errorPercentRate: 3)
                return isSimilar ? .split : .forbidden(x: word.frame.leftX)

            }

        }

        private func intersected(frame: CGRect, with secondFrame: CGRect) -> Bool {
            let range = frame.leftX...frame.rightX
            let secondRange = secondFrame.leftX...secondFrame.rightX
            return range.intesected(with: secondRange) != nil
        }

        ///проверяет след линию на совпадение TrackingError но исключая слова с двумя и меньше символами
        private func checkNextLine(in lines: [SimpleLine], currentLineIndex: Int, errors: [TrackingError]) -> Bool {
            let nextLineIndex = currentLineIndex + 1
            guard nextLineIndex != lines.count else { return false }

            let line = lines[nextLineIndex]
            for word in line.words {
                guard word.letters.count > 2 else { continue }
                return !updateTrackingErrors(word, with: errors).isEmpty
            }
            return false
        }

        private func updateTrackingErrors(_ word: SimpleWord, with trackingErrors: [TrackingError]) -> [TrackingError] {
            var updatedTrackings: [TrackingError] = []
            let wordGaps = word.fixedGapsWithOutside
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

    struct PreliminaryTrackingChecker {

        private let maxRateHight: CGFloat = 1.8
        //чтобы исключить всякую хрень как логотипы
        func check(_ word: SimpleWord, trackingWidth: CGFloat) -> Bool {
            guard word.frame.height / trackingWidth < maxRateHight else { return false }

            for letter in word.letters {
                let width = letter.frame.width

                if width < trackingWidth ||
                    EqualityChecker.check(of: width, with: trackingWidth, errorPercentRate: 10) {
                    continue
                } else {
                    let newWidth = (trackingWidth * 2)
                    guard EqualityChecker.check(of: newWidth, with: width, errorPercentRate: 4) else {
                        return false
                    }
                }
            }
            return true
        }
    }

}
