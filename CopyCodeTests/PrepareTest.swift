//
//  PrepareTest.swift
//  CopyCodeTests
//
//  Created by Артем on 27/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

class PrepareTest: XCTestCase {

    func testExample() {
        let scene = Scene.sc18
        let isLow = false
        let words = scene.getRects(self, low: isLow)
        let bitmap = scene.getImage(isLow: isLow).bitmap
        
        let textRecognizer = TextRecognizerManager()
        textRecognizer.completedBlocks(from: words, with: bitmap, retina: !isLow)
    }
}
