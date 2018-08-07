//
//  LetterOCRTests.swift
//  CopyCodeTests
//
//  Created by Артем on 12/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//
//18
//26
import XCTest

fileprivate struct Answer: Codable {
    let letter: String
    let type: LetterType
}
enum Picture {
    case typeWhite
    case typeBlack
    var imageName: String {
        switch self {
        case .typeWhite: return "picLetterTypeClassification"
        case .typeBlack: return "picLetterTypeClassificationBlack"
        }
    }
    
    var json: String {
        switch self {
        case .typeWhite: return "letter_type_classification"
        case .typeBlack: return "letter_type_classification_black"
        }
    }
    
}
class LetterOCRTests: XCTestCase {
    private let textManager = TextRecognizerManager()
    
    func testLetterOCRWhite() {
        setup(with: Picture.typeWhite) { (recognizer, letters, answers) in
            for (index, letter) in letters.enumerated() {
                let answer = answers[index]
                let value = recognizer.recognize(from: letter.pixelFrame, with: answer.type)
                print("🔔: \(answer.letter), pixelFrame: \(letter.pixelFrame)")
                XCTAssertTrue(answer.letter == value, "✅\(answer.letter)✅ -- ❌\(value)❌")
                print("______________________")
            }
        }
        
    }
    
    func testLetterOCRBlack() {
        setup(with: Picture.typeBlack) { (recognizer, letters, answers) in
            for (index, letter) in letters.enumerated() {
                let answer = answers[index]
                let value = recognizer.recognize(from: letter.pixelFrame, with: answer.type)
                print("🔔: \(answer.letter), pixelFrame: \(letter.pixelFrame)")
                XCTAssertTrue(answer.letter == value, "✅\(answer.letter)✅ -- ❌\(value)❌")
                print("______________________")
            }
        }
    }
    
    func testPerformanceExample() {
        setup(with: Picture.typeWhite) { (recognizer, letters, answers) in
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
        textManager.performRequest(image: image) { (bitmap, words, _) in
            let letterRecognizer = LetterRecognizer(bitmap, rectangle: words[0])
            let letters = words[0].letters
            for (index, letter) in letters.enumerated() {
                let answer = answers[index]
                print("🔔: \(answer.letter), pixelFrame: \(letter.pixelFrame)")
            }
            completion(letterRecognizer, letters, answers)
        }
    }
}
