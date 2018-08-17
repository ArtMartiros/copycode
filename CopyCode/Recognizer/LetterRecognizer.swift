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
    private let backgroundWhiteColor: CGFloat
    private let letterColorFinder: LetterWhiteColorProtocol
    private let wordFactor: WordFactor
    init(in bitmap: NSBitmapImageRep,
         backgroundWhiteColor: CGFloat,
         letterColorFinder: LetterWhiteColorProtocol,
         wordFactor: WordFactor) {
        self.bitmap = bitmap
        self.backgroundWhiteColor = backgroundWhiteColor
        self.letterColorFinder = letterColorFinder
        self.wordFactor = wordFactor
    }
   
    func recognize(from frame: CGRect, with type: LetterType) -> String {
        let checker = letterExistenceChecker(from: frame)
        return type.treeOCR.find(checker, with: frame) ?? "*"
    }
    
    /// Метод нужен когда необходимо использовать кастомное древо
    func recognize(from frame: CGRect, with treeOCR: TreeOCR) -> String {
        let checker = letterExistenceChecker(from: frame)
        return treeOCR.find(checker, with: frame) ?? "*"
    }
    
    func recognize(from rectangle: LetterRectangleWithType) -> String {
        return recognize(from: rectangle.pixelFrame, with: rectangle.type)
    }
    
    private func letterExistenceChecker(from frame: CGRect) -> LetterExistenceChecker {
        let pixelExistence = LetterPixelChecker(backgroundWhite: backgroundWhiteColor, whitePercent: wordFactor.whiteRate)
        let defaultColor = letterColorFinder.findedLetterColor(frame, with: backgroundWhiteColor)
        print("LetterDefaultColor \(defaultColor), bg \(backgroundWhiteColor)")
        let checker = LetterExistenceChecker(bitmap, pixelExistence: pixelExistence, letterDefaultWhite: defaultColor)
        return checker
    }
}

extension LetterRecognizer {
    init (_ bitmap: NSBitmapImageRep, rectangle: Word<LetterRectangle> ) {
        let colorFinder = UniversalWhiteColorFinder(picker: ColorPicker(bitmap))
        let bgColor = colorFinder.findedBackgroundColor(rectangle)
        let wordFactor = WordFactor(rectangle: rectangle)
        self.init(in: bitmap, backgroundWhiteColor: bgColor, letterColorFinder: colorFinder, wordFactor: wordFactor)
    }
}

