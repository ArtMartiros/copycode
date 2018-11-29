//
//  Word.swift
//  CopyCode
//
//  Created by Артем on 02/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct Word<Child: Rectangle>: Container, Gapable {

    var gaps: [Gap] {
        let frames = letters.map { $0.frame }
        return getGaps(from: frames, wordFrame: frame)
    }

    let frame: CGRect
    let letters: [Child]
    let type: WordType

    init(frame: CGRect, type: WordType = .undefined, letters: [Child]) {
        self.frame = frame
        self.letters = letters
        self.type = type
    }

    static func from(_ letters: [Child], type: WordType = .undefined) -> Word<Child> {
        let frame = letters.map { $0.frame }.compoundFrame
        return Word(frame: frame, type: type, letters: letters)
    }
}

extension Word {
    func updated(by rate: Int) -> Word<Child> {
        let frame = updatedFrame(by: rate)
        return Word<Child>(frame: frame, type: type, letters: letters.map { $0.updated(by: rate) })
    }
}

extension Word where Child == Letter {
    var value: String { return letters.map { $0.value }.joined() }
}

extension Word {
    init(rect: Rectangle, type: WordType, letters: [Child]) {
        self.init(frame: rect.frame, type: type, letters: letters)
    }
}

extension Word {

    private var kQuotesRatio: CGFloat { return 2 }
    ///бывает такое что кавычки показаны как разные буквы, убираем гапы между кавычками
    func correctedGaps() -> [CGRect] {
        var newGaps = gaps
        var alreadyRemovedCount = 0
        letters.forEachPairWithIndex { (left, right, index) in
            let completeWidthBetweenTwoLetter = right.frame.rightX - left.frame.leftX
            let isQuotes = frame.height / completeWidthBetweenTwoLetter >= kQuotesRatio
            if isQuotes {
                newGaps.remove(at: index - alreadyRemovedCount)
                alreadyRemovedCount += 1
            }
        }
        return newGaps.map { $0.frame }
    }

    func fixedGapsWthCutedOutside(letterWidth: CGFloat) -> [CGRect]? {
        return Gap.updatedOutside(corrrectedGapsWithOutside(), with: letterWidth)
    }

    /// Gapы с внешними гапами, так как ширина их неизвестна, то ставим равной высоте
    /// Просто, чтоб чему-то было равно
    func corrrectedGapsWithOutside() -> [CGRect] {
        var fixedGaps = self.correctedGaps()
        let width = frame.height
        let firstLetter = letters[0]
        let leftFrame = CGRect(left: firstLetter.frame.leftX - width, right: firstLetter.frame.leftX,
                               top: frame.topY, bottom: frame.bottomY)
        let lastLetterFrame = letters.last ?? firstLetter
        let rightFrame = CGRect(left: lastLetterFrame.frame.rightX, right: lastLetterFrame.frame.rightX + width,
                                top: frame.topY, bottom: frame.bottomY)

        fixedGaps.insert(leftFrame, at: 0)
        fixedGaps.append(rightFrame)
        return fixedGaps
    }

}

extension Word {
    private func getGaps(from frames: [CGRect], wordFrame: CGRect) -> [Gap] {
        var gaps: [Gap] = []
        frames.forEachPair {
            let gapFrame: CGRect
            if $0.rightX > $1.leftX {
                let width = $0.rightX - $1.leftX
                let position = $1.leftX + width / 2
                gapFrame = CGRect(x: position, y: wordFrame.bottomY, width: 0, height: frame.height)
            } else {
                gapFrame = CGRect(left: $0.rightX, right: $1.leftX,
                                  top: wordFrame.topY, bottom: wordFrame.bottomY)
            }
            gaps.append(Gap(frame: gapFrame))
        }
        return gaps
    }
}

extension Word {
    ///проверка слово кавычка
    func isQuoteWord(trackingWidth: CGFloat) -> Bool {
        let quoute = isQuoteWord() && frame.width < trackingWidth
        return quoute
    }

    func isQuoteWord() -> Bool {
        let quoute = (0.75...1.2).contains(frame.ratio) && letters.count <= 2
        return quoute
    }
}

extension Word {
    func removeLetter(at index: Int) -> Word<Child> {
        var newLetters = letters
        newLetters.remove(at: index)
        return Word.from(newLetters, type: type)
    }
}
