//
//  LeadingDistanceFinderTests.swift
//  CopyCodeTests
//
//  Created by Артем on 13/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

class LeadingDistanceFinderTests: XCTestCase {
    
    func testFindDistance() {
        let block = Scene.sc15.getTrackingBlock()
        let finder = LeadingDistanceFinder(block: block)
        guard let range = finder.find() else {
            XCTAssertTrue(false, "Didn`t find range")
            return
        }

        let testRange: LeadingRange = 59...60
        let message = "Range: \(range), index \(index)\n"
        XCTAssertTrue(testRange.intesected(with: range) != nil, message)
    }
}
