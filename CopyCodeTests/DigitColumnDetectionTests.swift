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
        let scene = Scene.sc6
        let bitmap = scene.image.bitmap
        
        let detection = DigitColumnDetection(in: bitmap)
        PixelConverter.shared.setSize(size: bitmap.size, pixelSize: bitmap.pixelSize)
        let words = scene.gePreDigitColumnWords(self)
        let result = detection.detect(words)
        XCTAssertNotNil(result)
    }
}
