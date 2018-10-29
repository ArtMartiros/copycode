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
        let isLow = false
        let block = scene.getGridBlock(self, isLow: isLow)
        let bitmap = scene.getImage(isLow: isLow).bitmap
        guard case .grid(let grid) = block.typography else { return }
        let updater = LeadingAndBlockUpdater(grid: grid, isRetina: !isLow)
        let typeConverter = TypeConverter(in: bitmap, grid: grid, type: .onlyLow)
        let blockWithLow = typeConverter.convert(block)
        let result = updater.update(block: blockWithLow)
        print("D")
    }
}
