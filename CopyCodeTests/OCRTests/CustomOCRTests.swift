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
        let answers: [String] = ["@", "=", "-", "=", "=", "=", "=", "}", "}", "=", "1", ".", "2", "=", "-", "="]
        let chars = getChars(from: .sc1)
        for (index, char) in chars.enumerated() {
            XCTAssertEqual(answers[index], char)
        }
    }
    
    func testScene2() {
        let answers: [String] = ["=", "=", "=", "}", "-", ">", "=", "\"", "=", "\"", "=", "\"","=", "\"",
                                 "}", "_", "-", ">", "=", "=", "}", "."]
        let chars = getChars(from: .sc2)
        for (index, char ) in chars.enumerated() {
            print(index)
            XCTAssertEqual(answers[index], char)
        }
    }
    
    func testScene9() {
        checkLetter(from: .sc9) { (answer, position) in
            XCTAssertEqual(answer, position.letter.value, "l: \(position.l), w: \(position.w) c: \(position.c)")
        }
    }
    
    private func checkLetter(from scene: Scene, completion: (String, CompletedLetterPosition) -> Void ) {
        let bitmap = scene.image.bitmap
        let letterPositions = scene.getCustomLettersPosition(self)
        let recognizer = getRecognizer(from: bitmap, frame: letterPositions[0].letter)
       
        for (index, lp) in letterPositions.enumerated() {
            print("Letter index \(index)")
            let char = recognizer.recognize(from: lp.letter)
            let letter = Letter(rectangle: lp.letter, value: char)
            let position = LetterWithPosition(position: lp, letter: letter)
            let lineLetters = scene.getLetters(for: position.l)
            let answer = Array(lineLetters)[position.lineCharCount]
            completion(answer, position)
        }
    }
    
    
    private func getRecognizer(from bitmap: NSBitmapImageRep, frame: Rectangle) -> LetterRecognizer {
        
        let colorFinder = UniversalWhiteColorFinder(picker: ColorPicker(bitmap))
        let wordFactor = WordFactor(rectangle: frame)
        let recognizer = LetterRecognizer(in: bitmap, wordBackgroundWhiteColor: 1,
                                          letterColorFinder: colorFinder, wordFactor: wordFactor)
        
        return recognizer
    }
    
    private func getChars(from scene: Scene, number: Int? = nil) -> [String] {
        let bitmap = scene.image.bitmap
        let letters = scene.getCustomLetters(self)
        let colorFinder = UniversalWhiteColorFinder(picker: ColorPicker(bitmap))
        let wordFactor = WordFactor(rectangle: letters[0])
        let recognizer = LetterRecognizer(in: bitmap, wordBackgroundWhiteColor: 1,
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
