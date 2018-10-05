//
//  ScenesOCRTests.swift
//  CopyCodeTests
//
//  Created by Артем on 04/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

 //23 ошибки в letter
class ScenesOCRTests: XCTestCase {
    
    func testOCRScene2() {
        let block = Scene.sc2.getGridWithTypeBlock(self)
        let bitmap = Scene.sc2.image.bitmap
        var allIndex = 0
        for (lineIndex, line) in block.lines.enumerated() {
            let rightLine = Array(Scene.sc2.getLetters(for: lineIndex))

            for (wordIndex, word) in line.words.enumerated() {
                let recognizer = LetterRecognizer(bitmap, word: word)
                var startIndex = line.words[0..<wordIndex].map { $0.letters }.reduce([], +).count
                
                for (letterIndex, letter) in word.letters.enumerated() {
                    let value = recognizer.recognize(from: letter)
                    let answer = rightLine[startIndex]
                    XCTAssertEqual(value, answer, "l: \(lineIndex), w: \(wordIndex), c: \(letterIndex)")
                    startIndex += 1
                    allIndex += 1
                }
            }
        }
        
        print(allIndex)
    }
}
