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

    func testSc1() {
        let answers = [Answer(start: 2, end: 4), Answer(start: 6, end: 6),
                       Answer(start: 8, end: 9), Answer(start: 11, end: 17),
                       Answer(start: 19, end: 27)]
        let index = 1
        let chunked = getChuncked(.sc1, isLow: false)
        for (answerIndex, answer) in answers.enumerated() {
            let current = chunked[index][answerIndex]
            XCTAssertTrue(current.startIndex == answer.start, "start: \(current.startIndex) != answer: \(answer.start)")
            XCTAssertTrue(current.endIndex == answer.end, "end: \(current.endIndex) != answer: \(answer.end)")
        }
    }


    func testSc2() {
        let answers = [Answer(start: 2, end: 22)]
        let index = 2
        let chunked = getChuncked(.sc2, isLow: false)
        for (answerIndex, answer) in answers.enumerated() {
            let current = chunked[index][answerIndex]
            XCTAssertTrue(current.startIndex == answer.start, "start: \(current.startIndex) != answer: \(answer.start)")
            XCTAssertTrue(current.endIndex == answer.end, "end: \(current.endIndex) != answer: \(answer.end)")
        }
    }

    func testSc3_p1() {
        let answers = [Answer(start: 3, end: 47)]
        let index = 1
        let chunked = getChuncked(.sc3_p1, isLow: false)
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
        let chunked = getChuncked(.sc11, isLow: false)
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
        let chunked = getChuncked(.sc11, isLow: true)
        for (answerIndex, answer) in answers.enumerated() {
            let current = chunked[index][answerIndex]
            XCTAssertTrue(current.startIndex == answer.start, "start: \(current.startIndex) != answer: \(answer.start)")
            XCTAssertTrue(current.endIndex == answer.end, "end: \(current.endIndex) != answer: \(answer.end)")
        }
    }

    func testSc15() {
        let chuncked = getChuncked(.sc15, isLow: false)
        let current = chuncked[3][0]
        XCTAssertTrue(current.startIndex == 4, "start: \(current.startIndex) != answer: \(4)")
        XCTAssertTrue(current.endIndex == 11, "end: \(current.endIndex) != answer: \(11)")
    }

    private func getChuncked(_ scene: Scene, isLow: Bool) -> [[TrackingInfo]] {
        let block = scene.getBlock(low: isLow)
        let infos = finder.find(from: block)
        let chunked = formatter.chunk(infos, with: block)
        return chunked
    }
}
