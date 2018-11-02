//
//  GridCorrelatorTests.swift
//  CopyCodeTests
//
//  Created by Артем on 24/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

class GridCorrelatorTests: XCTestCase {
    let correlator = GridLineCorrelator()

    func testSc11_low() {
        let line = "sc11_grid_halfRestored_l1_low".decode(as: SimpleLine.self)!
        let frames = "sc11_grid_l1_frames_low".decode(as: [CGRect].self)!
        
        let letters = line.words.map { $0.letters }.reduce([], +)
       let correlation = correlator.correlate(letters, frames: frames)

        XCTAssertNotNil(correlation[8].lineIndex)
    }
}
