//
//  CopyCodeTests.swift
//  CopyCodeTests
//
//  Created by Артем on 18/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest
@testable import CopyCode

struct Detection {
    let image: NSImage
    let answers: [An]
    
    init(imageName: String, answer: String, type: LetterType) {
        self.image = NSImage(named: .init(imageName))!
        self.answers = Array(answer).map { An(String($0), t: type) }
    }
    init(imageName: String, answers: [An]) {
        self.image = NSImage(named: .init(imageName))!
        self.answers = answers
    }
}

struct An {
    let value: String
    let type: LetterType
    init(_ value: String, t: LetterType) {
        self.value = value
        self.type = t
    }
}

class LetterTests: XCTestCase {
    let textManager = TextRecognizerManager()
    lazy var testCases = [Detection(imageName: "picAlphabetUpperSD", answer: "ABCDEFGHIJKLMNOPQRSTU*XYZ", type: .upper),
                          Detection(imageName: "picAlphabetUpperHD", answer: "ABCDEFGHIJKLMNOPQRSTUVWXYZ", type: .upper),
                                  Detection(imageName: "picAlphabetLowSD", answers: answersForLowerCase),
                                  Detection(imageName: "picAlphabetLowHD", answers: answersForLowerCase),
                                  Detection(imageName: "picNumericSD", answer: "1234567890", type: .upper),
                                  Detection(imageName: "picNumericHD", answer: "1234567890", type: .upper)]
    var answersForLowerCase = [ An("a", t: .low), An("b", t: .upper), An("c", t: .low), An("d", t: .upper), An("e", t: .low),
                                An("f", t: .upper), An("g", t: .lowWithTail), An("h", t: .upper), An("i", t: .low), An("j", t: .lowWithTail),
                                An("k", t: .upper), An("l", t: .upper), An("m", t: .low), An("n", t: .low), An("o", t: .low),
                                An("p", t: .lowWithTail), An("q", t: .lowWithTail), An("r", t: .low), An("s", t: .low), An("t", t: .upper),
                                An("u", t: .low), An("v", t: .low), An("w", t: .low), An("x", t: .low), An("y", t: .lowWithTail),
                                An("z", t: .low)]
    
    func testUppercaseSD() {
        check(testCase: testCases[0])
    }
    
    func testUppercaseHD() {
        check(testCase: testCases[1])
    }
    
    func testLowercaseSD() {
        check(testCase: testCases[2])
    }
    
    func testLowercaseHD() {
        check(testCase: testCases[3])
    }

    
    func testNumericSD() {
        check(testCase: testCases[4])
    }
    
    func testNumericHD() {
        check(testCase: testCases[5])
    }
    
    private func check(testCase: Detection) {
        let image = ImageDrawer(image: testCase.image).preparedImage
        textManager.performRequest(image: image) { (bitmap, results, error) in
            let rectangle = results[0]
            let letterRecognizer = LetterRecognizer(bitmap, rectangle: rectangle)
            for (index, letter) in rectangle.letters.enumerated() where letter is LetterRectangle  {
                let test = testCase.answers[index]
                let char = letterRecognizer.recognize(from: letter as! LetterRectangle, with: test.type)
                let rightChar = test.value
                print("🔔:" + rightChar)
                XCTAssertTrue(char.value == rightChar, "❌ expect: \(rightChar), instead \(char.value)")
            }
            print("Letters count \(rectangle.letters.count)")
        }
    }
    
    func testPerformanceExample() {
        let testCase = testCases[2]
        let image = ImageDrawer(image: testCase.image).preparedImage
        textManager.performRequest(image: image) { (bitmap, results, error) in
            self.measure {
                let rectangle = results[0]
                let letterRecognizer = LetterRecognizer(bitmap, rectangle: rectangle)
                for (index, letter) in rectangle.letters.enumerated() where letter is LetterRectangle  {
                    let test = testCase.answers[index]
                    _ = letterRecognizer.recognize(from: letter as! LetterRectangle, with: test.type)
                }
            } 
        }
    }
    
    //эта хрень просто для теста нужна
    typealias Action = (Int, Int) -> Int
    private func checkPerPixel(in bitmap: NSBitmapImageRep, x: Int, y: Int, xAction: Action, yAction: Action) {
        
                        for i in 0..<100 { // for 0 to 9 .
                            let xt = xAction(x, i)
                            for j in 0..<100 {
                                let yt = yAction(y, j)
                                let color = bitmap.colorAt(x: xt, y: yt)
                                let color1 = color?.usingColorSpace(NSColorSpace.deviceGray)
                                var grayscale: CGFloat = 0
                                var alpha: CGFloat = 0
                                color1?.getWhite(&grayscale, alpha: &alpha)
                                print("Pos x: \(xt), y: \(yt) grayscale: \(grayscale.rounded(toPlaces: 3))")
                            }
                }
    }


}
