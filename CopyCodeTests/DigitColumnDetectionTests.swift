//
//  DigitColumnDetectionTests.swift
//  CopyCodeTests
//
//  Created by Артем on 14/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

class DigitColumnDetectionTests: XCTestCase {

    func testSc6() {
        execute(scene: .sc6)
    }
    
    func testSc7() {
        execute(scene: .sc7)
    }
    
    func testSc8() {
        execute(scene: .sc8)
    }
    
    private func execute(scene: Scene) {
        let bitmap = scene.image.bitmap
        let detection = DigitColumnDetection(in: bitmap)
        PixelConverter.shared.setSize(size: bitmap.size, pixelSize: bitmap.pixelSize)
        let wordsArray = scene.gePreDigitColumnWords(self)
        for words in wordsArray {
            let result = detection.detect(words)
            XCTAssertNotNil(result)
        }
    }
    
}
