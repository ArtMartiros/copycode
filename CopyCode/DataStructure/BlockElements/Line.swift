//
//  Line.swift
//  CopyCode
//
//  Created by Артем on 02/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct Line<WordChild: Rectangle>: Rectangle, Layerable, Gapable {
    typealias WordAlias = Word<WordChild>
    let words: [WordAlias]

    var gaps: [Gap] {
        var gaps: [Gap] = []
        words.forEachPair {
            let gapFrame = CGRect(left: $0.frame.rightX, right: $1.frame.leftX,
                                  top: frame.topY, bottom: frame.bottomY)
            gaps.append(Gap(frame: gapFrame))
        }
        return gaps
    }

    func biggestWord() -> WordAlias {
        let word = words.sorted { $0.frame.width > $1.frame.width }[0]
        return word
    }

    func gapsFramesFromBiggestWord() -> [CGRect] {
        let gaps = biggestWord().gaps.map { $0.frame }
        return gaps
    }

    var frame: CGRect { return words.map { $0.frame }.compoundFrame }

    init(words: [WordAlias]) {
        self.words = words
    }

    func updated(by rate: Int) -> Line<WordChild> {
        let newWords = words.map { $0.updated(by: rate)}
        return Line<WordChild>(words: newWords)
    }
}

extension Line {
    var anomalyElementIndex: LetterInLinePosition? {
        let lineHeight = frame.height
        let words = self.words.enumerated().notReversed()
            .sorted { $0.element.frame.height > $1.element.frame.height }

        guard let (wordIndex, word) = words.first else { return nil }

        let filteredLetters = word.letters
            .enumerated().notReversed()
            .filter { lineHeight == $0.element.frame.height }

        guard filteredLetters.count == 1  else { return nil }
        let letter = filteredLetters[0]
        if letter.element.frame.ratio > 7 {
            return LetterInLinePosition(wordIndex: wordIndex, letterIndex: letter.offset)
        }

        return nil
    }

    func newLineWithoutAnomaly() -> Line<WordChild> {
        guard let forbidden = anomalyElementIndex else {
            return self
        }
        return removeLetter(at: forbidden)
    }

    func removeLetter(at position: LetterInLinePositionProtocol) -> Line<WordChild> {
        var newWords: [Word<WordChild>] = []
        for (index, word) in words.enumerated() {
            if position.wordIndex == index {
                let updatedWord = word.removeLetter(at: position.letterIndex)
                newWords.append(updatedWord)
            } else {
                newWords.append(word)
            }
        }
        return Line<WordChild>(words: newWords)
    }
}
