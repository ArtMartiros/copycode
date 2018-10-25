//
//  LeadingAndBlockUpdaterTests.swift
//  CopyCodeTests
//
//  Created by Артем on 25/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

class LeadingAndBlockUpdaterTests: XCTestCase {


    func testExample() {
        let scene = Scene.sc11
      let block = scene.getGridBlock(self)
        let bitmap = scene.image.bitmap
        guard case .grid(let grid) = block.typography else { return }
        let updater = LeadingAndBlockUpdater(grid: grid)
        var typeConverter = TypeConverter(in: bitmap, grid: grid, type: .onlyLow)
        let blockWithLow = typeConverter.convert(block)
        let result = updater.update(block: blockWithLow)
        print("D")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
