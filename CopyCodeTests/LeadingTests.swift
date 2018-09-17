//
//  LeadingTests.swift
//  CopyCodeTests
//
//  Created by Артем on 16/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

class LeadingTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    let frame = CGRect(x: 341.433962264151, y: 43.0, width: 463.566037735849, height: 790.0)
    let leading = Leading(fontSize: 13, lineSpacing: 4, startPointTop: 171.5)
    
    func testMissingLines() {
       let block =  CodableHelper.decode(self, path: "block_one_completed", structType: CompletedBlock.self, shouldPrint: false)
        let newFrames = leading.missingLinesFrame(in: block!.frame)
//        XCTAssertTrue(testRange.intesected(with: range) != nil, message)
        print("")
    }

    func testStartPoint() {
        
        let point = leading.findStartPoint(inside: frame)
        //        XCTAssertTrue(testRange.intesected(with: range) != nil, message)
        print("")
    }
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
