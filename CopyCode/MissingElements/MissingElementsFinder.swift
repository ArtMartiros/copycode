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
    private let lineDetection = LineDetection()
    private let letterPixelFinder: LetterPixelFinder
    private let pixelBoundsRestorer: PixelBoundsRestorable
    private let existenceChecker: LetterExistenceChecker
    init(letterPixelFinder: LetterPixelFinder, boundsRestorer: PixelBoundsRestorable, checker: LetterExistenceChecker) {
        self.letterPixelFinder = letterPixelFinder
        self.pixelBoundsRestorer = boundsRestorer
        self.existenceChecker = checker
    }
    
    func findMissingLine(in rect: CGRect, lineHeight: CGFloat,  tracking: Tracking) -> [Line<LetterRectangle>] {
        let frames = lineDetection.getLines(from: rect, lineHeight: lineHeight)
        let lines = frames.compactMap { findMissingLine(in: $0, tracking: tracking) }
        return lines
    }
    
    private func findMissingLine(in rect: CGRect,  tracking: Tracking) -> Line<LetterRectangle>? {
        let divided = rect.divided(atDistance: tracking.width * CGFloat(kNewLineSymbols), from: .minXEdge)
        let letters = findMissingLetters(in: divided.slice, tracking: tracking, with: .minXEdge)
        return createLine(from: letters)
    }

    func findMissingLetters(in frame: CGRect, tracking: Tracking, with edge: CGRectEdge) -> [LetterRectangle] {
        let pixelFrame = PixelConverter.shared.toPixel(from: frame)
        let tracking = TrackingPixelConverter.toPixel(from: tracking)
        let letters = getLetters(pixelFrame: pixelFrame, tracking: tracking, with: edge)
        return letters
    }
    
    private func getLetters(pixelFrame: CGRect, tracking: Tracking, with edge: CGRectEdge) -> [LetterRectangle] {
        var letters: [LetterRectangle]  = []
        var inRaw = 0
        let dividedFrames = arrayOfFrames(from: pixelFrame, by: tracking)
        let rightOrderFrames = edge == .minXEdge ? dividedFrames : dividedFrames.reversed()
        for frame in rightOrderFrames {
            guard inRaw < kInRawTimes else { break }
            let result = letterPixelFinder.find(in: frame, with: edge )
            switch result {
            case .empty: inRaw += 1
            case .value:
                letters.append(createLetter(from: frame))
                inRaw = 0
            }
        }
        return letters
    }
    
    private let kErrorTrackingWidthPercent: UInt = 10
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
        let letter = LetterRectangle(frame: frame, pixelFrame: pixelFrame)
        return letter
    }
    
    private func createLine(from letters: [LetterRectangle]) -> Line<LetterRectangle>? {
        guard !letters.isEmpty else { return nil }
        let word = Word.from(letters)
        return Line(words: [word])
    }
}

extension MissingElementsFinder {
    convenience init(existenceChecker: LetterExistenceChecker) {
        let pixelFinder = LetterPixelFinder(checker: existenceChecker)
        let boundsRestorer = LetterBoundsRestorer(checker: existenceChecker)
        self.init(letterPixelFinder: pixelFinder, boundsRestorer: boundsRestorer, checker: existenceChecker)
    }
}


