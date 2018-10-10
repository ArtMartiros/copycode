//
//  TrackingPosInfoFinderTests.swift
//  CopyCodeTests
//
//  Created by Артем on 09/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

class TrackingPosInfoFinderTests: XCTestCase {

    let posFinder = TrackingPosInfoFinder()
    
    func testSc1() {
        let block = Scene.sc1.getBlock(self)
        let line = block.lines[2]
        let result = posFinder.find(from: line.words)
        print(result)
    }
}
