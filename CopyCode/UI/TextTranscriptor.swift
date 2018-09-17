//
//  TextTranscriptor.swift
//  CopyCode
//
//  Created by Артем on 16/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation


struct TextTranscriptor {
    func test(block: CompletedBlock) -> String {
        guard case .grid(let grid) = block.typography else { return "empty" }
        let arrayOfFrames = grid.getArrayOfFrames(from: block.frame)
        var lastLineIndex = 0
        var stringLines: [String] = []
        let lines = block.lines
        for singleLine in arrayOfFrames {
            guard lastLineIndex < lines.count else {
                stringLines.append("\n")
                continue
            }
            if let result = test2(singleLine, with: lines, startIndex: lastLineIndex) {
                lastLineIndex = result.index
                stringLines.append(result.value)
            }
        }
        return stringLines.joined()
    }
    
    func test2(_ singleLine: [CGRect], with lines: [CompletedLine], startIndex: Int) -> (index: Int, value: String)? {
        
        let result = compare(singleLine, with: lines[startIndex])
        switch result {
        case .inside:
            let lineString = self.lineString(singleLine, with: lines[startIndex])
            return (startIndex + 1, lineString)
        case .higher: return (startIndex, "\n")
        case .lower: return nil
        }
    }
    
    func lineString(_ singleLine: [CGRect], with line: CompletedLine) -> String {
        let letters = line.words.map { $0.letters }.reduce([], +)
        var lastIndex: Int = 0
        var word = ""
        for frame in singleLine {
            guard lastIndex < letters.count else {
                word.append(" ")
                continue
            }
            let result = compare(frame, with: letters[lastIndex])
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
    
    func compare(_ singleLine: [CGRect], with lineFrame: CompletedLine) -> CompareY {
        let frame = singleLine[0]
        
        if frame.bottomY > lineFrame.frame.topY {
            return .higher
        } else {
           return .inside
        }
    }
    
    func compare(_ letterFrame: CGRect, with letter: Letter) -> CompareX {
        let range: TrackingRange = letterFrame.leftX...letterFrame.rightX
        let range2: TrackingRange = letter.frame.leftX...letter.frame.rightX
        guard let newRange = range.intesected(with: range2),
            EqualityChecker.check(of: newRange.distance, with: range2.distance, errorPercentRate: 20)
            else { return .lefter }
        return .inside
    }
    
    enum CompareX {
        case inside
        case lefter
    }
    
    enum CompareY {
        case lower
        case higher
        case inside
    }
    
}
