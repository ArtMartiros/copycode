//
//  CustomOCRTests.swift
//  CopyCodeTests
//
//  Created by Артем on 01/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest
//22
class CustomOCRTests: XCTestCase {
    let textRecognizer = TextRecognizerManager()
    enum ColorType: CGFloat {
        case white = 1
        case black = 0
    }
    //2
    //1 @
    func testScene1() {
        checkLetter(from: .sc1, bg: .white) { (answer, position) in
            XCTAssertEqual(answer, position.letter.value, "l: \(position.l), w: \(position.w) c: \(position.c)")
        }
    }
    
    //3
    func testScene2() {
        checkLetter(from: .sc2, bg: .white) { (answer, position) in
            XCTAssertEqual(answer, position.letter.value, "l: \(position.l), w: \(position.w) c: \(position.c)")
        }
    }
    
    //17
    func testScene9() {
        checkLetter(from: .sc9, bg: .white) { (answer, position) in
            XCTAssertEqual(answer, position.letter.value, "l: \(position.l), w: \(position.w) c: \(position.c)")
        }
    }
//1
    func testScene15() {
        checkLetter(from: .sc15, bg: .black) { (answer, position) in
            XCTAssertEqual(answer, position.letter.value, "l: \(position.l), w: \(position.w) c: \(position.c)")
        }
    }
    
    private func checkLetter(from scene: Scene, bg: ColorType, completion: (String, CompletedLetterPosition) -> Void ) {
        let bitmap = scene.getImage(isLow: false).bitmap
        let letterPositions = scene.getCustomLettersPosition()
        let recognizer = getRecognizer(from: bitmap, frame: letterPositions[0].letter, bg: bg)
       
        for (index, lp) in letterPositions.enumerated() {
            print("Letter index \(index)")
            let char = recognizer.recognize(from: lp.letter)
            let letter = Letter(rectangle: lp.letter, value: char)
            let position = LetterWithPosition(position: lp, letter: letter)
            let lineLetters = scene.getLetters(for: position.l, isLow: false)
            let answer = Array(lineLetters)[position.lineCharCount]
            completion(answer, position)
        }
    }
    
    private func getRecognizer(from bitmap: NSBitmapImageRep, frame: Rectangle, bg: ColorType) -> LetterRecognizer {
        
        let colorFinder = UniversalWhiteColorFinder(picker: ColorPicker(bitmap))
        let wordFactor = WordFactor(rectangle: frame)
        let recognizer = LetterRecognizer(in: bitmap, wordBackgroundWhiteColor: bg.rawValue,
                                          letterColorFinder: colorFinder, wordFactor: wordFactor)
        
        return recognizer
    }
    
}
