//
//  ArrayChunkTests.swift
//  CopyCodeTests
//
//  Created by Артем on 31/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

class ArrayChunkTests: XCTestCase {

    func testChunk() {
        let array = [0, 0, 0, 0, 1, 1, 3, 3]
        let chunkedArray = array.chunkForSorted { $0 == $1 }
        XCTAssertTrue(chunkedArray.count == 3, "chunkedArray not equal 3")
        let allValues = chunkedArray.reduce([Int]()) { $0 + $1 }
        XCTAssertTrue(allValues.count == array.count, "elements count \(allValues.count) not equal to \(array.count)")
    }


}
