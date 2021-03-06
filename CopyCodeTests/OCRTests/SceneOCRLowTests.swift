//
//  SceneOCRLowTests.swift
//  CopyCodeTests
//
//  Created by Артем on 28/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

class SceneOCRLowTests: XCTestCase {

    func testOCRScene1() {
        let exludedIndex: Set<Int> = [0, 1, 2, 15, 16, 17]
        OCRHelper.execute(self, scene: .sc1, exlude: exludedIndex, isLow: true) { (answer, position) in
            XCTAssertEqual(position.letter.value, answer, OCRHelper.message(position))
        }
    }

    func testOCRScene2() {
        OCRHelper.execute(self, scene: .sc2, exlude: [], isLow: true) { (answer, position) in
            XCTAssertEqual(position.letter.value, answer, OCRHelper.message(position))
        }
    }

    func testOCRScene3_p1() {
        let exludedIndex: Set<Int> = [0, 1, 2, 3, 4, 5, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45]
        OCRHelper.execute(self, scene: .sc3_p1, exlude: exludedIndex, isLow: true) { (answer, position) in
            XCTAssertEqual(position.letter.value, answer, OCRHelper.message(position))
        }
    }

    func testOCRScene11() {
        OCRHelper.execute(self, scene: .sc11, exlude: [], isLow: true) { (answer, position) in
            XCTAssertEqual(position.letter.value, answer, OCRHelper.message(position))
        }
    }
}
