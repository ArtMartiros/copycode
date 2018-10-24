//
//  GridLineCorrelator.swift
//  CopyCode
//
//  Created by Артем on 24/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

final class GridLineCorrelator {
    typealias GridCorrelatorIndex = (gridIndex: Int, lineIndex: Int?)

    func correlate<T: Rectangle>(lines: [Line<T>], arrayOfFrames: [[CGRect]]) -> [GridCorrelatorIndex] {
        var gridArray: [GridCorrelatorIndex] = []

        var lastLineIndex = 0
        for (index, singleLine) in arrayOfFrames.enumerated() {
            guard lastLineIndex < lines.count else {
                gridArray.append((index, nil))
                continue
            }
            var lineIndex: Int?

            let result = compare(singleLine, with: lines[lastLineIndex])
            if result == .inside {
                lineIndex = lastLineIndex
                lastLineIndex += 1
            }

            let value = (index, lineIndex)
            gridArray.append(value)
        }
        return gridArray
    }

    func correlate<T: Rectangle>(_ letters: [T], frames: [CGRect]) -> [GridCorrelatorIndex] {
        var gridArray: [GridCorrelatorIndex] = []
        var currentLetterIndex = 0
        for (index, frame) in frames.enumerated() {
            guard currentLetterIndex < letters.count else {
                gridArray.append((index, nil))
                continue
            }
            letterLoop: for (letterIndex, letter) in letters.enumerated() where currentLetterIndex <= letterIndex {
                let result = compare(frame, with: letter)
                switch result {
                case .inside:
                    currentLetterIndex += 1
                    gridArray.append((index, letterIndex))
                    break letterLoop
                case .toTheLeft:
                    continue letterLoop
                case .toTheRight:
                    gridArray.append((index, nil))
                    break letterLoop
                }
            }
        }
        return gridArray
    }

    enum CompareX {
        case inside
        case toTheLeft
        case toTheRight
    }

    private let kRangeRate: CGFloat = 40
    private let kRangeRate2: CGFloat = 20
    func compare<T: Rectangle>(_ standartFrame: CGRect, with letter: T) -> CompareX {
        let standartRange: TrackingRange = standartFrame.leftX...standartFrame.rightX
        let letterRange: TrackingRange = letter.frame.leftX...letter.frame.rightX
        let negativeResult: CompareX = standartFrame.leftX < letter.frame.leftX ? .toTheRight : .toTheLeft

        guard let intersectedRange = standartRange.intesected(with: letterRange) else { return negativeResult }
        if standartFrame.width > letter.frame.width * 0.3 {
            guard EqualityChecker.check(of: intersectedRange.distance, with: letterRange.distance, errorPercentRate: kRangeRate)
                else { return negativeResult }
        } else {
            guard EqualityChecker.check(of: intersectedRange.distance, with: letterRange.distance, errorPercentRate: kRangeRate2)
                else { return negativeResult }
        }

        return .inside
    }

    func compare<T: Rectangle>(_ singleLine: [CGRect], with lineFrame: Line<T>) -> CompareY {
        let frame = singleLine[0]

        if frame.bottomY > lineFrame.frame.topY {
            return .higher
        } else {
            return .inside
        }
    }

    enum CompareY {
        case lower
        case higher
        case inside
    }
}
