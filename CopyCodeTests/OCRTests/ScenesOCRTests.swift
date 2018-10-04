//
//  ScenesOCRTests.swift
//  CopyCodeTests
//
//  Created by Артем on 04/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

class ScenesOCRTests: XCTestCase {
    
    func testExample() {
        let block = Scene.sc2.getGridWithTypeBlock(self)
        let bitmap = Scene.sc2.image.bitmap
        for (lineIndex, line) in block.lines.enumerated() where lineIndex == 0 {
            let rightLine = Array(Scene.sc2.getLetters(for: lineIndex))
            var index = 0
            
            for (wordIndex, word) in line.words.enumerated() {
                let recognizer = LetterRecognizer(bitmap, rectangle: word)
                for (letterIndex, letter) in word.letters.enumerated() {
                    let value = recognizer.recognize(from: letter)
                    let answer = rightLine[index]
                    XCTAssertEqual(value, answer, "l: \(lineIndex), w: \(wordIndex), c: \(letterIndex)")
                    index += 1
                }
            }
        }
    }
}
