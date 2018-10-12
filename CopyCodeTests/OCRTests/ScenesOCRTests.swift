//
//  ScenesOCRTests.swift
//  CopyCodeTests
//
//  Created by Артем on 04/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

 //22 ошибки в letter
class ScenesOCRTests: XCTestCase {
    
    func testOCRScene1() {
        let exludedIndex: Set<Int> = [0, 1, 2, 15, 16, 17]
        let scene = Scene.sc1
        let block = scene.getGridWithTypeBlock(self)
        let bitmap = scene.image.bitmap
        var allIndex = 0
        for (lineIndex, line) in block.lines.enumerated() where !exludedIndex.contains(lineIndex) {
            let rightLine = Array(scene.getLetters(for: lineIndex))
            
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
    
    func testOCRScene2() {
        let scene = Scene.sc2
        let block = scene.getGridWithTypeBlock(self)
        let bitmap = scene.image.bitmap
        var allIndex = 0
        for (lineIndex, line) in block.lines.enumerated() {
            let rightLine = Array(scene.getLetters(for: lineIndex))

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
    
    //3 ошибки кастом
    func testOCRScene3_p1() {
        let scene = Scene.sc3_p1
        let exludedIndex: Set<Int> = [0, 1, 2, 3, 4, 5, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45]
        let block = scene.getGridWithTypeBlock(self)
        let bitmap = scene.image.bitmap
        var allIndex = 0
        for (lineIndex, line) in block.lines.enumerated() where !exludedIndex.contains(lineIndex) {
            let rightLine = Array(scene.getLetters(for: lineIndex))
            
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
    
    func testOCRScene9() {
        let scene = Scene.sc9
        let exludedIndex: Set<Int> = [ 1, 2]
        let block = scene.getGridWithTypeBlock(self)
        let bitmap = scene.image.bitmap
        var allIndex = 0
        for (lineIndex, line) in block.lines.enumerated() where !exludedIndex.contains(lineIndex) {
            let rightLine = Array(scene.getLetters(for: lineIndex))
            
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
