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
        switch type {
        case .upper: return upperTree.find(checker, with: frame)!
        case .low: return lowTree.find(checker, with: frame)!
        case .lowWithTail: return lowWithTailTree.find(checker, with: frame)!
        default: return "*"
        }
    }
    
    func recognize(from rectangle: LetterRectangle, with type: LetterType) -> Letter {
        let letterValue = recognize(from: rectangle.pixelFrame, with: type)
        return Letter(rectangle: rectangle, value: letterValue)
    }
    
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
    convenience init (_ bitmap: NSBitmapImageRep, rectangle: WordRectangleProtocol ) {
        let colorFinder = UniversalWhiteColorFinder(picker: ColorPicker(bitmap))
        let bgColor = colorFinder.findedBackgroundColor(rectangle)
        self.init(in: bitmap, backgroundWhiteColor: bgColor, letterColorFinder: colorFinder)
    }
}

