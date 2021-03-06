//
//  SceneTypeTests.swift
//  CopyCodeTests
//
//  Created by Артем on 03/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

class SceneTypeTests: XCTestCase {

    func testSc1() {
        TypeHelper.execute(self, scene: .sc1, exluded: [0, 23, 24, 25], isLow: false) { (type, position) in
            XCTAssertEqual(position.letter.type, type, TypeHelper.message(position))
        }
    }

    func testSc2() {
        TypeHelper.execute(self, scene: .sc2, exluded: [], isLow: false) { (type, position) in
            XCTAssertEqual(position.letter.type, type, TypeHelper.message(position))
        }
    }
    
    func testSc3_p1() {
        TypeHelper.execute(self, scene: .sc3_p1, exluded: [], isLow: false) { (type, position) in
            print(type)
            XCTAssertEqual(position.letter.type, type, TypeHelper.message(position))
        }
    }
    
    func testSc3_p2() {
        TypeHelper.execute(self, scene: .sc3_p2, exluded: [], isLow: false) { (type, position) in
            print(type)
            XCTAssertEqual(position.letter.type, type, TypeHelper.message(position))
        }
    }
    
    func testSc9() {
        TypeHelper.execute(self, scene: .sc9, exluded: [], isLow: false) { (type, position) in
            XCTAssertEqual(position.letter.type, type, TypeHelper.message(position))
        }
    }
    
    func testSc11() {
        TypeHelper.execute(self, scene: .sc11, exluded: [], isLow: false) { (type, position) in
            XCTAssertEqual(position.letter.type, type, TypeHelper.message(position))
        }
    }

    func testSc14() {
        TypeHelper.execute(self, scene: .sc14, exluded: [], isLow: false) { (type, position) in
            XCTAssertEqual(position.letter.type, type, TypeHelper.message(position))
        }
    }

    func testSc15() {
        TypeHelper.execute(self, scene: .sc15, exluded: [], isLow: false) { (type, position) in
            XCTAssertEqual(position.letter.type, type, TypeHelper.message(position))
        }
    }

    func testSc16() {
        TypeHelper.execute(self, scene: .sc16, exluded: [], isLow: false) { (type, position) in
            XCTAssertEqual(position.letter.type, type, TypeHelper.message(position))
        }
    }

    func testSc17() {
        TypeHelper.execute(self, scene: .sc17, exluded: [], isLow: false) { (type, position) in
            XCTAssertEqual(position.letter.type, type, TypeHelper.message(position))
        }
    }

    func testSc18() {
        TypeHelper.execute(self, scene: .sc18, exluded: [], isLow: false) { (type, position) in
            XCTAssertEqual(position.letter.type, type, TypeHelper.message(position))
        }
    }

    func testSc21() {
        TypeHelper.execute(self, scene: .sc21, exluded: [], isLow: false) { (type, position) in
            XCTAssertEqual(position.letter.type, type, TypeHelper.message(position))
        }
    }

    func testSc22() {
        TypeHelper.execute(self, scene: .sc22, exluded: [], isLow: false) { (type, position) in
            XCTAssertEqual(position.letter.type, type, TypeHelper.message(position))
        }
    }

    func testSc23() {
        TypeHelper.execute(self, scene: .sc23, exluded: [], isLow: false) { (type, position) in
            XCTAssertEqual(position.letter.type, type, TypeHelper.message(position))
        }
    }

    func testSc24() {
        TypeHelper.execute(self, scene: .sc24, exluded: [], isLow: false) { (type, position) in
            XCTAssertEqual(position.letter.type, type, TypeHelper.message(position))
        }
    }

    func testSc25() {
        TypeHelper.execute(self, scene: .sc25, exluded: [], isLow: false) { (type, position) in
            XCTAssertEqual(position.letter.type, type, TypeHelper.message(position))
        }
    }

    func testSc26() {
        TypeHelper.execute(self, scene: .sc26, exluded: [], isLow: false) { (type, position) in
            XCTAssertEqual(position.letter.type, type, TypeHelper.message(position))
        }
    }

}
