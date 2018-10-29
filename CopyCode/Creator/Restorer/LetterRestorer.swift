//
//  LetterRestorer.swift
//  CopyCode
//
//  Created by Артем on 04/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

///слепляет кавычки в одну
///разъединяет слипшиеся буквы
///находит буквы которые были пропущены
final class LetterRestorer {
    private let missingElementsRestorer: MissingElementsRestorer
    private let stuckRestorer: StuckRestorer
    private let unstuckRestorer: UnstuckRestorer

    func restore(_ block: SimpleBlock) -> SimpleBlock {
        guard case .grid(let grid) = block.typography else { return block }
        let lines = block.lines.map { restore($0, grid: grid)}

        let firstUpdate = Block(lines: lines, frame: block.frame, column: block.column, typography: block.typography)
        guard Settings.includeMissingChars else { return firstUpdate }

        let blockWithMissingElements = missingElementsRestorer.restore(firstUpdate)
        return blockWithMissingElements
    }

    func restore(_ line: SimpleLine, grid: TypographicalGrid) -> SimpleLine {
        let words = line.words.map { restore($0, grid: grid) }
        let newLine = Line(words: words)
        return newLine
    }

    func restore(_ word: SimpleWord, grid: TypographicalGrid) -> SimpleWord {
        let tracking = grid.trackingData[word]
        var newWord = stuckRestorer.stuck(from: word, tracking: tracking)
        newWord = unstuckRestorer.unstuck(from: newWord, tracking: tracking)
        return newWord
    }

    init(bitmap: NSBitmapImageRep) {
        self.missingElementsRestorer = MissingElementsRestorer(bitmap: bitmap)
        self.stuckRestorer = StuckRestorer()
        self.unstuckRestorer = UnstuckRestorer()
    }
}
