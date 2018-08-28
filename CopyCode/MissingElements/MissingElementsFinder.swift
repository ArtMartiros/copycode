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
    ///коэфициент с помощью которого, мы по высоте определяем приблизительную длину символов
    private let kHeightWidthRatio: CGFloat = 1.3
    ///Количество символов подряд с пустотой, необходимой для прекращения поиска
    private let kInRawTimes = 3
    
    let letterPixelFinder: LetterPixelFinder
    let pixelBoundsRestorer: PixelBoundsRestorable
    private let checker: LetterExistenceChecker
    init(letterPixelFinder: LetterPixelFinder, boundsRestorer: PixelBoundsRestorable, checker: LetterExistenceChecker) {
        self.letterPixelFinder = letterPixelFinder
        self.pixelBoundsRestorer = boundsRestorer
        self.checker = checker
    }
    
    func findMissingLine(in rect: CGRect) -> Line<LetterRectangle>? {
        let width = singleLetterWidth(from: rect)
        let divided = rect.divided(atDistance: width, from: .minXEdge)
        let frame = divided.slice
        let letters = findMissingLetters(in: frame, with: .minXEdge)
        guard !letters.isEmpty else { return nil }
        let word = Word.from(letters)
        return Line(words: [word])
    }
    
    func findMissingLetters(in frame: CGRect, with edge: CGRectEdge) -> [LetterRectangle] {
        let pixelFrame = PixelConverter.shared.toPixel(from: frame)
        var correctPixelFrame = getCorrectPixelFrame(in: pixelFrame, with: edge)
        let letterWidth = singleLetterWidth(from: pixelFrame)

        var letters: [LetterRectangle]  = []
        var inRaw = 0
        //прерывание происходит в двух случаях:
        //либо frame закончился
        //либо kInRawTimes буквы подряд пустота
        while inRaw < kInRawTimes || correctPixelFrame.width > 0 {
            let defaultLetterFrame = getDefaultLetterFrame(from: correctPixelFrame, letterWidth: letterWidth, and: edge)
            if let point = letterPixelFinder.find(in: defaultLetterFrame, with: edge ) {
                let restoredLetterFrame = pixelBoundsRestorer.restore(atPoint: point)
                correctPixelFrame = removedLastLetter(from: correctPixelFrame, letterFrame: restoredLetterFrame, and: edge)
                letters.append(getLetter(from: restoredLetterFrame))
                inRaw = 0
            } else {
                correctPixelFrame = removedLastLetter(from: correctPixelFrame, letterFrame: defaultLetterFrame, and: edge)
                inRaw += 1
            }
        }

        return letters
    }
    
    private func getLetter(from pixelFrame: CGRect) -> LetterRectangle {
        let frame = PixelConverter.shared.toFrame(from: pixelFrame)
        let letter = LetterRectangle(frame: frame, pixelFrame: pixelFrame)
        return letter
    }
    
    ///может быть такое что в frame есть часть старой буквы, что приведет к некорректному вычислению
    ///поэтому нужно скорректировать frame, обрезав его, если это нужно
    private func getCorrectPixelFrame(in frame: CGRect, with edge: CGRectEdge) -> CGRect {
        let yArray: [CGFloat] = [0.1, 0.5, 0.9]
        for y in yArray {
            let x = CGFloat(edge.rawValue)
            let point = CGPoint(x: frame.xAs(rate: x), y: frame.yAs(rate: y))
            if checker.exist(at: point) {
                let divided = frame.divided(atDistance: 2, from: edge)
                return getCorrectPixelFrame(in: divided.remainder, with: edge)
            }
        }
        return frame
    }
    
    private func removedLastLetter(from frame: CGRect, letterFrame: CGRect, and edge: CGRectEdge) -> CGRect {
        let divided = frame.divided(atDistance: letterFrame.width, from: edge)
        return divided.remainder
    }
    
    private func getDefaultLetterFrame(from frame: CGRect, letterWidth: CGFloat, and edge: CGRectEdge) -> CGRect {
        let divided = frame.divided(atDistance: letterWidth, from: edge)
        return divided.slice
    }
    
    private func singleLetterWidth(from rect: CGRect) -> CGFloat {
        return rect.height / kHeightWidthRatio
    }
}
