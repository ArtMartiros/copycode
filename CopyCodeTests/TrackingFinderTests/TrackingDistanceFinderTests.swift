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
        let block = Scene.one.getBlock(self)
        let line = block.lines[0]
        let result = finder.find(from: line.biggestWord())
        switch result {
        case .failure: break
        case .success:
            XCTAssertTrue(false, "There is no success result")
        }
    }

    func testDistanceInBlock1() {
        let block = Scene.one.getBlock(self)
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
        let block = Scene.two.getBlock(self)
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
        let block = Scene.comments.getBlock(self)
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
        let block = Scene.two.getBlock(self)
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
        let block = Scene.sc3_p1.getBlock(self)
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
        let block = Scene.sc3_p1.getBlock(self)
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
        let block = Scene.two.getBlock(self)
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
}
