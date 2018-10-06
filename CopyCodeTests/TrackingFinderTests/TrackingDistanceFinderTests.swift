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
    var blocks: [Block<LetterRectangle>] = []
    override func setUp() {
        blocks = BlockTestHelper.getBlocks(self)
    }
    
    func testFindFail() {
        let block = blocks[0]
        let line = block.lines[0]
        let result = finder.find(from: line.biggestWord())
        switch result {
        case .failure: break
        case .success:
            XCTAssertTrue(false, "There is no success result")
        }
    }

    func testFindSuccessWithStuckLetters() {
        let block = blocks[1]
        let line = block.lines[11]
        let result = finder.find(from: line.biggestWord())
        switch result {
        case .failure:
            XCTAssertTrue(false, "Can`t find gap")
        case .success(let range):
            let testRange: TrackingRange = 7.3...7.5
            XCTAssertTrue(testRange.intesected(with: range) != nil, "Range didn`t contain \(testRange)")
        }
    }
    
    func testFindSuccessWithTwoQuotes() {
        let block = blocks[0]
        let line = block.lines[13]
        let quoteWord = line.words[1]
        let result = finder.find(from: quoteWord)
        switch result {
        case .failure:
            XCTAssertTrue(false, "Can`t find gap")
        case .success(let range):
            let testRange: TrackingRange = 7.3...7.5
            XCTAssertTrue(testRange.intesected(with: range) != nil, "Range didn`t contain \(testRange)")
        }
    }
    
    func testFindSuccessInBlock() {
        let block = blocks[0]
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
    
    func testFindSuccessComment() {
        let block = blocks[1]
        let line = block.lines[33]
        let word = line.words[0]
        let result = finder.find(from: word)
        switch result {
        case .failure:
            XCTAssertTrue(false, "Can`t find gap")
        case .success(let range):
            let testRange: TrackingRange = 7.3...7.5
            let message = "Range: \(range)\n"
            XCTAssertTrue(testRange.intesected(with: range) != nil, message)
        }
    }
    
    func testBlockComments() {
        let block = BlockTest.comments.getBlock(self)
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
        let block = BlockTest.two.getBlock(self)
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
    
    
    func testExample() {
        let block = BlockTest.sc1.getBlock(self)
        let line = block.lines[2]
        let word = line.words[0]
        let result = finder.find(from: word)
        switch result {
        case .success(let range):
            let startPointFinder = TrackingStartPointFinder()
            let test = startPointFinder.find(in: word, with: range)
            print("ddd")
        default:
            break
        }

    }

}
