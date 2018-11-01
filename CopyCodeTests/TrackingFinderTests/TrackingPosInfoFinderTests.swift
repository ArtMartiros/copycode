//
//  TrackingPosInfoFinderTests.swift
//  CopyCodeTests
//
//  Created by Артем on 09/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

class TrackingPosInfoFinderTests: XCTestCase {

    let posFinder = TrackingInfoFinder.PositionInfoFinder()
    let forbiddensCreator = TrackingInfoFinder.ForbiddensCreator()

    func testSc1() {
        let block = Scene.sc1.getBlock(self, low: false)
        let line = block.lines[2]
        let posInfos = posFinder.find(from: line.words)
        let forbiddens = forbiddensCreator.create(from: posInfos, lineIndex: 2)
        XCTAssertFalse(posInfos.isEmpty)
        XCTAssertFalse(forbiddens.isEmpty)
        XCTAssertEqual(forbiddens[2], 2371)
        let info = posInfos[0]
        XCTAssertEqual(info.startX, 728)
        XCTAssertEqual(info.lastKnowX, 1240)
    }

    func testSc11_L7_low() {
        let block = Scene.sc11.getBlock(self, low: true)
        let line = block.lines[7]
        let posInfos = posFinder.find(from: line.words)
        XCTAssertEqual(posInfos.count, 1)
    }
}
