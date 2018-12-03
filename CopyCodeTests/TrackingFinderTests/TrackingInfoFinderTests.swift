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
    private let blockSplitter = BlockCreator.BlockSplitter()

    func testSc1() {
        let answers = [Answer(start: 2, end: 28)]
        let info = getChunked(.sc1, isLow: false, position: 2)
        for (answerIndex, answer) in answers.enumerated() {
            let current = info[answerIndex]
            XCTAssertTrue(current.startIndex == answer.start, "start: \(current.startIndex) != answer: \(answer.start)")
            XCTAssertTrue(current.endIndex == answer.end, "end: \(current.endIndex) != answer: \(answer.end)")
        }
    }


    func testSc2() {
        let answers = [Answer(start: 2, end: 22)]
        let info = getChunked(.sc2, isLow: false, position: 2)
        for (answerIndex, answer) in answers.enumerated() {
            let current = info[answerIndex]
            XCTAssertTrue(current.startIndex == answer.start, "start: \(current.startIndex) != answer: \(answer.start)")
            XCTAssertTrue(current.endIndex == answer.end, "end: \(current.endIndex) != answer: \(answer.end)")
        }
    }

    func testSc3_p1() {
        let answers = [Answer(start: 3, end: 46)]
        let info = getChunked(.sc3_p1, isLow: false, position: 1)
        for (answerIndex, answer) in answers.enumerated() {
            let current = info[answerIndex]
            XCTAssertTrue(current.startIndex == answer.start, "start: \(current.startIndex) != answer: \(answer.start)")
            XCTAssertTrue(current.endIndex == answer.end, "end: \(current.endIndex) != answer: \(answer.end)")
        }
    }

    func testSc6() {
        let answers = [Answer(start: 2, end: 22)]
        let info = getChunked(.sc6, isLow: false, position: 2)
        for (answerIndex, answer) in answers.enumerated() {
            let current = info[answerIndex]
            XCTAssertTrue(current.startIndex == answer.start, "start: \(current.startIndex) != answer: \(answer.start)")
            XCTAssertTrue(current.endIndex == answer.end, "end: \(current.endIndex) != answer: \(answer.end)")
        }
    }

    func testSc11() {
        let answers = [Answer(start: 6, end: 6), Answer(start: 7, end: 7),
                       Answer(start: 8, end: 9), Answer(start: 10, end: 15)]
        let info = getChunked(.sc11, isLow: false, position: 3)
        for (answerIndex, answer) in answers.enumerated() {
            let current = info[answerIndex]
            XCTAssertTrue(current.startIndex == answer.start, "start: \(current.startIndex) != answer: \(answer.start)")
            XCTAssertTrue(current.endIndex == answer.end, "end: \(current.endIndex) != answer: \(answer.end)")
        }
    }

    func testSc11_low() {
        let answers = [Answer(start: 6, end: 6), Answer(start: 7, end: 7),
                       Answer(start: 8, end: 9), Answer(start: 10, end: 15)]
        let info = getChunked(.sc11, isLow: true, position: 3)
        for (answerIndex, answer) in answers.enumerated() {
            let current = info[answerIndex]
            XCTAssertTrue(current.startIndex == answer.start, "start: \(current.startIndex) != answer: \(answer.start)")
            XCTAssertTrue(current.endIndex == answer.end, "end: \(current.endIndex) != answer: \(answer.end)")
        }
    }

    func testSc14() {
        let chuncked = getChunked(.sc14, isLow: false, position: 1)
        let current = chuncked[0]
        XCTAssertTrue(current.startIndex == 1, "start: \(current.startIndex) != answer: \(1)")
        XCTAssertTrue(current.endIndex == 11, "end: \(current.endIndex) != answer: \(11)")
    }

    func testSc15() {
        let chuncked = getChunked(.sc15, isLow: false, position: 3)
        let current = chuncked[0]
        XCTAssertTrue(current.startIndex == 4, "start: \(current.startIndex) != answer: \(4)")
        XCTAssertTrue(current.endIndex == 11, "end: \(current.endIndex) != answer: \(11)")
    }

    func testSc22() {
        let answers = [Answer(start: 5, end: 16)]
        let info = getChunked(.sc22, isLow: false, position: 3)
        for (answerIndex, answer) in answers.enumerated() {
            let current = info[answerIndex]
            XCTAssertTrue(current.startIndex == answer.start, "start: \(current.startIndex) != answer: \(answer.start)")
            XCTAssertTrue(current.endIndex == answer.end, "end: \(current.endIndex) != answer: \(answer.end)")
        }
    }

    func testSc23() {
        let answers = [Answer(start: 6, end: 18)]
        let info = getChunked(.sc23, isLow: false, position: 3)
        for (answerIndex, answer) in answers.enumerated() {
            let current = info[answerIndex]
            XCTAssertTrue(current.startIndex == answer.start, "start: \(current.startIndex) != answer: \(answer.start)")
            XCTAssertTrue(current.endIndex == answer.end, "end: \(current.endIndex) != answer: \(answer.end)")
        }
    }

    func testSc27() {
        let answers = [Answer(start: 6, end: 9), Answer(start: 10, end: 11), Answer(start: 12, end: 18)]
        let info = getChunked(.sc27, isLow: false, position: 3)
        for (answerIndex, answer) in answers.enumerated() {
            let current = info[answerIndex]
            XCTAssertTrue(current.startIndex == answer.start, "start: \(current.startIndex) != answer: \(answer.start)")
            XCTAssertTrue(current.endIndex == answer.end, "end: \(current.endIndex) != answer: \(answer.end)")
        }
    }

    func testSc28() {
        let answers = [Answer(start: 4, end: 13), Answer(start: 14, end: 14)]
        let info = getChunked(.sc28, isLow: false, position: 1)
        for (answerIndex, answer) in answers.enumerated() {
            let current = info[answerIndex]
            XCTAssertTrue(current.startIndex == answer.start, "start: \(current.startIndex) != answer: \(answer.start)")
            XCTAssertTrue(current.endIndex == answer.end, "end: \(current.endIndex) != answer: \(answer.end)")
        }
    }


    private func getChunked(_ scene: Scene, isLow: Bool, position: Int = 0) -> [TrackingInfo] {
        let block = scene.getBlock(low: isLow)
        let infos = finder.find(from: block)
        let chunked = formatter.chunk(infos, with: block)
        let selectedInfos = chunked[position]
        let result = update(selectedInfos, at: block)
        return result
    }

   private func update(_ infos: [TrackingInfo], at block: SimpleBlock) -> [TrackingInfo] {
        var infos = infos
        let last = infos.removeLast()
        let updatedLast = updateEndIndex(for: last, at: block)
        infos.append(updatedLast)
        return infos
    }

   private func updateEndIndex(for info: TrackingInfo, at block: SimpleBlock) -> TrackingInfo {
        var count = 0
        var info = info
        for lineIndex in Array(info.startIndex...info.endIndex).reversed() {
           let words = info.findWords(in: block, lineIndex: lineIndex, type: .allowed, restrictedAt: [.horizontal])
            if words.isEmpty {
                count += 1
            } else {
                info.endIndex -= count
                return info
            }
        }
        return info
    }
}
