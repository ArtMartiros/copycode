//
//  StuckRestorer.swift
//  CopyCode
//
//  Created by Артем on 19/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

final class StuckRestorer {
    func stuck(from word: SimpleWord, tracking: Tracking) -> SimpleWord {
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

        guard lastChagedIndex != nil else { return word }

        let newWord = Word(frame: word.frame, pixelFrame: word.pixelFrame, type: .mix, letters: letters)
        return newWord
    }

    private func getNewLetter(current: LetterRectangle, next: LetterRectangle) -> LetterRectangle {
        let frame = getNewFrame(current: current.frame, next: next.frame)
        let pixelFrame = getNewFrame(current: current.pixelFrame, next: next.pixelFrame)
        return LetterRectangle(frame: frame, pixelFrame: pixelFrame, type: .doubleQuote)
    }

    private func getNewFrame(current: CGRect, next: CGRect) -> CGRect {
        let top = max(current.topY, next.topY)
        let bottom = min(current.bottomY, next.bottomY)
        let frame = CGRect(left: current.leftX, right: next.rightX, top: top, bottom: bottom)
        return frame
    }
}
