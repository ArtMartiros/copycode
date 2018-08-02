//
//  ProtoWordTests.swift
//  CopyCodeTests
//
//  Created by Артем on 20/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest
@testable import CopyCode

class ProtoWordTests: XCTestCase {
    let textManager = TextRecognizerManager()
    let rectanglesConverter = WordRectangleWithTypeConverter()
    let images  = ["picAllLow", "picAllLowWithTail", "picAllUpper",
                   "picMix1", "picMix2", "picMix3", "picMix4", "picMix5"]
    
    var wordTypes: [WordType] = [.same(type: .allLower), .same(type: .allLowWithTail),
                                 .same(type: .allUpper), .mix, .mix, .mix, .mix, .mix]


    func testExample() {
        let protoWords = rectanglesConverter.convert(rectangles)
        //две ошибки picMix5 из-за i и picAllLowWithTail из-за того что нет возможности обнаружить bottom line
        for (index, word) in protoWords.enumerated() {
            XCTAssertTrue( word.type == self.wordTypes[index], "❌ expect: \(self.wordTypes[index].description), instead \(word.type.description)")
        }
    }
    
    func testLetterType() {
        let image = NSImage(named: .init("picLetters"))!
        let letterTypes: [LetterType] = [.low, .low, .upper, .upper, .upper, .upper,
                                     .lowWithTail, .upper, .upper, .lowWithTail,
                                     .lowWithTail, .upper, .upper, .upper, .upper, .upper, .upper, .upper ]
        textManager.performRequestExtended(image: image) { (bitmap, words, error) in
            //под пятым номером буква i
            for word in words {
                for (index, letter) in word.letters.enumerated() {
                    XCTAssertTrue( letter.type == letterTypes[index],
                                   "❌ expect: \(letterTypes[index].rawValue) at index \(index), instead \(letter.type.rawValue)")
                }
            }
        }
    }
    
   private var rectangles: [Word<LetterRectangle>] {
        var wordRectangles: [Word<LetterRectangle>] = []
        for (index, item) in images.enumerated() {
            let image = NSImage(named: .init(item))!
            wordRectangles.append(contentsOf: getDetectedRectangles(from: image))
        }
        return wordRectangles
    }
    
   private func getDetectedRectangles(from image: NSImage) -> [Word<LetterRectangle>] {
        var wordRectangles: [Word<LetterRectangle>] = []
        textManager.performRequest(image: image) { (bitmap, rectangles, error) in
            wordRectangles = rectangles
        }
        return wordRectangles
    }

}
