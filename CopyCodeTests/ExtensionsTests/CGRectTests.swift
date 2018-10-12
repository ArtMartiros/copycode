//
//  CGRectTests.swift
//  CopyCodeTests
//
//  Created by Артем on 05/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

class CGRectTests: XCTestCase {
    
    func testUpdateFrame() {
        let frame = CGRect(x: 100, y: 100, width: 50, height: 50)
        let answerFrame = CGRect(x: 90, y: 90, width: 70, height: 70)
        let updatedFrame = frame.update(by: 10, in: .offset(.all))
        XCTAssertEqual(answerFrame, updatedFrame)
    }

}
