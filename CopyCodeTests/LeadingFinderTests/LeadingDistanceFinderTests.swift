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
        let block = Scene.block_one_code.getBlock(low: false)
        let finder = LeadingDistanceFinder(block: block)
        let result = finder.find()
        switch result {
        case .failure: XCTAssertTrue(false, "Didn`t find range")
        case .success(let range):
            let testRange: LeadingRange = 16.9...17
            let message = "Range: \(range), index \(index)\n"
            XCTAssertTrue(testRange.intesected(with: range) != nil, message)
        }
    }
}
