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

    func testOCRScene3_p2() {
        OCRHelper.execute(self, scene: .sc3_p2, exlude: [33], isLow: false) { (answer, position) in
            XCTAssertEqual(position.letter.value, answer, OCRHelper.message(position))
        }
    }

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

    func testOCRScene14() {
        OCRHelper.execute(self, scene: .sc14, exlude: [], isLow: false) { (answer, position) in
            XCTAssertEqual(position.letter.value, answer, OCRHelper.message(position))
        }
    }

    func testOCRScene15() {
        OCRHelper.execute(self, scene: .sc15, exlude: [], isLow: false) { (answer, position) in
            XCTAssertEqual(position.letter.value, answer, OCRHelper.message(position))
        }
    }

    func testOCRScene16() {
        OCRHelper.execute(self, scene: .sc16, exlude: [], isLow: false) { (answer, position) in
            XCTAssertEqual(position.letter.value, answer, OCRHelper.message(position))
        }
    }

    func testOCRScene17() {
        OCRHelper.execute(self, scene: .sc17, exlude: [], isLow: false) { (answer, position) in
            XCTAssertEqual(position.letter.value, answer, OCRHelper.message(position))
        }
    }

    func testOCRScene18() {
        OCRHelper.execute(self, scene: .sc18, exlude: [], isLow: false) { (answer, position) in
            XCTAssertEqual(position.letter.value, answer, OCRHelper.message(position))
        }
    }

    func testOCRScene21() {
        OCRHelper.execute(self, scene: .sc21, exlude: [], isLow: false) { (answer, position) in
            XCTAssertEqual(position.letter.value, answer, OCRHelper.message(position))
        }
    }
    //он находиться с=здесь, потому что происходит какая то хрень, когда он находится со всеми остальными лоу
    func testOCRScene3_p2_low() {
        OCRHelper.execute(self, scene: .sc3_p2, exlude: [33], isLow: true) { (answer, position) in
            XCTAssertEqual(position.letter.value, answer, OCRHelper.message(position))
        }
    }
}


