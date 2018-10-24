//
//  TextTranscriptorTests.swift
//  CopyCodeTests
//
//  Created by Артем on 16/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

class TextTranscriptorTests: XCTestCase {

    func testExample() {
        let block =  CodableHelper.decode(self, path: "block_one_completed", structType: CompletedBlock.self, shouldPrint: false)
        let transcriptor = TextTranscriptor()
        let thing = transcriptor.transcript(block: block!)
        print(thing)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testSc11Stuck() {
        let block = Scene.sc11.getCompletedWithStuck(self)
        let transcriptor = TextTranscriptor()
        let thing = transcriptor.transcript(block: block)
        print(thing)
    }

}
