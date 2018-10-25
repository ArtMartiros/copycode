//
//  LetterOCRTests.swift
//  CopyCodeTests
//
//  Created by Артем on 12/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//
//22
import XCTest

class LetterOCRTests: XCTestCase {
    
    //2
    //%# --- ✅#✅ -- ❌W❌
    //&$ --- ✅@✅ -- ❌h❌
    func testVisual12() {
        executeCheck(with: .visual12) { (answer, letter) in
            XCTAssertEqual(letter.value, answer)
        }
        
    }
    
    //2
    //%# --- ✅#✅ -- ❌W❌
    //&$ --- ✅@✅ -- ❌h❌
    func testVisual14() {
        executeCheck(with: .visual14) { (answer, letter) in
            XCTAssertEqual(letter.value, answer)
        }
    }
    
    //2
    // кружок от % + %#
    // ✅#✅ -- ❌C❌
    // ✅%✅ -- ❌1❌
    func testVisual18() {
        executeCheck(with: .visual18) { (answer, letter) in
            XCTAssertEqual(letter.value, answer)
        }
    }
    
    //3
    // треш с %№
    //    ✅#✅ -- ❌f❌
    //    ✅%✅ -- ❌^❌
    //    ✅№✅ -- ❌^❌
    func testVisual20() {
        executeCheck(with: .visual20) { (answer, letter) in
            XCTAssertEqual(letter.value, answer)
        }
    }
    
    //1
    // ✅*✅ -- ❌e❌ три символа вместе
    func testXcodeLight12() {
        executeCheck(with: .xcodeLight12) { (answer, letter) in
            XCTAssertEqual(letter.value, answer)
        }
    }
    
    //2
    func testXcodeLight14() {
        executeCheck(with: .xcodeLight14) { (answer, letter) in
            XCTAssertEqual(letter.value, answer)
        }
    }
    
    //3
    func testXcodeLight18() {
        executeCheck(with: .xcodeLight18) { (answer, letter) in
            XCTAssertEqual(letter.value, answer)
        }
    }
    
    //1
    func testXcodeDark12() {
        executeCheck(with: .xcodeDark12) { (answer, letter) in
            XCTAssertEqual(letter.value, answer)
        }
    }
    
    //1
    func testXcodeDark14() {
        executeCheck(with: .xcodeDark14) { (answer, letter) in
            XCTAssertEqual(letter.value, answer)
        }
    }
    
    //2
    func testXcodeDark18() {
        executeCheck(with: .xcodeDark18) { (answer, letter) in
            XCTAssertEqual(letter.value, answer)
        }
    }
    //1
    func testSublimeDark18() {
        executeCheck(with: .sublimeDark18) { (answer, letter) in
            XCTAssertEqual(letter.value, answer)
        }
    }
    //2
    func testSublimeDark20() {
        executeCheck(with: .sublimeDark20) { (answer, letter) in
            XCTAssertEqual(letter.value, answer)
        }
    }
    
    private func executeCheck(with picture: OCRPicture, _ completion: @escaping (String, Letter) -> Void) {
        let bitmap = picture.image.bitmap
        let word = picture.getWord(self)
        let answers = picture.getAnswers(self)
        let letterRecognizer = LetterRecognizer(bitmap, word: word)
        
        for (index, letter) in word.letters.enumerated() {
            let answer = answers[index]
            let value = letterRecognizer.recognize(from: letter.frame, with: answer.type)
            let newLetter = Letter(rectangle: letter, value: value)
            completion(answer.letter, newLetter)
        }
    }
    
}
