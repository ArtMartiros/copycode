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

//все проходит
class TrackingInfoFinderTests: XCTestCase {
    
    let finder = TrackingInfoFinder()
    let formatter = TrackingInfoFormatter()

    func testSc1() {
        let answers = [Answer(start: 2, end: 4), Answer(start: 6, end: 6),
                       Answer(start: 8, end: 9), Answer(start: 11, end: 17),
                       Answer(start: 18, end: 19), Answer(start: 20, end: 28)]
        let index = 2
        let chunked = getChunked(.sc1, isLow: false)
        for (answerIndex, answer) in answers.enumerated() {
            let current = chunked[index][answerIndex]
            XCTAssertTrue(current.startIndex == answer.start, "start: \(current.startIndex) != answer: \(answer.start)")
            XCTAssertTrue(current.endIndex == answer.end, "end: \(current.endIndex) != answer: \(answer.end)")
        }
    }


    func testSc2() {
        let answers = [Answer(start: 2, end: 22)]
        let index = 2
        let chunked = getChunked(.sc2, isLow: false)
        for (answerIndex, answer) in answers.enumerated() {
            let current = chunked[index][answerIndex]
            XCTAssertTrue(current.startIndex == answer.start, "start: \(current.startIndex) != answer: \(answer.start)")
            XCTAssertTrue(current.endIndex == answer.end, "end: \(current.endIndex) != answer: \(answer.end)")
        }
    }

    func testSc3_p1() {
        let answers = [Answer(start: 3, end: 47)]
        let index = 1
        let chunked = getChunked(.sc3_p1, isLow: false)
        for (answerIndex, answer) in answers.enumerated() {
            let current = chunked[index][answerIndex]
            XCTAssertTrue(current.startIndex == answer.start, "start: \(current.startIndex) != answer: \(answer.start)")
            XCTAssertTrue(current.endIndex == answer.end, "end: \(current.endIndex) != answer: \(answer.end)")
        }
    }

    func testSc11() {
        let answers = [Answer(start: 6, end: 6), Answer(start: 7, end: 7),
                       Answer(start: 8, end: 9), Answer(start: 10, end: 15)]
        let index = 3
        let chunked = getChunked(.sc11, isLow: false)
        for (answerIndex, answer) in answers.enumerated() {
            let current = chunked[index][answerIndex]
            XCTAssertTrue(current.startIndex == answer.start, "start: \(current.startIndex) != answer: \(answer.start)")
            XCTAssertTrue(current.endIndex == answer.end, "end: \(current.endIndex) != answer: \(answer.end)")
        }
    }

    func testSc11_low() {
        let answers = [Answer(start: 6, end: 6), Answer(start: 7, end: 7),
                       Answer(start: 8, end: 9), Answer(start: 10, end: 15)]
        let index = 3
        let chunked = getChunked(.sc11, isLow: true)
        for (answerIndex, answer) in answers.enumerated() {
            let current = chunked[index][answerIndex]
            XCTAssertTrue(current.startIndex == answer.start, "start: \(current.startIndex) != answer: \(answer.start)")
            XCTAssertTrue(current.endIndex == answer.end, "end: \(current.endIndex) != answer: \(answer.end)")
        }
    }

    func testSc14() {
        let chuncked = getChunked(.sc14, isLow: false)
        let current = chuncked[1][0]
        XCTAssertTrue(current.startIndex == 1, "start: \(current.startIndex) != answer: \(1)")
        XCTAssertTrue(current.endIndex == 11, "end: \(current.endIndex) != answer: \(11)")
    }

    func testSc15() {
        let chuncked = getChunked(.sc15, isLow: false)
        let current = chuncked[3][0]
        XCTAssertTrue(current.startIndex == 4, "start: \(current.startIndex) != answer: \(4)")
        XCTAssertTrue(current.endIndex == 11, "end: \(current.endIndex) != answer: \(11)")
    }

    func testSc22() {
        let answers = [Answer(start: 5, end: 5), Answer(start: 6, end: 6),
                       Answer(start: 8, end: 8), Answer(start: 10, end: 10),
                       Answer(start: 12, end: 12), Answer(start: 14, end: 14),
                       Answer(start: 16, end: 16)]
        let chunked = getChunked(.sc22, isLow: false)
        let index = 3
        for (answerIndex, answer) in answers.enumerated() {
            let current = chunked[index][answerIndex]
            XCTAssertTrue(current.startIndex == answer.start, "start: \(current.startIndex) != answer: \(answer.start)")
            XCTAssertTrue(current.endIndex == answer.end, "end: \(current.endIndex) != answer: \(answer.end)")
        }
    }

    private func getChunked(_ scene: Scene, isLow: Bool) -> [[TrackingInfo]] {
        let block = scene.getBlock(low: isLow)
        let infos = finder.find(from: block)
        let chunked = formatter.chunk(infos, with: block)
        return chunked
    }
}
