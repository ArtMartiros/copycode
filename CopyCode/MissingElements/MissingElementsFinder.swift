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
    
    func findMissingLine(in gapFrame: CGRect, leading: Leading,  tracking: Tracking) -> [Line<LetterRectangle>] {
        let frames = leading.findMissingLineFrames(in: gapFrame)
        let lines = frames.compactMap { findMissingLine(in: $0, tracking: tracking) }
        return lines
    }
    
    func findMissingLetters(in frame: CGRect, tracking: Tracking, with edge: CGRectEdge) -> [LetterRectangle] {
        let pixelFrame = PixelConverter.shared.toPixel(from: frame)
        let tracking = TrackingPixelConverter.toPixel(from: tracking)
        let letters = getLetters(pixelFrame: pixelFrame, tracking: tracking, with: edge)
        return letters
    }
    
    private func findMissingLine(in rect: CGRect,  tracking: Tracking) -> Line<LetterRectangle>? {
        let divided = rect.divided(atDistance: tracking.width * CGFloat(kNewLineSymbols), from: .minXEdge)
        let letters = findMissingLetters(in: divided.slice, tracking: tracking, with: .minXEdge)
        return createLine(from: letters)
    }
    
    private func getLetters(pixelFrame: CGRect, tracking: Tracking, with edge: CGRectEdge) -> [LetterRectangle] {
        var letters: [LetterRectangle]  = []
        var inRaw = 0
        let dividedFrames = arrayOfFrames(from: pixelFrame, by: tracking)
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
    
    private let kErrorTrackingWidthPercent: CGFloat = 10
    //разбивает frame с помощью tracking
    private func arrayOfFrames(from frame: CGRect, by tracking: Tracking) -> [CGRect] {
        let updatedFrame = updateFrame(from: frame, tracking: tracking)
        var frames = updatedFrame.chunkToSmallRects(byWidth: tracking.width)
        guard let last = frames.last else { return [] }
        if !EqualityChecker.check(of: tracking.width, with: last.width, errorPercentRate: kErrorTrackingWidthPercent) {
            let _ = frames.removeLast()
        }
        return frames
    }
    
    //нужен обновленный фрейм исходя из стартовой позиции tracking иногда надо немного расщирить иногда сузить
    private func updateFrame(from frame: CGRect, tracking: Tracking) -> CGRect {
        let nearestPoint = tracking.nearestPoint(to: frame)
        var newFrame: CGRect?
        var difference = nearestPoint - frame.leftX
        
        if nearestPoint < frame.leftX {
            difference += tracking.width
            if EqualityChecker.check(of: difference, with: tracking.width, errorPercentRate: kErrorTrackingWidthPercent) {
                newFrame = CGRect(left: nearestPoint, right: frame.rightX, top: frame.topY, bottom: frame.bottomY)
            }
        }
        return newFrame ?? frame.divided(atDistance: difference, from: .minXEdge).remainder
    }
    
    private func createLetter(from pixelFrame: CGRect) -> LetterRectangle {
        let frame = PixelConverter.shared.toFrame(from: pixelFrame)
        let letter = LetterRectangle(frame: frame, pixelFrame: pixelFrame, type: .custom)
        return letter
    }
    
    private func createLine(from letters: [LetterRectangle]) -> Line<LetterRectangle>? {
        guard !letters.isEmpty else { return nil }
        let word = Word.from(letters, type: .same(type: .allCustom))
        return Line(words: [word])
    }
}



