//
//  ClosedRangeTests.swift
//  CopyCodeTests
//
//  Created by Артем on 06/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

class ClosedRangeTests: XCTestCase {

    func testIntersected() {
        let range: TrackingRange = 7.23...7.53
        let rangeToCompare: TrackingRange = 7.3...7.5
        let result = rangeToCompare.intesected(with: range)
        let result1 = range.intesected(with: rangeToCompare)
        let result2 = range.intesected(with: 1...2)
        XCTAssertNotNil(result)
        XCTAssertNotNil(result1)
        XCTAssertNil(result2)
    }

}
