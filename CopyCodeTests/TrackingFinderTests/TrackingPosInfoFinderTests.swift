//
//  TrackingPosInfoFinderTests.swift
//  CopyCodeTests
//
//  Created by Артем on 09/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest
//проходит
class TrackingPosInfoFinderTests: XCTestCase {

    let posFinder = TrackingInfoFinder.PositionInfoFinder()
    let forbiddensCreator = TrackingInfoFinder.RestrictionsCreator()
    func testSc1() {
        let block = Scene.sc1.getBlock(low: false)
        let line = block.lines[2]
        let posInfos = posFinder.find(from: line.words)
        let forbiddens = forbiddensCreator.create(from: posInfos, lineIndex: 2)
        XCTAssertFalse(posInfos.isEmpty)
        XCTAssertFalse(forbiddens.isEmpty)
//        XCTAssertEqual(forbiddens[2], 2371)
        let info = posInfos[0]
        XCTAssertEqual(info.startX, 728)
        XCTAssertEqual(info.lastKnowX, 1240)
    }

    func testSc11_L7_low() {
        let block = Scene.sc11.getBlock(low: true)
        let line = block.lines[7]
        let posInfos = posFinder.find(from: line.words)
        XCTAssertEqual(posInfos.count, 1)
    }

    func testSc14_L1() {
        let block = Scene.sc14.getBlock(low: false)
        let line = block.lines[1]
        let posInfos = posFinder.find(from: line.words)
        XCTAssertEqual(posInfos.count, 2)
    }

    func testSc22_L6() {
        let block = Scene.sc22.getBlock(low: false)
        let line = block.lines[6]
        let posInfos = posFinder.find(from: line.words)
        XCTAssertEqual(posInfos.count, 2)
    }

    func testSc22_L8() {
        let block = Scene.sc22.getBlock(low: false)
        let line = block.lines[8]
        let posInfos = posFinder.find(from: line.words)
        XCTAssertEqual(posInfos.count, 2)
    }

    func testSc22_L12() {
        let block = Scene.sc22.getBlock(low: false)
        let line = block.lines[12]
        let posInfos = posFinder.find(from: line.words).sorted { $0.startX < $1.startX }
        XCTAssertEqual(posInfos.count, 2)
        XCTAssertEqual(posInfos[1].startX, 203)
    }

    func testSc26_L7() {
        let block = Scene.sc26.getBlock(low: false)
        let line = block.lines[7]
        let posInfos = posFinder.find(from: line.words).sorted { $0.startX < $1.startX }
        XCTAssertEqual(posInfos.count, 1)
    }

    func testSc27_L18() {
        let block = Scene.sc27.getBlock(low: false)
        let line = block.lines[18]
        let posInfos = posFinder.find(from: line.words).sorted { $0.startX < $1.startX }
        XCTAssertEqual(posInfos.count, 2)
        XCTAssertEqual(posInfos[1].startX, 204)
    }
}
