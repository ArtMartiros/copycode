//
//  ScenesOCRTests.swift
//  CopyCodeTests
//
//  Created by Артем on 04/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest
//3 Custom
//22 ошибки в letter
//7 тут
class ScenesOCRTests: XCTestCase {
    
    func testOCRScene1() {
        let exludedIndex: Set<Int> = [0, 1, 2, 15, 16, 17]
        executeCheck(scene: .sc1, exlude: exludedIndex) { (answer, position) in
            XCTAssertEqual(position.letter.value, answer, "l: \(position.l), w: \(position.w) c: \(position.c)")
        }
    }
    
    func testOCRScene2() {
        executeCheck(scene: .sc2, exlude: []) { (answer, position) in
            XCTAssertEqual(position.letter.value, answer, "l: \(position.l), w: \(position.w) c: \(position.c)")
        }
    }
    
    //1 ошибки кастом
    func testOCRScene3_p1() {
        let exludedIndex: Set<Int> = [0, 1, 2, 3, 4, 5, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45]
        executeCheck(scene: .sc3_p1, exlude: exludedIndex) { (answer, position) in
            XCTAssertEqual(position.letter.value, answer, "l: \(position.l), w: \(position.w) c: \(position.c)")
        }
    }
    
    func testOCRScene9() {
        executeCheck(scene: .sc9, exlude: [1, 2]) { (answer, position) in
            XCTAssertEqual(position.letter.value, answer, "l: \(position.l), w: \(position.w) c: \(position.c)")
        }
    }
    
    private func executeCheck(scene: Scene, exlude: Set<Int>,
                              completion: @escaping (String, CompletedLetterPosition) -> Void) {
        let block = scene.getGridWithTypeBlock(self)
        let bitmap = scene.image.bitmap
        
        for (lineIndex, line) in block.lines.enumerated() where !exlude.contains(lineIndex) {
            let rightLine = Array(scene.getLetters(for: lineIndex))
            
            for (wordIndex, word) in line.words.enumerated() {
                let recognizer = LetterRecognizer(bitmap, word: word)
                var startIndex = line.words[0..<wordIndex].map { $0.letters }.reduce([], +).count
                
                for (letterIndex, letter) in word.letters.enumerated() {
                    let value = recognizer.recognize(from: letter)
                    let answer = rightLine[startIndex]
                    let newLetter = Letter(rectangle: letter, value: value)
                    let position = LetterWithPosition(l: lineIndex, w: wordIndex, c: letterIndex,
                                                      lineCharCount: startIndex, letter: newLetter)
                    completion(answer, position)
                    startIndex += 1
                    
                }
            }
        }
        
    }
 

}
