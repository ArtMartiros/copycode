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
        return stringLines.joined()
    }
    

    func getLineString(_ singleLine: [CGRect], with line: CompletedLine) -> String {
        let letters = line.words.map { $0.letters }.reduce([], +)
        var lastIndex: Int = 0
        var word = ""
        for frame in singleLine {
            guard lastIndex < letters.count else {
                word.append(" ")
                continue
            }
            let result = compareLetter(frame, with: letters[lastIndex])
            switch result {
            case .inside:
                word.append(letters[lastIndex].value)
                lastIndex += 1
            case .lefter:
                word.append(" ")
            }
        }
        
        return word.trimWhiteSpacesAtTheEnd() + "\n"
    }

    func compareLetter(_ letterFrame: CGRect, with letter: Letter) -> CompareX {
        let range: TrackingRange = letterFrame.leftX...letterFrame.rightX
        let range2: TrackingRange = letter.frame.leftX...letter.frame.rightX
        let newRangeOptional = range.intesected(with: range2)
        guard let newRange = newRangeOptional else { return .lefter }
        guard EqualityChecker.check(of: newRange.distance, with: range2.distance, errorPercentRate: 20)
            else { return .lefter }
        
        return .inside
    }
    
    enum CompareX {
        case inside
        case lefter
    }

}

class GridLineCorrelator {
    typealias GridCorrelatorIndex = (gridIndex: Int, lineIndex: Int?)
    
    func correlate<T: Rectangle>(lines: [Line<T>], arrayOfFrames: [[CGRect]]) -> [GridCorrelatorIndex] {
        var gridArray: [GridCorrelatorIndex] = []
        
        var lastLineIndex = 0
        for (index, singleLine) in arrayOfFrames.enumerated() {
            guard lastLineIndex < lines.count else { continue }
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
