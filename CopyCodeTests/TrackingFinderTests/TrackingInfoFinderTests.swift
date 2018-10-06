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
    
    func testBlockOne() {
        let answer = Answer(currentIndex: 1, count: 2, startIndex: 2, endIndex: 36)
        check(.one, with: answer)
    }
    
    func testBlockTwo() {
        let answer = Answer(currentIndex:2, count: 3, startIndex: 3, endIndex: 34)
        check(.two, with: answer)
    }
    
    func testBlockWithComments() {
        let answer = Answer(currentIndex: 4, count: 5, startIndex: 4, endIndex: 34)
        check(.comments, with: answer)
    }

    func testSc1() {
        let answer = Answer(currentIndex: 2, count: 3, startIndex: 4, endIndex: 34)
        check(.sc1, with: answer)
    }
    
    func testSc2() {
        let answer = Answer(currentIndex: 2, count: 3, startIndex: 4, endIndex: 34)
        check(.sc2, with: answer)
    }
    
    private func check(_ blockTest: BlockTest, with answer: Answer) {
        let block = blockTest.getBlock(self)
        let results = finder.find(from: block)
        let value = CodableHelper.encode(results)
        print(value)
        let message0 = "Current results count \(results.count) not equal to \(answer.count)"
        XCTAssertTrue(results.count == answer.count, message0)
        let result = results[answer.currentIndex]
        let message1 = "Current startIndex \(result.startIndex) not equal to \(answer.startIndex)"
        let message2 = "Current endIndex \(result.endIndex) not equal to \(answer.endIndex)"
        XCTAssertTrue(result.startIndex == answer.startIndex, message1)
        XCTAssertTrue(result.endIndex == answer.endIndex, message2)
    }
    
    func testPerformanceExample() {
        let block = BlockTest.one.getBlock(self)
        self.measure {
            let _ = finder.find(from: block)
        }
    }
}
