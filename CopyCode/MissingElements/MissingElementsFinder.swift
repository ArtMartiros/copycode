//
//  MissingElementsFinder.swift
//  CopyCode
//
//  Created by Артем on 27/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

///Ищет потерянные линии и буквы
class MissingElementsFinder {
    ///Количество символов подряд с пустотой, необходимой для прекращения поиска
    private let kInRawTimes = 5
    private let kNewLineSymbols = 5
    private let letterPixelFinder: LetterPixelFinder

    init(pixelFinder: LetterPixelFinder) {
        self.letterPixelFinder = pixelFinder
    }
    
    func findMissingLine(in gapFrame: CGRect, grid: TypographicalGrid) -> [Line<LetterRectangle>] {
        let tracking = grid.trackingData[gapFrame.topY]
        let frames = grid.leading.missingLinesFrame(in: gapFrame)
        let lines = frames.compactMap { findMissingLine(in: $0, tracking: tracking) }
        return lines
    }
    
    func findMissingWord(in frame: CGRect, tracking: Tracking, with edge: CGRectEdge) -> SimpleWord? {
        let pixelFrame = PixelConverter.shared.toPixel(from: frame)
        let tracking = TrackingPixelConverter.toPixel(from: tracking)
        let letters = getLetters(pixelFrame: pixelFrame, tracking: tracking, with: edge)
        guard !letters.isEmpty else { return nil }
        let word = Word.from(letters.sortedFromLeftToRight(), type: .same(type: .allCustom))
        return word
    }
    
    private func findMissingLine(in rect: CGRect,  tracking: Tracking) -> Line<LetterRectangle>? {
        let divided = rect.divided(atDistance: tracking.width * CGFloat(kNewLineSymbols), from: .minXEdge)
        guard let word = findMissingWord(in: divided.slice, tracking: tracking, with: .minXEdge) else { return nil }
        return Line(words: [word])
    }
    
    private func getLetters(pixelFrame: CGRect, tracking: Tracking, with edge: CGRectEdge) -> [LetterRectangle] {
        var letters: [LetterRectangle]  = []
        var inRaw = 0
        let dividedFrames = tracking.missingCharFrames(in: pixelFrame)
        let rightOrderFrames = edge == .minXEdge ? dividedFrames : dividedFrames.reversed()
        for frame in rightOrderFrames {
            guard inRaw < kInRawTimes else { break }
            if letterPixelFinder.find(in: frame, with: edge ) {
                letters.append(createLetter(from: frame))
                inRaw = 0
            } else {
                inRaw += 1
            }
        }
        return letters
    }
    
    private func createLetter(from pixelFrame: CGRect) -> LetterRectangle {
        let frame = PixelConverter.shared.toFrame(from: pixelFrame)
        let letter = LetterRectangle(frame: frame, pixelFrame: pixelFrame, type: .custom)
        return letter
    }

}



