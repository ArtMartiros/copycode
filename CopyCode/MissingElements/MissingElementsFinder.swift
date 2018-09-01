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

    ///Минимальная широта фрейма в котором ищем букву
    private let kMinimumPixelWidth: CGFloat = 6
    
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
    
    func findMissingLine(in rect: CGRect, lineHeight: CGFloat, letterWidth: CGFloat) -> [Line<LetterRectangle>] {
        let frames = lineDetection.getLines(from: rect, lineHeight: lineHeight)
        let lines = frames.compactMap { findMissingLine(in: $0, letterWidth: letterWidth) }
        return lines
    }
    
    private func findMissingLine(in rect: CGRect, letterWidth: CGFloat) -> Line<LetterRectangle>? {
        let divided = rect.divided(atDistance: letterWidth * CGFloat(kNewLineSymbols), from: .minXEdge)
        let letters = findMissingLetters(in: divided.slice, letterWidth: letterWidth, with: .minXEdge)
        return createLine(from: letters)
    }

    func findMissingLetters(in frame: CGRect, letterWidth: CGFloat, with edge: CGRectEdge) -> [LetterRectangle] {
        let pixelFrame = PixelConverter.shared.toPixel(from: frame)
        let letterWidth = PixelConverter.shared.toPixel(from: letterWidth)
        let correctPixelFrame = cleanFrameFromKnownLetter(in: pixelFrame, with: [.minXEdge, .maxXEdge])
        let letters = getLetters(pixelFrame: correctPixelFrame, letterWidth: letterWidth, with: edge)
        return letters
    }
    
    private func getLetters(pixelFrame: CGRect, letterWidth: CGFloat, with edge: CGRectEdge) -> [LetterRectangle] {
        var correctPixelFrame = pixelFrame
        var letters: [LetterRectangle]  = []
        var inRaw = 0
        //прерывание происходит в двух случаях:
        //либо frame закончился
        //либо kInRawTimes буквы подряд пустота
        while inRaw < kInRawTimes && correctPixelFrame.width > kMinimumPixelWidth {
            
            let defaultLetterFrame = getDefaultLetterFrame(from: correctPixelFrame, letterWidth: letterWidth, and: edge)
            let result = letterPixelFinder.find(in: defaultLetterFrame, with: edge )
            switch result {
            case .empty:
                correctPixelFrame = removedLastLetter(from: correctPixelFrame, letterFrame: defaultLetterFrame, and: edge)
                inRaw += 1
            case .value(let dictionary):
//                let restoredLetterFrame = pixelBoundsRestorer.restore(at: dictionary, in: defaultLetterFrame)
                correctPixelFrame = removedLastLetter(from: correctPixelFrame, letterFrame: defaultLetterFrame, and: edge)
                let letter = createLetter(from: defaultLetterFrame)
                letters.append(letter)
                inRaw = 0
//                inRaw = restoredLetterFrame.width == 0 ? kInRawTimes : 0
            }
        }
        return letters
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
    
    ///может быть такое что в frame есть часть старой буквы, что приведет к некорректному вычислению
    ///поэтому нужно скорректировать frame, обрезав его, если это нужно
    private func cleanFrameFromKnownLetter(in frame: CGRect, with edges: [CGRectEdge]) -> CGRect {
        let yArray: [CGFloat] = [0, 0.2, 0.4, 0.6, 0.8, 1]//[0.2, 0.5, 0.8]//[0, 0.2, 0.4, 0.6, 0.8, 1]
        var newFrame = frame
        for edge in edges {
            while newFrame.width != 0 {
                guard exist(in: newFrame, array: yArray, with: edge) else { break }
                newFrame = newFrame.divided(atDistance: 1, from: edge).remainder
            }
        }
        return newFrame
    }
    
    private func exist(in frame: CGRect, array: [CGFloat], with edge: CGRectEdge) -> Bool {
        let isExist = array.first {
            let point = CGPoint(x: frame.xAs(rate: CGFloat(edge.rate)), y: frame.yAs(rate: $0))
            let exist = existenceChecker.exist(at: point)
            return exist
            } != nil
        return isExist
    }
    
    private func removedLastLetter(from frame: CGRect, letterFrame: CGRect, and edge: CGRectEdge) -> CGRect {
        let divided = frame.divided(atDistance: letterFrame.width, from: edge)
        return divided.remainder
    }
    
    private func getDefaultLetterFrame(from frame: CGRect, letterWidth: CGFloat, and edge: CGRectEdge) -> CGRect {
        let divided = frame.divided(atDistance: letterWidth, from: edge)
        return divided.slice
    }
}

extension MissingElementsFinder {
    convenience init(existenceChecker: LetterExistenceChecker) {
        let pixelFinder = LetterPixelFinder(checker: existenceChecker)
        let boundsRestorer = LetterBoundsRestorer(checker: existenceChecker)
        self.init(letterPixelFinder: pixelFinder, boundsRestorer: boundsRestorer, checker: existenceChecker)
    }
}
