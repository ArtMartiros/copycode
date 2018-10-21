//
//  TextTranscriptor.swift
//  CopyCode
//
//  Created by Артем on 16/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct TextTranscriptor {

    private let gridCorrelator = GridLineCorrelator()

    func transcript(block: CompletedBlock) -> String {
        guard case .grid(let grid) = block.typography else { return "empty" }
        let arrayOfFrames = grid.getArrayOfFrames(from: block.frame)
        let lines = block.lines
        let gridCorrelations = gridCorrelator.correlate(lines: lines, arrayOfFrames: arrayOfFrames)

        var stringLines: [String] = []

        for (key, value) in gridCorrelations {
            if let lineIndex = value {
                let string = getLineString(arrayOfFrames[key], with: lines[lineIndex])
                stringLines.append(string)
            } else {
                stringLines.append("\n")
            }
        }
        return stringLines.joined().trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func getLineString(_ singleLine: [CGRect], with line: CompletedLine) -> String {

        let letters = line.words.map { $0.letters }.reduce([], +)
        let lineCorrelation = gridCorrelator.correlate(letters, frames: singleLine)
        var word = ""
        for (_, value) in lineCorrelation {
            if let letterIndex = value {
                word.append(letters[letterIndex].value)
            } else {
                word.append(" ")
            }
        }
        return word.trimWhiteSpacesAtTheEnd() + "\n"
    }

}

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

    func compare<T: Rectangle>(_ standartFrame: CGRect, with letter: T) -> CompareX {
        let range: TrackingRange = standartFrame.leftX...standartFrame.rightX
        let range2: TrackingRange = letter.frame.leftX...letter.frame.rightX
        let newRangeOptional = range.intesected(with: range2)
        guard let newRange = newRangeOptional,
        EqualityChecker.check(of: newRange.distance, with: range2.distance, errorPercentRate: 20)
        else { return standartFrame.leftX < letter.frame.leftX ? .toTheRight : .toTheLeft }

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
