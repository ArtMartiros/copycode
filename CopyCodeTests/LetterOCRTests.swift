//
//  LetterOCRTests.swift
//  CopyCodeTests
//
//  Created by Артем on 12/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//
//22
import XCTest

fileprivate struct Answer: Codable {
    let letter: String
    let type: LetterType
}

class LetterOCRTests: XCTestCase {

    //2
    //%# --- ✅#✅ -- ❌W❌
    //&$ --- ✅@✅ -- ❌h❌
    func testVisual12() {
        setup(with: .visual12) { (recognizer, letters, answers) in
            for (index, letter) in letters.enumerated() {
                let answer = answers[index]
                let value = recognizer.recognize(from: letter.pixelFrame, with: answer.type)
                print("🔔: \(answer.letter), pixelFrame: \(letter.pixelFrame.debugDescription)")
                XCTAssertTrue(answer.letter == value, "✅\(answer.letter)✅ -- ❌\(value)❌")
                print("______________________")
            }
        }
    }
    
    //2
    //%# --- ✅#✅ -- ❌W❌
    //&$ --- ✅@✅ -- ❌h❌
    func testVisual14() {
        setup(with: .visual14) { (recognizer, letters, answers) in
            for (index, letter) in letters.enumerated() {
                let answer = answers[index]
                let value = recognizer.recognize(from: letter.pixelFrame, with: answer.type)
                print("🔔: \(answer.letter), pixelFrame: \(letter.pixelFrame.debugDescription)")
                XCTAssertTrue(answer.letter == value, "✅\(answer.letter)✅ -- ❌\(value)❌")
                print("______________________")
            }
        }
    }
    
    //2
    // кружок от % + %#
    // ✅#✅ -- ❌C❌
    // ✅%✅ -- ❌1❌
    func testVisual18() {
        setup(with: .visual18) { (recognizer, letters, answers) in
            for (index, letter) in letters.enumerated() {
                let answer = answers[index]
                let value = recognizer.recognize(from: letter.pixelFrame, with: answer.type)
                print("🔔: \(answer.letter), pixelFrame: \(letter.pixelFrame.debugDescription)")
                XCTAssertTrue(answer.letter == value, "✅\(answer.letter)✅ -- ❌\(value)❌")
                print("______________________")
            }
        }
    }
    
    
    //3
    // треш с %№
    //    ✅#✅ -- ❌f❌
    //    ✅%✅ -- ❌^❌
    //    ✅№✅ -- ❌^❌
    func testVisual20() {
        setup(with: .visual20) { (recognizer, letters, answers) in
            for (index, letter) in letters.enumerated() {
                let answer = answers[index]
                let value = recognizer.recognize(from: letter.pixelFrame, with: answer.type)
                print("🔔: \(answer.letter), pixelFrame: \(letter.pixelFrame.debugDescription)")
                XCTAssertTrue(answer.letter == value, "✅\(answer.letter)✅ -- ❌\(value)❌")
                print("______________________")
            }
        }
    }
    
    //1
    // ✅*✅ -- ❌e❌ три символа вместе
    func testXcodeLight12() {
        setup(with: .xcodeLight12) { (recognizer, letters, answers) in
            for (index, letter) in letters.enumerated() {
                let answer = answers[index]
                let value = recognizer.recognize(from: letter.pixelFrame, with: answer.type)
                print("🔔: \(answer.letter), pixelFrame: \(letter.pixelFrame.debugDescription)")
                XCTAssertTrue(answer.letter == value, "✅\(answer.letter)✅ -- ❌\(value)❌")
                print("______________________")
            }
        }
    }
    
    //2
    func testXcodeLight14() {
        setup(with: .xcodeLight14) { (recognizer, letters, answers) in
            for (index, letter) in letters.enumerated() {
                let answer = answers[index]
                let value = recognizer.recognize(from: letter.pixelFrame, with: answer.type)
                print("🔔: \(answer.letter), pixelFrame: \(letter.pixelFrame.debugDescription)")
                XCTAssertTrue(answer.letter == value, "✅\(answer.letter)✅ -- ❌\(value)❌")
                print("______________________")
            }
        }
    }
    
    //3
    func testXcodeLight18() {
        setup(with: .xcodeLight18) { (recognizer, letters, answers) in
            for (index, letter) in letters.enumerated() {
                let answer = answers[index]
                let value = recognizer.recognize(from: letter.pixelFrame, with: answer.type)
                print("🔔: \(answer.letter), pixelFrame: \(letter.pixelFrame.debugDescription)")
                XCTAssertTrue(answer.letter == value, "✅\(answer.letter)✅ -- ❌\(value)❌")
                print("______________________")
            }
        }
    }
    
    //1
    func testXcodeDark12() {
        setup(with: .xcodeDark12) { (recognizer, letters, answers) in
            for (index, letter) in letters.enumerated() {
                let answer = answers[index]
                let value = recognizer.recognize(from: letter.pixelFrame, with: answer.type)
                print("🔔: \(answer.letter), pixelFrame: \(letter.pixelFrame.debugDescription)")
                XCTAssertTrue(answer.letter == value, "✅\(answer.letter)✅ -- ❌\(value)❌")
                print("______________________")
            }
        }
    }
    
    //1
    func testXcodeDark14() {
        setup(with: .xcodeDark14) { (recognizer, letters, answers) in
            for (index, letter) in letters.enumerated() {
                let answer = answers[index]
                let value = recognizer.recognize(from: letter.pixelFrame, with: answer.type)
                print("🔔: \(answer.letter), pixelFrame: \(letter.pixelFrame.debugDescription)")
                XCTAssertTrue(answer.letter == value, "✅\(answer.letter)✅ -- ❌\(value)❌")
                print("______________________")
            }
        }
    }
    
    //2
    func testXcodeDark18() {
        setup(with: .xcodeDark18) { (recognizer, letters, answers) in
            for (index, letter) in letters.enumerated() {
                let answer = answers[index]
                let value = recognizer.recognize(from: letter.pixelFrame, with: answer.type)
                print("🔔: \(answer.letter), pixelFrame: \(letter.pixelFrame.debugDescription)")
                XCTAssertTrue(answer.letter == value, "✅\(answer.letter)✅ -- ❌\(value)❌")
                print("______________________")
            }
        }
    }
    //1
    func testSublimeDark18() {
        setup(with: .sublimeDark18) { (recognizer, letters, answers) in
            for (index, letter) in letters.enumerated() {
                let answer = answers[index]
                let value = recognizer.recognize(from: letter.pixelFrame, with: answer.type)
                print("🔔: \(answer.letter), pixelFrame: \(letter.pixelFrame.debugDescription)")
                XCTAssertTrue(answer.letter == value, "✅\(answer.letter)✅ -- ❌\(value)❌")
                print("______________________")
            }
        }
    }
    //2
    func testSublimeDark20() {
        setup(with: .sublimeDark20) { (recognizer, letters, answers) in
            for (index, letter) in letters.enumerated() {
                let answer = answers[index]
                let value = recognizer.recognize(from: letter.pixelFrame, with: answer.type)
                print("🔔: \(answer.letter), pixelFrame: \(letter.pixelFrame.debugDescription)")
                XCTAssertTrue(answer.letter == value, "✅\(answer.letter)✅ -- ❌\(value)❌")
                print("______________________")
            }
        }
    }
        
    //0.011
    //0.02 обрезка
    func testPerformanceExample() {
        setup(with: .xcodeLight18) { (recognizer, letters, answers) in
            self.measure {
                for (index, letter) in letters.enumerated() {
                    let answer = answers[index]
                    _ = recognizer.recognize(from: letter.pixelFrame, with: answer.type)
                }
            }
        }

    }
    
    
    private func setup(with picture: Picture, _ completion: @escaping (LetterRecognizer, [LetterRectangle], [Answer]) -> Void) {
        
        let image = NSImage(named: .init(picture.imageName))!
        guard let answers = DecodeHelper.decode(self,
                                                path: picture.json,
                                                structType: [Answer].self) else { return }
        let textManager = TextRecognizerManager()
        textManager.performRequest(image: image) { (bitmap, words, _) in
            let letterRecognizer = LetterRecognizer(bitmap, rectangle: words[0])
            let letters = words[0].letters
            print("LettersCount: \(letters.count)")
            for (index, letter) in letters.enumerated() {
                let answer = answers[index]
                    print("🔔: \(answer.letter), ratio: \(letter.pixelFrame.ratio), pixelFrame: \(letter.pixelFrame)")
            }

            completion(letterRecognizer, letters, answers)

        }
    }
}


