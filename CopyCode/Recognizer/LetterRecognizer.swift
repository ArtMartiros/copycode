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
    
    func recognize(from letter: LetterRectangle) -> String {
        return recognize(from: letter.pixelFrame, with: letter.type)
    }
    
    private func letterExistenceChecker(from frame: CGRect) -> LetterExistenceChecker {
        let letterDefaultColor = letterColorFinder.findedLetterColor(frame, with: backgroundWhiteColor)
        let pixelChecker = LetterPixelChecker(backgroundWhite: backgroundWhiteColor,
                                              letterDefaultWhite: letterDefaultColor,
                                              whitePercent: wordFactor.whiteRate)
        
        print("LetterDefaultColor \(letterDefaultColor), bg \(backgroundWhiteColor)")
        let checker = LetterExistenceChecker(bitmap, pixelChecker: pixelChecker)
        return checker
    }
}

extension LetterRecognizer {
    init<T: Rectangle> (_ bitmap: NSBitmapImageRep, rectangle: Word<T> ) {
        let colorFinder = UniversalWhiteColorFinder(picker: ColorPicker(bitmap))
        let bgColor = colorFinder.findedBackgroundColor(rectangle)
        let wordFactor = WordFactor(rectangle: rectangle)
        self.init(in: bitmap, backgroundWhiteColor: bgColor, letterColorFinder: colorFinder, wordFactor: wordFactor)
    }
}

