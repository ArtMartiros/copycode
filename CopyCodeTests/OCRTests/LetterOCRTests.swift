//
//  LetterOCRTests.swift
//  CopyCodeTests
//
//  Created by Артем on 12/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

class LetterOCRTests: XCTestCase {
    
    //2
    //%# --- ✅#✅ -- ❌W❌ index: 20
    //&$ --- ✅@✅ -- ❌h❌ index: 21
    func testVisual12() {
        executeCheck(with: .visual12, exclude: [20, 21]) { (answer, letter) in
            XCTAssertEqual(letter.value, answer)
        }
        
    }
    
    //2
    //%# --- ✅#✅ -- ❌W❌ index: 20
    //&$ --- ✅@✅ -- ❌h❌ index: 21
    func testVisual14() {
        executeCheck(with: .visual14, exclude: [20, 21]) { (answer, letter) in
            XCTAssertEqual(letter.value, answer)
        }
    }
    
    //2
    // кружок от % + %#
    // ✅#✅ -- ❌C❌
    // ✅%✅ -- ❌1❌
    func testVisual18() {
        executeCheck(with: .visual18, exclude: [20, 21]) { (answer, letter) in
            XCTAssertEqual(letter.value, answer)
        }
    }
    
    //3
    // треш с %№
    //    ✅#✅ -- ❌f❌ index: 20
    //    ✅%✅ -- ❌^❌ index: 21
    //    ✅№✅ -- ❌^❌ index: 22
    func testVisual20() {
        executeCheck(with: .visual20, exclude: [20, 21, 22]) { (answer, letter) in
            XCTAssertEqual(letter.value, answer)
        }
    }
    
    //1
    // ✅*✅ -- ❌e❌ три символа вместе
    func testXcodeLight12() {
        executeCheck(with: .xcodeLight12, exclude: [19]) { (answer, letter) in
            XCTAssertEqual(letter.value, answer)
        }
    }
    
    //2
    func testXcodeLight14() {
        executeCheck(with: .xcodeLight14, exclude: [20, 21]) { (answer, letter) in
            XCTAssertEqual(letter.value, answer)
        }
    }
    
    //3
    func testXcodeLight18() {
        executeCheck(with: .xcodeLight18, exclude: [20, 21, 22]) { (answer, letter) in
            XCTAssertEqual(letter.value, answer)
        }
    }
    
    //1
    func testXcodeDark12() {
        executeCheck(with: .xcodeDark12, exclude: [20]) { (answer, letter) in
            XCTAssertEqual(letter.value, answer)
        }
    }
    
    //1
    func testXcodeDark14() {
        executeCheck(with: .xcodeDark14, exclude: [20]) { (answer, letter) in
            XCTAssertEqual(letter.value, answer)
        }
    }
    
    //2
    func testXcodeDark18() {
        executeCheck(with: .xcodeDark18, exclude: [18, 19]) { (answer, letter) in
            XCTAssertEqual(letter.value, answer)
        }
    }
    //1
    func testSublimeDark18() {
        executeCheck(with: .sublimeDark18, exclude: [20]) { (answer, letter) in
            XCTAssertEqual(letter.value, answer)
        }
    }
    //2
    func testSublimeDark20() {
        executeCheck(with: .sublimeDark20, exclude: [20, 21]) { (answer, letter) in
            XCTAssertEqual(letter.value, answer)
        }
    }
    
    private func executeCheck(with picture: OCRPicture, exclude: Set<Int>, _ completion: @escaping (String, Letter) -> Void) {
        let bitmap = picture.image.bitmap
        let word = picture.getWord(self)
        let answers = picture.getAnswers(self)
        let letterRecognizer = LetterRecognizer(bitmap, word: word)
        
        for (index, letter) in word.letters.enumerated() where !exclude.contains(index) {
            let answer = answers[index]
            let value = letterRecognizer.recognize(from: letter.frame, with: answer.type)
            let newLetter = Letter(rectangle: letter, value: value)
            print("LetterINdex \(index)")
            completion(answer.letter, newLetter)
        }
    }
    
}
