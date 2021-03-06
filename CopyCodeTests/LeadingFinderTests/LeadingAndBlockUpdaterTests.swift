//
//  LeadingAndBlockUpdaterTests.swift
//  CopyCodeTests
//
//  Created by Артем on 25/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

//Все тесты успешно пройдены
class LeadingAndBlockUpdaterTests: XCTestCase {

    func testSc1() {
        let result = execute(.sc1, isLow: false)[0]
        XCTAssertEqual(result.lines.count, 22)
    }

    func testSc3_p1() {
        let result = execute(.sc3_p1, isLow: false)[0]
        XCTAssertEqual(result.lines.count, 45)
    }

    func testSc3_p2() {
        let result = execute(.sc3_p2, isLow: false)[0]
        XCTAssertEqual(result.lines.count, 34)
    }

    func testSc11() {
        let result = execute(.sc11, isLow: false)
        XCTAssertEqual(result[0].lines.count, 8)
    }

    func testSc11_low() {
        let result = execute(.sc11, isLow: true)
        XCTAssertEqual(result[0].lines.count, 8)
    }

    func testSc15() {
        let result = execute(.sc15, isLow: false)
        XCTAssertEqual(result[0].lines.count, 8)
    }

    func testSc16() {
        let result = execute(.sc16, isLow: false)
        XCTAssertEqual(result[0].lines.count, 8)
    }

    func testSc17() {
        let result = execute(.sc17, isLow: false)
        XCTAssertEqual(result[0].lines.count, 8)
    }

    func testSc20() {
        let result = execute(.sc20, isLow: false)
        XCTAssertEqual(result[0].lines.count, 7)
    }

    func testSc21() {
        let result = execute(.sc21, isLow: false)
        XCTAssertEqual(result[0].lines.count, 10)
    }

    func testSc28() {
        let result = execute(.sc28, isLow: false)
        XCTAssertEqual(result[0].lines.count, 11)
    }

    private func execute(_ scene: Scene, isLow: Bool) -> [SimpleBlock] {
        let block = scene.getGridBlock(isLow: isLow)
        let bitmap = scene.getImage(isLow: isLow).bitmap
        guard case .grid(let grid) = block.typography else { return [] }
        let updater = LeadingAndBlockUpdater(grid: grid, isRetina: !isLow)
        let typeConverter = TypeConverter(in: bitmap, grid: grid, type: .onlyLow)
        let blockWithLow = typeConverter.convert(block)
        return updater.update(block: blockWithLow)
    }
}
