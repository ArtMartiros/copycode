//
//  TrackingDistanceFinderTests.swift
//  CopyCodeTests
//
//  Created by Артем on 06/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

class TrackingDistanceFinderTests: XCTestCase {

    let finder = TrackingDistanceFinder()
    
    func testFindFail() {
        let block = Scene.block_one.getBlock(low: false)
        let line = block.lines[0]
        let result = finder.find(from: line.biggestWord())
        switch result {
        case .failure: break
        case .success:
            XCTAssertTrue(false, "There is no success result")
        }
    }

    func testDistanceInBlock1() {
        let block = Scene.block_one.getBlock(low: false)
        //14 там всего один гап поэтому исключаем
        for (index, line) in block.lines.enumerated() where index > 1 && index != 14 {
            let result = finder.find(from: line.biggestWord())
            switch result {
            case .failure:
                XCTAssertTrue(false, "Can`t find gap at index \(index)")
            case .success(let range):
                let testRange: TrackingRange = 7.3...7.5
                let message = "Range: \(range), index \(index)\n"
                XCTAssertTrue(testRange.intesected(with: range) != nil, message)
            }
        }
    }
    
    func testDistanceInBlock2() {
        let exluded: Set<Int> = [0, 1, 2, 31, 34]
        let block = Scene.block_two.getBlock(low: false)
        //14 там всего один гап поэтому исключаем
        for (index, line) in block.lines.enumerated() where !exluded.contains(index) {
            let result = finder.find(from: line.biggestWord())
            switch result {
            case .failure:
                XCTAssertTrue(false, "Can`t find gap at index \(index)")
            case .success(let range):
                let testRange: TrackingRange = 7.3...7.5
                let message = "Range: \(range), index \(index)\n"
                XCTAssertTrue(testRange.intesected(with: range) != nil, message)
            }
        }
    }

    func testBlockComments() {
        let block = Scene.block_with_comments.getBlock(low: false)
        let line = block.lines[4]
        let word = line.words[0]
        let result = finder.find(from: word)
        switch result {
        case .failure:
            XCTAssertTrue(false, "Can`t find gap")
        case .success(let range):
            let testRange: TrackingRange = 7.45...7.5
            let message = "Range: \(range)\n"
            XCTAssertTrue(testRange.intesected(with: range) != nil, message)
        }
    }

    func testBlockTwoComments() {
        let block = Scene.block_two.getBlock(low: false)
        let line = block.lines[3]
        let word = line.words[0]
        let result = finder.find(from: word)
        switch result {
        case .failure:
            XCTAssertTrue(false, "Can`t find gap")
        case .success(let range):
            let testRange: TrackingRange = 7.45...7.5
            let message = "Range: \(range)\n"
            XCTAssertTrue(testRange.intesected(with: range) != nil, message)
        }
    }
    
    func testScene3_p1() {
        let block = Scene.sc3_p1.getBlock(low: false)
        let line = block.lines[3]
        let word = line.words[0]
        let result = finder.find(from: word)
        switch result {
        case .failure:
            XCTAssertTrue(false, "Can`t find gap")
        case .success(let range):
            let testRange: TrackingRange = 7.38...7.5
            let message = "Range: \(range)\n"
            XCTAssertTrue(testRange.intesected(with: range) != nil, message)
        }
    }
    
    func testScene3_p12() {
        let block = Scene.sc3_p1.getBlock(low: false)
        let line = block.lines[38]
        let word = line.words[2]
        let result = finder.find(from: word)
        switch result {
        case .failure:
            XCTAssertTrue(false, "Can`t find gap")
        case .success(let range):
            let testRange: TrackingRange = 7.38...7.5
            let message = "Range: \(range)\n"
            XCTAssertTrue(testRange.intesected(with: range) != nil, message)
        }
    }

    func testExample() {
        let block = Scene.block_two.getBlock(low: false)
        let line = block.lines[33]
        let result = finder.find(from: line.biggestWord())
        switch result {
        case .failure:
            XCTAssertTrue(false, "Can`t find gap")
        case .success(let range):
            let testRange: TrackingRange = 7.38...7.5
            let message = "Range: \(range)\n"
            XCTAssertTrue(testRange.intesected(with: range) != nil, message)
        }
    }

    let standartRange: TrackingRange = 14.7...14.9

    func testSc1() {
        let result = execute(.sc1, lineIndex: 20, wordIndex: 0, isLow: false)
        XCTAssertTrue(result?.overlaps(standartRange) ?? false, "\(String(describing: result))")
        
    }

    func execute(_ scene: Scene, lineIndex: Int, wordIndex: Int, isLow: Bool) -> TrackingRange? {
        let block = scene.getBlock(low: isLow)
        let line = block.lines[lineIndex]
        let result = finder.find(from: line.words[wordIndex])
        guard case .success(let range) = result else { return nil }
        return range
    }
}
