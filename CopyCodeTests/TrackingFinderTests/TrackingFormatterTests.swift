//
//  TrackingFormatterTests.swift
//  CopyCodeTests
//
//  Created by Артем on 27/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

class TrackingFormatterTests: XCTestCase {
    
    struct Answer {
        let start: Int
        let end: Int
    }
   
    let formatter = TrackingInfoFormatter()
    
//    func testSc1() {
//        let answers = [Answer(start: 2, end: 4), Answer(start: 6, end: 8),
//                       Answer(start: 10, end: 16), Answer(start: 17, end: 18),
//                       Answer(start: 19, end: 27)]
//        
//        let scene = Scene.sc1
//        let infos = scene.getTrackingInfos(self)
//        let block = scene.getBlock(low: false)
//        let chunked = formatter.chunk(infos, with: block)
//
//        XCTAssertTrue(chunked.count > 2, "Chunked must be more than 2")
//        let index = 1
//        XCTAssertTrue(chunked[index].count == 5, "Chunk must be == 5, not \(chunked[index].count)")
//        for (answerIndex, answer) in answers.enumerated() {
//            let current = chunked[index][answerIndex]
//
//            XCTAssertTrue(current.startIndex == answer.start,
//                          "startIndex: \(current.startIndex) != answer.start: \(answer.start)")
//            XCTAssertTrue(current.endIndex == answer.end,
//                          "endIndex: \(current.endIndex) != answer.end: \(answer.end)")
//        }
//    }

}
