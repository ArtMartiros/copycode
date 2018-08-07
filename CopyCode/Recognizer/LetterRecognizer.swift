//
//  LetterRecognizer.swift
//  CopyCode
//
//  Created by Артем on 18/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

final class LetterRecognizer {
    
    private let bitmap: NSBitmapImageRep
    private let backgroundWhiteColor: CGFloat
    private let letterColorFinder: LetterWhiteColorProtocol
    init(in bitmap: NSBitmapImageRep, backgroundWhiteColor: CGFloat, letterColorFinder: LetterWhiteColorProtocol) {
        self.bitmap = bitmap
        self.backgroundWhiteColor = backgroundWhiteColor
        self.letterColorFinder = letterColorFinder
    }
   
    func recognize(from frame: CGRect, with type: LetterType) -> String {
        let checker = colorChecker(from: frame)
        return type.treeOCR.find(checker, with: frame) ?? "*"
    }
    
    /// Метод нужен когда необходимо использовать кастомное древо
    func recognize(from frame: CGRect, with treeOCR: TreeOCR) -> String {
        let checker = colorChecker(from: frame)
        return treeOCR.find(checker, with: frame) ?? "*"
    }
    
//    func recognize(from rectangle: LetterRectangle, with type: LetterType) -> Letter {
//        let letterValue = recognize(from: rectangle.pixelFrame, with: type)
//        return Letter(rectangle: rectangle, value: letterValue)
//    }
    
    private func colorChecker(from frame: CGRect) -> LetterColorChecker {
        let whiteRate = WordFactor(frame: frame).whiteRate
        let pixelChecker = LetterPixelChecker(backgroundWhite: backgroundWhiteColor, whitePercent: whiteRate)
        let defaultColor = letterColorFinder.findedLetterColor(frame, with: backgroundWhiteColor)
        print("LetterDefaultColor \(defaultColor), bg \(backgroundWhiteColor)")
        let checker = LetterColorChecker(bitmap, pixelChecker: pixelChecker, letterDefaultWhite: defaultColor)
        return checker
    }
}

extension LetterRecognizer {
    convenience init (_ bitmap: NSBitmapImageRep, rectangle: Word<LetterRectangle> ) {
        let colorFinder = UniversalWhiteColorFinder(picker: ColorPicker(bitmap))
        let bgColor = colorFinder.findedBackgroundColor(rectangle)
        self.init(in: bitmap, backgroundWhiteColor: bgColor, letterColorFinder: colorFinder)
    }
}

