//
//  TrackingFinderTests.swift
//  CopyCodeTests
//
//  Created by Артем on 09/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

class TrackingFinderTests: XCTestCase {

    let finder = TrackingFinder()
    
    func testExample() {
        let block = Scene.sc3_p1.getBlock(self)
        let line = block.lines[38]
        let word = line.words[2]
        let result = finder.findTrackings(from: word)
        print("")
    }

}
