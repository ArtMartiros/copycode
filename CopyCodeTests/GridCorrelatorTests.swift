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
        let line = CodableHelper.decode(self, path: "sc11_grid_halfRestored_l1_low",
                                           structType: SimpleLine.self, shouldPrint: false)!
        let frames = CodableHelper.decode(self, path: "sc11_grid_l1_frames_low",
                                          structType: [CGRect].self, shouldPrint: false)!
        let letters = line.words.map { $0.letters }.reduce([], +)
       let correlation = correlator.correlate(letters, frames: frames)

        XCTAssertNotNil(correlation[8].lineIndex)
    }
}
