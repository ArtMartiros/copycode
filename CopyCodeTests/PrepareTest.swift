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
        let scene = Scene.sc1

        let textRecognizer = TextRecognizerManager()
        textRecognizer.performRequest(image: scene.lowImage.toCGImage) { (_, block, _) in
            
        }
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
