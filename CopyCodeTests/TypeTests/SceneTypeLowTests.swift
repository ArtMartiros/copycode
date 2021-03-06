//
//  SceneTypeLowTests.swift
//  CopyCodeTests
//
//  Created by Артем on 28/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

class SceneTypeLowTests: XCTestCase {

    func testSc1() {
        TypeHelper.execute(self, scene: .sc1, exluded: [0, 23, 24, 25], isLow: true) { (type, position) in
            XCTAssertEqual(position.letter.type, type, TypeHelper.message(position))
        }
    }

    func testSc2() {
        TypeHelper.execute(self, scene: .sc2, exluded: [], isLow: true) { (type, position) in
            XCTAssertEqual(position.letter.type, type, TypeHelper.message(position))
        }
    }

    func testSc3_p1() {
        TypeHelper.execute(self, scene: .sc3_p1, exluded: [], isLow: true) { (type, position) in
            print(type)
            XCTAssertEqual(position.letter.type, type, TypeHelper.message(position))
        }
    }

    func testSc3_p2() {
        TypeHelper.execute(self, scene: .sc3_p2, exluded: [], isLow: true) { (type, position) in
            print(type)
            XCTAssertEqual(position.letter.type, type, TypeHelper.message(position))
        }
    }

    func testSc11() {
        TypeHelper.execute(self, scene: .sc11, exluded: [], isLow: true) { (type, position) in
            XCTAssertEqual(position.letter.type, type, TypeHelper.message(position))
        }
    }

}
