//
//  LetterRestorer.swift
//  CopyCode
//
//  Created by Артем on 04/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct LetterRestorer {
    func restore(_ block: SimpleBlock) -> SimpleBlock {
        guard case .grid(let grid) = block.typography else { return block }
        var lines: [SimpleLine] = []
        
        var lineChanged = false
        
        for line in block.lines {
            let result = restore(line, grid: grid)
            switch result {
            case .failure: lines.append(line)
            case .success(let newLine):
                lines.append(newLine)
                lineChanged = true
            }
        }
        
        guard lineChanged else { return block }
        
        return Block(lines: lines, frame: block.frame, column: block.column, typography: block.typography)
    }
    
    func restore(_ line: SimpleLine, grid: TypographicalGrid) -> SimpleSuccess<SimpleLine> {
        var words: [SimpleWord] = []
        var wordChanged = false
        
        for word in line.words {
           let result = restore(word, grid: grid)
            switch result {
            case .failure: words.append(word)
            case .success(let newWord):
               words.append(newWord)
                wordChanged = true
            }
        }
       
        guard wordChanged else { return .failure }
        
        let newLine = Line(words: words)
        return .success(newLine)
    }
    
    func restore(_ word: SimpleWord, grid: TypographicalGrid) -> SimpleSuccess<SimpleWord> {
        let tracking = grid.trackingData[word.frame.topY]
        
        var letters: [LetterRectangle] = []
    
        var lastChagedIndex: Int?
        word.letters.forEachPairWithIndex { (current, next, index) in
            var shouldExecute = true
            if lastChagedIndex != nil, lastChagedIndex! == index {
                shouldExecute = false
            }
            if shouldExecute {
                let width = next.frame.rightX - current.frame.leftX
                if width < tracking.width {
                    lastChagedIndex = index + 1
                    let newLetter = getNewLetter(current: current, next: next)
                    letters.append(newLetter)
                } else {
                    letters.append(current)
                    let isLastIteration = index + 2 == word.letters.count
                    if isLastIteration {
                        letters.append(next)
                    }
                }
            }

        }
        
        guard lastChagedIndex != nil else { return .failure }

        let newWord = Word(frame: word.frame, pixelFrame: word.pixelFrame, type: .mix, letters: letters)
        return .success(newWord)
    }
    
    private func getNewFrame(current: CGRect, next: CGRect) -> CGRect {
        let top = max(current.topY, next.topY)
        let bottom = min(current.bottomY, next.bottomY)
        let frame = CGRect(left: current.leftX, right: next.rightX, top: top, bottom: bottom)
        return frame
    }
    
    private func getNewLetter(current: LetterRectangle, next: LetterRectangle) -> LetterRectangle {
        let frame = getNewFrame(current: current.frame, next: next.frame)
        let pixelFrame = getNewFrame(current: current.pixelFrame, next: next.pixelFrame)
        return LetterRectangle(frame: frame, pixelFrame: pixelFrame, type: .doubleQuote)
    }
}
