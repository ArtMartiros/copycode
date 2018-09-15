//
//  MissingElementsRestorer.swift
//  CopyCode
//
//  Created by Артем on 23/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

///Восстанавилвает потерянные линии, буквы
class MissingElementsRestorer {
    enum HorizontalDirection {
        case left
        case right
        
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
    func restore(_ block: Block<LetterRectangle>) -> Block<LetterRectangle> {
        guard let trackingData = block.trackingData, let leading = block.leading else { return block }

        var restoredLines = block.lines
            .compactMap { restoreWords(in: $0, tracking: trackingData[$0.frame.topY], blockBounds: block) }
        
        let newLines = block.gaps
            .compactMap { finder.findMissingLine(in: $0.frame, leading: leading, tracking: trackingData[$0.frame.topY]) }
            .reduce([Line<LetterRectangle>]()) { $0 + $1 }

        restoredLines.append(contentsOf: newLines)
        return Block.from(restoredLines.sortedFromTopToBottom, column: block.column, trackingData: trackingData, leading: leading)
    }
   
    ///восстанавливает потерянные буквы для слов внутри линии
    func restoreWords(in line: Line<LetterRectangle>, tracking: Tracking,
                      blockBounds: StandartRectangle) -> Line<LetterRectangle>? {
        var newWords: [Word<LetterRectangle>] = line.words
        // между началом блока и началом линии
        if let word = findWord(betweenLine: line, tracking: tracking, andBlock: blockBounds, direction: .left) {
            newWords.append(word)
        }
        
        // внутри линии
        line.gaps.forEach {
            if let word = findWord(inside: $0.frame, tracking: tracking, with: .minXEdge) {
                newWords.append(word)
            }
        }
        
        // между концом линии и концом блока
        if let word = findWord(betweenLine: line, tracking: tracking, andBlock: blockBounds,
                               direction: .right) {
            newWords.append(word)
        }
        
        guard !newWords.isEmpty else { return nil }
        return Line(words: newWords.sortedFromLeftToRight)
    }
    
    private func findWord(inside frame: CGRect, tracking: Tracking, with edge: CGRectEdge) -> Word<LetterRectangle>? {
        let letters = finder.findMissingLetters(in: frame, tracking: tracking, with: edge)
        guard !letters.isEmpty else { return nil }
        let word = (Word.from(letters.sortedFromLeftToRight))
        return word
    }
    
    private func findWord(betweenLine line: StandartRectangle,
                          tracking: Tracking,
                          andBlock block: StandartRectangle, direction: HorizontalDirection) -> Word<LetterRectangle>? {
        let frame = createFrame(betweenLine: line, andBlock: block, direction: direction)
        guard frame.width != 0 else { return nil}
        return findWord(inside: frame, tracking: tracking, with: direction.edge)
    }

    private func createFrame(betweenLine line: StandartRectangle, andBlock block: StandartRectangle,
                             direction: HorizontalDirection) -> CGRect {
        let leftX: CGFloat
        let rightX: CGFloat
        
        switch direction {
        case .left:
            leftX = block.frame.leftX
            rightX = line.frame.leftX
        case .right:
            leftX = line.frame.rightX
            rightX = block.frame.rightX
        }
        
        let frame = CGRect(left: leftX, right: rightX, top: line.frame.topY, bottom: line.frame.bottomY)
        return frame
    }
    
    
}


extension MissingElementsRestorer {
    convenience init(bitmap: NSBitmapImageRep) {
        let colorPicker = ColorPicker(bitmap)
        let pixelFinder = LetterPixelFinder(colorPicker: colorPicker)
        let finder = MissingElementsFinder(pixelFinder: pixelFinder)
        self.init(finder: finder)
    }
}




