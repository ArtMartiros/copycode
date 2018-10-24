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


