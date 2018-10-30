//
//  ScenesOCRTests.swift
//  CopyCodeTests
//
//  Created by Артем on 04/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

class ScenesOCRTests: XCTestCase {
    
    func testOCRScene1() {
        let exludedIndex: Set<Int> = [0, 1, 2, 15, 16, 17]
        OCRHelper.execute(self, scene: .sc1, exlude: exludedIndex, isLow: false) { (answer, position) in
            XCTAssertEqual(position.letter.value, answer, OCRHelper.message(position))
        }
    }

    func testOCRScene2() {
        OCRHelper.execute(self, scene: .sc2, exlude: [], isLow: false) { (answer, position) in
            XCTAssertEqual(position.letter.value, answer, OCRHelper.message(position))
        }
    }

    func testOCRScene3_p1() {
        let exludedIndex: Set<Int> = [0, 1, 2, 3, 4, 5, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45]
        OCRHelper.execute(self, scene: .sc3_p1, exlude: exludedIndex, isLow: false) { (answer, position) in
            XCTAssertEqual(position.letter.value, answer, OCRHelper.message(position))
        }
    }

//    func testOCRScene3_p2() {
//        OCRHelper.execute(self, scene: .sc3_p2, exlude: [], isLow: false) { (answer, position) in
//            XCTAssertEqual(position.letter.value, answer, OCRHelper.message(position))
//        }
//    }

    func testOCRScene9() {
        OCRHelper.execute(self, scene: .sc9, exlude: [1, 2], isLow: false) { (answer, position) in
            XCTAssertEqual(position.letter.value, answer, OCRHelper.message(position))
        }
    }
    

    func testOCRScene11() {
        OCRHelper.execute(self, scene: .sc11, exlude: [], isLow: false) { (answer, position) in
            XCTAssertEqual(position.letter.value, answer, OCRHelper.message(position))
        }
    }
}


