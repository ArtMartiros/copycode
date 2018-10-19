//
//  TextTranscriptorTests.swift
//  CopyCodeTests
//
//  Created by Артем on 16/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

class TextTranscriptorTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

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
    
//    func test() {
//        let block = Scene.sc11.getGridBlock(self)
//        guard case .grid(let grid) = block.typography else { return }
//        let letter = block.lines[2].words[0].letters[3]
//        let restorer = LetterRestorer(bitmap: <#NSBitmapImageRep#>)
//        let letters = restorer.unstuckLetter(from: letter, tracking: grid.trackingData[letter.frame.bottomY])
//        print("sdd")
//    }
}
