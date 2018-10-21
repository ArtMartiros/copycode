//
//  MissingElementsRestorer.swift
//  CopyCode
//
//  Created by Артем on 23/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

enum ElementSearchDirection {
    case fromLeftToRight
    case fromRightToLeft
}
///Восстанавилвает потерянные линии, буквы
final class MissingElementsRestorer {
    let finder: MissingElementsFinder
    let correlator = GridLineCorrelator()
    init(finder: MissingElementsFinder) {
        self.finder = finder
    }
    @IBOutlet weak var sendScreenButton: NSButton!

    ///восстанавливает потерянные линии внутри блока
    func restore(_ block: Block<LetterRectangle>) -> Block<LetterRectangle> {

        guard case .grid(let grid) = block.typography else { return block }
        let arrayOfFrames = grid.getArrayOfFrames(from: block.frame)
        let lines = block.lines
        let correlations = correlator.correlate(lines: lines, arrayOfFrames: arrayOfFrames)
        var updatedLines: [SimpleLine] = []
        for (key, value) in correlations {
            if let lineIndex = value {
                let line = restoreWords(in: lines[lineIndex], lineFrames: arrayOfFrames[key])
                updatedLines.append(line)
            } else {
                guard let word = finder.findMissingWord(in: arrayOfFrames[key], with: .fromLeftToRight)
                    else { continue }
                updatedLines.append(Line(words: [word]))
            }
        }
        return Block.from(updatedLines, column: block.column, typography: block.typography)
    }

    func restoreWords(in line: Line<LetterRectangle>, lineFrames: [CGRect]) -> Line<LetterRectangle> {
        var words = line.words
        let letters = words.map { $0.letters }.reduce([], +)

        let correlation = correlator.correlate(letters, frames: lineFrames)

        let chunked = correlation.chunkForSorted {
            ($0.lineIndex == nil) == ($1.lineIndex == nil)
        }

        var newWords: [SimpleWord] = []
        for (index, chunk) in chunked.enumerated() where !chunk.isEmpty {
            guard chunk.first?.lineIndex == nil else { continue }

            let direction: ElementSearchDirection = index == 0 ? .fromRightToLeft : .fromLeftToRight
            let letterFrames = chunk.map { lineFrames[$0.gridIndex] }
            guard let word = finder.findMissingWord(in: letterFrames, with: direction) else { continue }
            ///если буква была внутри слова
            if let updatedExistenceWords = stuckWithExistedWord(words: words, newWord: word) {
                words = updatedExistenceWords
            } else {
                newWords.append(word)
            }

        }

        guard !newWords.isEmpty else { return line }

        newWords.append(contentsOf: words)
        return Line(words: newWords.sortedFromLeftToRight())
    }

    func stuckWithExistedWord(words: [SimpleWord], newWord: SimpleWord) -> [SimpleWord]? {
        var updatedWords: [SimpleWord] = []
        var updated = false
        for word in words {
            if !updated, newWord.inside(in: word) {
               let letters = word.letters + newWord.letters
               let updatedWord = Word.from(letters.sortedFromLeftToRight(), type: word.type)
                updatedWords.append(updatedWord)
                updated = true
            } else {
                updatedWords.append(word)
            }
        }
        return updated ? updatedWords : nil
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
