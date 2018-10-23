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
        return Word(frame: word.frame, letters: letters)
    }

    func unstuckLetter(from letter: LetterRectangle, tracking: Tracking) -> [LetterRectangle] {
        let frames = split(frame: letter.frame, tracking: tracking)

        guard frames.count > 1 else { return [letter] }
        let letters = frames.map { LetterRectangle(frame: $0, type: letter.type) }
        return  letters
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
