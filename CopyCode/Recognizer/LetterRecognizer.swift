//
//  LetterRecognizer.swift
//  CopyCode
//
//  Created by Артем on 18/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

struct LetterRecognizer {

    private let bitmap: NSBitmapImageRep
    private let wordBackgroundWhiteColor: CGFloat
    private let letterColorFinder: LetterWhiteColorProtocol
    private let wordFactor: WordFactor
    init(in bitmap: NSBitmapImageRep,
         wordBackgroundWhiteColor: CGFloat,
         letterColorFinder: LetterWhiteColorProtocol,
         wordFactor: WordFactor) {
        self.bitmap = bitmap
        self.wordBackgroundWhiteColor = wordBackgroundWhiteColor
        self.letterColorFinder = letterColorFinder
        self.wordFactor = wordFactor
    }

    func recognize(from frame: CGRect, with type: LetterType) -> String {
        let wordFactor = WordFactor(frame: frame)
        let newFrame = wordFactor.frameCrop()
        let checker = letterExistenceChecker(from: newFrame)
        return type.treeOCR.find(checker, with: newFrame) ?? "*"
    }

    /// Метод нужен когда необходимо использовать кастомное древо
    func recognize(from frame: CGRect, with treeOCR: TreeOCR) -> String {
         let wordFactor = WordFactor(frame: frame)
 let newFrame = wordFactor.frameCrop()
        let checker = letterExistenceChecker(from: newFrame)
        return treeOCR.find(checker, with: newFrame) ?? "*"
    }

    func recognize(from letter: LetterRectangle) -> String {
        print("Letter pf frame \(letter.frame) type: \(letter.type)")
        return recognize(from: letter.frame, with: letter.type)
    }

    private func letterExistenceChecker(from frame: CGRect) -> LetterExistenceChecker {
        let wordFactor2 = WordFactor(frame: frame)
        let newFrame = wordFactor2.frameCrop()
        let letterDefaultColor = letterColorFinder.findedLetterColor(newFrame, with: wordBackgroundWhiteColor)
        let pixelChecker = LetterPixelChecker(backgroundWhite: wordBackgroundWhiteColor,
                                              letterDefaultWhite: letterDefaultColor,
                                              whitePercent: wordFactor.whiteRate)

        print("LetterDefaultColor \(letterDefaultColor), bg \(wordBackgroundWhiteColor)")
        let checker = LetterExistenceChecker(bitmap, pixelChecker: pixelChecker)
        return checker
    }
}

extension LetterRecognizer {
    init<T: Rectangle> (_ bitmap: NSBitmapImageRep, word: Word<T> ) {
        let colorFinder = UniversalWhiteColorFinder(picker: ColorPicker(bitmap))
        let bgColor = colorFinder.findBackgroundColor(word)
        let wordFactor = WordFactor(rectangle: word)
        self.init(in: bitmap, wordBackgroundWhiteColor: bgColor, letterColorFinder: colorFinder, wordFactor: wordFactor)
    }
}
