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
    
    //1 @
    func testScene1() {
        let answers: [String] = ["@", "=", "-", "=", "=", "=", "=", "}", "=", "1", ".", "2", "=", "-", "="]
        let chars = getChars(from: .sc1)
        for (index, char) in chars.enumerated() {
            XCTAssertEqual(char, answers[index])
        }
    }
    
    func testScene2() {
        let answers: [String] = ["=", "=", "=", "}", "-", ">", "=", "\"", "=", "\"", "=", "\"","=", "\"",
                                 "}", "_", "-", ">", "=", "=", "}", "."]
        let chars = getChars(from: .sc2)
        for (index, char ) in chars.enumerated() {
            print(index)
            XCTAssertEqual(char, answers[index])
        }
    }
    
    private func getChars(from scene: Scene, number: Int? = nil) -> [String] {
        let bitmap = scene.image.bitmap
        let letters = scene.getCustomLetters(self)
        let colorFinder = UniversalWhiteColorFinder(picker: ColorPicker(bitmap))
        let wordFactor = WordFactor(rectangle: letters[0])
        let recognizer = LetterRecognizer(in: bitmap, backgroundWhiteColor: 1,
                                          letterColorFinder: colorFinder, wordFactor: wordFactor)
        var chars: [String] = []
        if let number = number {
           chars = [recognizer.recognize(from: letters[number])]
        } else {
            for (index, letter) in letters.enumerated() {
                print("Letter index \(index)")
                let char = recognizer.recognize(from: letter)
                chars.append(char)
            }
        }

        return chars
    }
  
}
