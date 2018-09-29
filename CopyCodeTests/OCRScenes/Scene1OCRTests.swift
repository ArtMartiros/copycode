//
//  Scene1OCRTests.swift
//  CopyCodeTests
//
//  Created by Артем on 28/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

class Scene1OCRTests: XCTestCase {
    let textManager = TextRecognizerManager()

    func testExample() {
       let image = Scene.sc1.image
        textManager.performRequest(image: image) { (bitmap, blocks, _) in
            let blocks = blocks
            print("D")
        }
    }



}
