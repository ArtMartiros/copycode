//
//  LeadingFinderTests.swift
//  CopyCodeTests
//
//  Created by Артем on 13/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

class LeadingFinderTests: XCTestCase {

    let leadingFinder = LeadingFinder()
    func testSc11() {
        let block = Scene.sc11.getTrackingBlock()
        let result = leadingFinder.find(block)
        XCTAssertNotNil(result)
    }

}
