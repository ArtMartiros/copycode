//
//  UnstuckRestorer.swift
//  CopyCode
//
//  Created by Артем on 19/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

final class UnstuckRestorer {
    func unstuck(from word: SimpleWord, tracking: Tracking) -> SimpleWord {
        let letters = word.letters.map { unstuckLetter(from: $0, tracking: tracking) }.reduce([], +)
        return Word(frame: word.frame, pixelFrame: word.pixelFrame, letters: letters)
    }

    func unstuckLetter(from letter: LetterRectangle, tracking: Tracking) -> [LetterRectangle] {
        let frames = split(frame: letter.frame, tracking: tracking)

        guard frames.count > 1 else { return [letter] }
        var usedPercent: CGFloat = 0
        var newLetters: [LetterRectangle] = []

        for frame in frames {
            let percent = frame.width / letter.frame.width * 100
            let (pixelFrame, _ ) = letter.pixelFrame.divided(byPercent: percent, afterPercent: usedPercent)
            let newLetter = LetterRectangle(frame: frame, pixelFrame: pixelFrame, type: letter.type)
            newLetters.append(newLetter)
            usedPercent += percent
        }

        return  newLetters
    }

    private func split(frame: CGRect, tracking: Tracking) -> [CGRect] {
        let shouldContinue = true
        var frames: [CGRect] = []

        var currentFrame = frame

        while shouldContinue {
            if currentFrame.width > tracking.width + tracking.width * 0.1 {
                var point = tracking.nearestPointToLeftX(from: currentFrame)

                let shouldAdd = currentFrame.leftX >= point
                point += shouldAdd ? tracking.width : 0
                let (left, right) = currentFrame.divided(atXPoint: point)

                frames.append(left)
                currentFrame = right
            } else {
                frames.append(currentFrame)
                return frames
            }
        }
    }
}
