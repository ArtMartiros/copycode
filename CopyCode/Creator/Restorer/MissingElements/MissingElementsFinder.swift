//
//  MissingElementsFinder.swift
//  CopyCode
//
//  Created by Артем on 27/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

///Ищет потерянные линии и буквы
final class MissingElementsFinder {
    ///Количество символов подряд с пустотой, необходимой для прекращения поиска
    private let kInRawTimes = 5
    private let letterPixelFinder: LetterPixelFinder

    init(pixelFinder: LetterPixelFinder) {
        self.letterPixelFinder = pixelFinder
    }
    func findMissingWord(in frames: [CGRect], with edge: ElementSearchDirection) -> SimpleWord? {
        let orderedFrames = edge == .fromLeftToRight ? frames : frames.reversed()
        var inRaw = 0
        var letters: [LetterRectangle] = []
        for frame in orderedFrames where inRaw < kInRawTimes {
            guard let letter = findLetter(in: frame) else {
                inRaw += 1
                continue
            }
            letters.append(letter)
            inRaw = 0
        }
        guard !letters.isEmpty else { return nil }

        let orderedLetters = edge == .fromLeftToRight ? letters : letters.reversed()
        let word = Word.from(orderedLetters, type: .same(type: .allCustom))
        return word
    }

    func findLetter(in frame: CGRect) -> LetterRectangle? {
        let pixelFrame = PixelConverter.shared.toPixel(from: frame)
        guard letterPixelFinder.find(in: pixelFrame) else { return nil }
        return LetterRectangle(frame: frame, pixelFrame: pixelFrame, type: .custom)
    }

}
