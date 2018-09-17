//
//  LetterTypeClassificationTests.swift
//  CopyCodeTests
//
//  Created by Артем on 04/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest
import AppKit

fileprivate struct Answer: Codable {
    let letter: String
    let type: LetterType
}

class LetterTypeClassificationTests: XCTestCase {
    private let textManager = TextRecognizerManager()
    private var bitmap: NSBitmapImageRep!
    private let numberOfIterations = 30
    fileprivate var newDicionary: [LetterRectangle: Answer] = [:]
    fileprivate var dictionary: [String: LetterRectangle] = [:]

    override func setUp() {
        let image = NSImage(named: .init("picLetterTypeClassificationWhite"))!
        guard let answers = CodableHelper.decode(self,
                                                path: "letter_type_classification",
                                                structType: [Answer].self) else { return }
        //FIXME
//        textManager.performRequest(image: image) { [weak self] (bitmap, words, _) in
//            for (index, letter) in words[0].letters.enumerated() {
//
//                self?.bitmap = bitmap
//                let currentAnswer = answers[index]
//                self?.newDicionary[letter] = currentAnswer
//                self?.dictionary[currentAnswer.letter] = letter
//                print("✔️ \(currentAnswer.letter) == \(letter.frame)")
//            }
//        }
    }
    
    override func tearDown() {
        newDicionary.removeAll()
    }
    
    /*
     * Тестируем нахождение типа самой маленькой буквы, в слове, чтобы на основе него построить все остальное
     */
    func testLetterType() {
        for _ in 0...numberOfIterations {
            let wordDescription = getRandomString
            checkLetterType(with: wordDescription)
        }
    }
    
    /*
     * Метод нужен для того чтобы простестировать конкретное слово
     */
    //YTL4
    func testLetterTypeFromCurrentWords() {
        let array = ["$}/)"]
        array.forEach {
            print("TestUndefinedCurrentWords \($0)")
            checkLetterType(with: $0)
        }
    }

    private func checkLetterType(with wordDescription: String) {
        var wordDescription = wordDescription
        let size = wordDescription.count
        for index in 0..<size {
            //меньше трех не рассматриваем
            let lastLetter = index == size - 1
            let letters = wordDescription.compactMap { dictionary[String($0)] }
            guard !letters.isEmpty,
                let (type, letter) = letterAndType(using: letters),
                !lastLetter else { break }
            
            let answer = newDicionary[letter]!
            let rightAnswerDescription = "🔔 char '\(answer.letter)', word: '\(wordDescription)'"
            print("\(rightAnswerDescription)")
            print("size \(size), index \(index), isLastLetter \(lastLetter)")
            XCTAssertTrue(answer.type == type, "✅\(answer.type)✅ -- ❌\(type)❌, \(rightAnswerDescription)")
            wordDescription = removed(character: answer.letter, from: wordDescription)
        }
    }
    
    private func removed(character: String, from word: String) ->  String {
        var word = word
        guard let range = word.range(of: character) else { return word }
        word.removeSubrange(range)
        return word
    }
    
    private func letterAndType(using letters: [LetterRectangle]) -> (LetterType, LetterRectangle)? {
        let word = Word.from(letters)
        let currentTestLetter = word.letterWithMinHeight!
        
        let classification = newClassification(for: word)
        let type = classification.testDetectType(for: LetterRectangle(rect: currentTestLetter), in: letters)
        let letter = LetterRectangle(rect: currentTestLetter)
        return (type, letter)
    }
    
    private var randomSize: Int {
       return (2..<newDicionary.count).randomElement()!
    }
    
    private var getRandomString: String {
        return newDicionary.map { $0.value.letter }.shuffled().prefix(randomSize).joined()
    }

    private func newClassification(for word: Word<LetterRectangle>) -> LetterTypeIdentifier {
        let information = WordInformation(max: word.letterWithMaxHeight!,
                                          lowerY: word.letterLowerY!,
                                          word: word)
        let recognizer = LetterRecognizer(bitmap, rectangle: word)
        return LetterTypeIdentifier(information: information, recognizer: recognizer)
    }
}


