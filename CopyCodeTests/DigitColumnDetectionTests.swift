//
//  DigitColumnDetectionTests.swift
//  CopyCodeTests
//
//  Created by Артем on 14/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

class DigitColumnDetectionTests: XCTestCase {
    
    func testSc3_p2() {
        execute(scene: .sc3_p2, answers: [false])
    }
    
    func testSc6() {
        execute(scene: .sc6, answers: [true])
    }
    
    func testSc7() {
        execute(scene: .sc7, answers: [true])
    }
    
    func testSc8() {
        execute(scene: .sc8, answers: [true, true])
    }
    
    func testSc10() {
        execute(scene: .sc10, answers: [true, false])
    }
    
    private func execute(scene: Scene, answers: [Bool]) {
        let bitmap = scene.getImage(isLow: false).bitmap
        let detection = DigitColumnDetection(in: bitmap)
        let wordsArray = scene.gePreDigitColumnWords(self)
        for (index, words) in wordsArray.enumerated() {
            let result = detection.detect(words)
            if answers[index] {
                XCTAssert(result != nil)
            } else {
                XCTAssert(result == nil)
            }
            
        }
    }
    
}
