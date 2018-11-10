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
