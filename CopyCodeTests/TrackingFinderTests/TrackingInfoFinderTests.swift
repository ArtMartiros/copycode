//
//  TrackingInfoFinderTests.swift
//  CopyCodeTests
//
//  Created by Артем on 06/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

private struct Answer {
    let currentIndex: Int
    let count: Int
    let startIndex: Int
    let endIndex: Int
}

class TrackingInfoFinderTests: XCTestCase {

    let finder = TrackingInfoFinder()
    private let answers: [Answer] = [Answer(currentIndex: 1, count: 2, startIndex: 2, endIndex: 36),
                                     Answer(currentIndex: 2, count: 4, startIndex: 3, endIndex: 32)]
    
    func testFindTrackingInfos() {
        let blocks = BlockTestHelper.getBlocks(self)

        //во втором блоке после коммента идет все по пизде, так как визион немного смещает комменты
        for (index, block) in blocks.enumerated() {
            let answer = answers[index]
            let results = finder.find(from: block)
            let message0 = "Current results count \(results.count) not equal to \( answer.count) at block number: \(index)"
            XCTAssertTrue(results.count == answer.count, message0)
            let result = results[answer.currentIndex]
            let message1 = "Current startIndex \(result.startIndex) not equal to \(answer.startIndex) at block number: \(index)"
            let message2 = "Current endIndex \(result.endIndex) not equal to \(answer.endIndex) at block number: \(index)"
            XCTAssertTrue(result.startIndex == answer.startIndex, message1)
            XCTAssertTrue(result.endIndex == answer.endIndex, message2)
        }


    }
    
    func testPerformanceExample() {
        let blocks = BlockTestHelper.getBlocks(self)
        self.measure {
            let _ = finder.find(from: blocks[1])
        }
    }
}
