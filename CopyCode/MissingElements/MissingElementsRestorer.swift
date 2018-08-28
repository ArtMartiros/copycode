//
//  MissingElementsRestorer.swift
//  CopyCode
//
//  Created by Артем on 23/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

///Восстанавилвает потерянные линии, буквы
class MissingElementsRestorer {
    let finder: MissingElementsFinder
    
    init(finder: MissingElementsFinder) {
        self.finder = finder
    }
    
    ///восстанавливает потерянные линии внутри блока
    func restore(_ block: Block<LetterRectangle>) -> Block<LetterRectangle> {
        var newLines: [Line<LetterRectangle>] = []
        for (index, line) in block.lines.enumerated() {
            let newLine = restore(line: line, leftBorder: block.frame.leftX, rightBorder: block.frame.rightX)
            newLines.append(newLine)
            
            let nextIndex = index + 1
            let isLastElement = nextIndex == block.lines.count
            
            guard !isLastElement else { break  }
            
            let nextLine = block.lines[nextIndex]
            let height = line.frame.bottomY - nextLine.frame.bottomY
            let rect = CGRect(x: block.frame.leftX, y: nextLine.frame.bottomY,
                              width: block.frame.width, height: height)
            if let missingLine = finder.findMissingLine(in: rect) {
                newLines.append(missingLine)
            }
        }

        return Block.from(newLines)
    }
   
    ///восстанавливает потерянные буквы для слов внутри линии
    func restore(line: Line<LetterRectangle>, leftBorder: CGFloat, rightBorder: CGFloat) -> Line<LetterRectangle> {
        let words = line.words
        var mixX = leftBorder
        var newWords: [Word<LetterRectangle>] = []
        for (index, word) in words.enumerated() {
            var letters: [LetterRectangle] = []
            let width = word.frame.leftX - mixX
            let rect = CGRect(x: mixX, y: line.frame.bottomY, width: width, height: line.frame.height)
            letters = finder.findMissingLetters(in: rect, with: .maxXEdge)
            
            let lastWord = index + 1 == words.count
            if lastWord {
                let width = rightBorder - word.frame.rightX
                let rect = CGRect(x: word.frame.rightX, y: line.frame.bottomY, width: width, height: line.frame.height)
                letters += finder.findMissingLetters(in: rect, with: .minXEdge)
            }
            
            if letters.isEmpty {
                newWords.append(word)
            } else {
                letters += word.letters
                newWords.append(Word.from(letters.sortedFromLeftToRight))
            }
            mixX = word.frame.leftX
        }
        return line
    }

}







