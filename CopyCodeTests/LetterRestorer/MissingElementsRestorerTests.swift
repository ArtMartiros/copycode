//
//  MissingElementsRestorerTests.swift
//  CopyCodeTests
//
//  Created by Артем on 02/11/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

class MissingElementsRestorerTests: XCTestCase {


    func testSc11_low() {
        let scene = Scene.sc11
        let isLow = true
        let bitmap = scene.getImage(isLow: isLow).bitmap
        let gridBlock = scene.getGridBlock(isLow: isLow)
        let restorer = MissingElementsRestorer(bitmap: bitmap)


        guard case .grid(let grid) = gridBlock.typography else { return }
        let arrayOfFrames = grid.getArrayOfFrames(from: gridBlock.frame)
        let line = "sc11_grid_halfRestored_l1_low".decode(as: SimpleLine.self)!
        let restoredLine = restorer.restoreWords(in: line, lineFrames: arrayOfFrames[0])
        XCTAssertEqual(restoredLine.words[0].letters.count, 17)
    }

}
