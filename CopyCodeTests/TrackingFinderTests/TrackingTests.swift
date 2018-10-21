//
//  TrackingTests.swift
//  CopyCodeTests
//
//  Created by Артем on 28/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

class TrackingTests: XCTestCase {
    func testExample() {
        let tracking = Tracking(startPoint: 369.5, width: 7.4615384615384617)
        let frame = CGRect(x: 364, y: 805.5, width: 651, height: 12.5)
        let result = tracking.missingCharFrames(in: frame)[0]
        XCTAssertTrue(frame.leftX > result.leftX)
        print("ss")
    }

}
