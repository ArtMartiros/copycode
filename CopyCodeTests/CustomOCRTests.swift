//
//  CustomOCRTests.swift
//  CopyCodeTests
//
//  Created by Артем on 01/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

class CustomOCRTests: XCTestCase {
    let textRecognizer = TextRecognizerManager()
    let answers: [String] = ["@", "=", "-", "=", "=", "=", "=", "}", "=", "1", ".", "2", "=", "-", "="]
    
    func testScene1() {
        let bitmap = Scene.sc1.image.bitmap
        let letters = Scene.sc1.getCustomLetters(self)
        print(bitmap.pixelSize)
        let colorFinder = UniversalWhiteColorFinder(picker: ColorPicker(bitmap))
        let wordFactor = WordFactor(rectangle: letters[0])
        let recognizer = LetterRecognizer(in: bitmap, backgroundWhiteColor: 1,
                                          letterColorFinder: colorFinder, wordFactor: wordFactor)
        let chars = letters.map {
            recognizer.recognize(from: $0)
        }
        
        for (index, char ) in chars.enumerated() {
            XCTAssertEqual(char, answers[index])
        }
    }
}
