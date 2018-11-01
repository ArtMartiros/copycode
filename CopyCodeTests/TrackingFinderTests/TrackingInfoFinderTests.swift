//
//  TrackingInfoFinderTests.swift
//  CopyCodeTests
//
//  Created by Артем on 06/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

private struct Answer {
    let start: Int
    let end: Int
}

class TrackingInfoFinderTests: XCTestCase {
    
    let finder = TrackingInfoFinder()
    let formatter = TrackingInfoFormatter()
//
//    func testBlockOne() {
//        let answers = [Answer(start: 2, end: 36)]
//        let index = 1
//        let chunked = getChucked(.block_one)
//        for (answerIndex, answer) in answers.enumerated() {
//            let current = chunked[index][answerIndex]
//            XCTAssertTrue(current.startIndex == answer.start, "start: \(current.startIndex) != answer: \(answer.start)")
//            XCTAssertTrue(current.endIndex == answer.end, "end: \(current.endIndex) != answer: \(answer.end)")
//        }
//    }
//
//    func testBlockTwo() {
//        let answers = [Answer(start: 3, end: 34)]
//        let index = 2
//        let chunked = getChucked(.block_two)
//        for (answerIndex, answer) in answers.enumerated() {
//            let current = chunked[index][answerIndex]
//            XCTAssertTrue(current.startIndex == answer.start, "start: \(current.startIndex) != answer: \(answer.start)")
//            XCTAssertTrue(current.endIndex == answer.end, "end: \(current.endIndex) != answer: \(answer.end)")
//        }
//    }
//
//    func testBlockWithComments() {
//        let answers = [Answer(start: 4, end: 13), Answer(start: 14, end: 24), Answer(start: 25, end: 34)]
//        let index = 4
//        let chunked = getChucked(.block_with_comments)
//        for (answerIndex, answer) in answers.enumerated() {
//            let current = chunked[index][answerIndex]
//            XCTAssertTrue(current.startIndex == answer.start, "start: \(current.startIndex) != answer: \(answer.start)")
//            XCTAssertTrue(current.endIndex == answer.end, "end: \(current.endIndex) != answer: \(answer.end)")
//        }
//    }

    func testSc1() {
        let answers = [Answer(start: 2, end: 4), Answer(start: 6, end: 8),
                       Answer(start: 10, end: 16), Answer(start: 17, end: 18),
                       Answer(start: 19, end: 27)]
        let index = 1
        let chunked = getChucked(.sc1, isLow: false)
        for (answerIndex, answer) in answers.enumerated() {
            let current = chunked[index][answerIndex]
            XCTAssertTrue(current.startIndex == answer.start, "start: \(current.startIndex) != answer: \(answer.start)")
            XCTAssertTrue(current.endIndex == answer.end, "end: \(current.endIndex) != answer: \(answer.end)")
        }
    }


    func testSc2() {
        let answers = [Answer(start: 2, end: 22)]
        let index = 2
        let chunked = getChucked(.sc2, isLow: false)
        for (answerIndex, answer) in answers.enumerated() {
            let current = chunked[index][answerIndex]
            XCTAssertTrue(current.startIndex == answer.start, "start: \(current.startIndex) != answer: \(answer.start)")
            XCTAssertTrue(current.endIndex == answer.end, "end: \(current.endIndex) != answer: \(answer.end)")
        }
    }

    func testSc3_p1() {
        let answers = [Answer(start: 3, end: 47)]
        let index = 1
        let chunked = getChucked(.sc3_p1, isLow: false)
        for (answerIndex, answer) in answers.enumerated() {
            let current = chunked[index][answerIndex]
            XCTAssertTrue(current.startIndex == answer.start, "start: \(current.startIndex) != answer: \(answer.start)")
            XCTAssertTrue(current.endIndex == answer.end, "end: \(current.endIndex) != answer: \(answer.end)")
        }
    }

    func testSc11() {
        let answers = [Answer(start: 2, end: 4), Answer(start: 6, end: 8),
                       Answer(start: 10, end: 16), Answer(start: 17, end: 18),
                       Answer(start: 19, end: 27)]
        let index = 1
        let chunked = getChucked(.sc11, isLow: false)
        for (answerIndex, answer) in answers.enumerated() {
            let current = chunked[index][answerIndex]
            XCTAssertTrue(current.startIndex == answer.start, "start: \(current.startIndex) != answer: \(answer.start)")
            XCTAssertTrue(current.endIndex == answer.end, "end: \(current.endIndex) != answer: \(answer.end)")
        }
    }

    func testSc11_low() {
        let answers = [Answer(start: 2, end: 4), Answer(start: 6, end: 8),
                       Answer(start: 10, end: 16), Answer(start: 17, end: 18),
                       Answer(start: 19, end: 27)]
        let index = 1
        let chunked = getChucked(.sc11, isLow: true)
        for (answerIndex, answer) in answers.enumerated() {
            let current = chunked[index][answerIndex]
            XCTAssertTrue(current.startIndex == answer.start, "start: \(current.startIndex) != answer: \(answer.start)")
            XCTAssertTrue(current.endIndex == answer.end, "end: \(current.endIndex) != answer: \(answer.end)")
        }
    }

    private func getChucked(_ scene: Scene, isLow: Bool) -> [[TrackingInfo]] {
        let block = scene.getBlock(self, low: isLow)
        let infos = finder.find(from: block)
        let chunked = formatter.chunk(infos, with: block)
        return chunked
    }
}
