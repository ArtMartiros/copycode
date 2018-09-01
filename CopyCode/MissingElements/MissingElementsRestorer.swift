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
    enum HorizontalDirection {
        case left
        case right(constraint: CGRect?)
        
        var edge: CGRectEdge {
            switch self {
            case .right: return .minXEdge
            case .left: return .maxXEdge
            }
        }
    }

    let finder: MissingElementsFinder
    
    init(finder: MissingElementsFinder) {
        self.finder = finder
    }
    
    ///восстанавливает потерянные линии внутри блока
    func restore(_ block: Block<LetterRectangle>, constraint: CGRect?) -> Block<LetterRectangle> {
        
        let lineHeight = block.maxLineHeight()
        let letterWidth =  LetterRectangle.letterWidth(from: lineHeight)
        var restoredLines = block.lines
            .compactMap { restoreWords(in: $0, letterWidth: letterWidth, blockBounds: block, constraint: constraint) }
        
        let newLines = block.gaps
            .compactMap { finder.findMissingLine(in: $0.frame, lineHeight: lineHeight, letterWidth: letterWidth) }
            .reduce([Line<LetterRectangle>]()) { $0 + $1 }
       
        restoredLines.append(contentsOf: newLines)
        return Block.from(restoredLines.sortedFromTopToBottom, column: block.column)
    }
   
    ///восстанавливает потерянные буквы для слов внутри линии
    func restoreWords(in line: Line<LetterRectangle>, letterWidth: CGFloat,
                      blockBounds: StandartRectangle, constraint: CGRect?) -> Line<LetterRectangle>? {
        var newWords: [Word<LetterRectangle>] = []//line.words
        // между началом блока и началом линии
        if let word = findWord(betweenLine: line, letterWidth: letterWidth, andBlock: blockBounds, direction: .left) {
            newWords.append(word)
        }
        
        // внутри линии
        line.gaps.forEach {
            if let word = findWord(inside: $0.frame, letterWidth: letterWidth, with: .minXEdge) {
                newWords.append(word)
            }
        }
        
        // между концом линии и концом блока
        if let word = findWord(betweenLine: line, letterWidth: letterWidth, andBlock: blockBounds,
                               direction: .right(constraint: constraint)) {
            newWords.append(word)
        }
        
        guard !newWords.isEmpty else { return nil }
        return Line(words: newWords.sortedFromLeftToRight)
    }
    
    private func findWord(inside frame: CGRect, letterWidth: CGFloat, with edge: CGRectEdge) -> Word<LetterRectangle>? {
        let letters = finder.findMissingLetters(in: frame, letterWidth: letterWidth, with: edge)
        guard !letters.isEmpty else { return nil }
        let word = (Word.from(letters.sortedFromLeftToRight))
        return word
    }
    
    private func findWord(betweenLine line: StandartRectangle,
                          letterWidth: CGFloat,
                          andBlock block: StandartRectangle, direction: HorizontalDirection) -> Word<LetterRectangle>? {
        let frame = createFrame(betweenLine: line, andBlock: block, direction: direction)
        guard frame.width != 0 else { return nil}
        return  findWord(inside: frame, letterWidth: letterWidth, with: direction.edge)
    }

    private func createFrame(betweenLine line: StandartRectangle,
                             andBlock block: StandartRectangle,
                             direction: HorizontalDirection) -> CGRect {
        var frame: CGRect!
        switch direction {
        case .left:
            frame = CGRect(left: block.frame.leftX, right: line.frame.leftX,
                           top: line.frame.topY, bottom: line.frame.bottomY)
        case .right(let constraint):
            frame = CGRect(left: line.frame.rightX, right: block.frame.rightX,
                           top: line.frame.topY, bottom: line.frame.bottomY)
            if let constraint = constraint, constraint.intersects(frame) {
                frame = CGRect(left: line.frame.rightX, right: constraint.leftX,
                               top: line.frame.topY, bottom: line.frame.bottomY)
            }
        }
        return frame
    }
}


extension MissingElementsRestorer {
    convenience init(existenceChecker: LetterExistenceChecker) {
        let finder = MissingElementsFinder(existenceChecker: existenceChecker)
        self.init(finder: finder)
    }
}




