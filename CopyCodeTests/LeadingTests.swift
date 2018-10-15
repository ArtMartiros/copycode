//
//  LeadingTests.swift
//  CopyCodeTests
//
//  Created by Артем on 16/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

class LeadingTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    let frame = CGRect(x: 807, y: 198, width: 409, height: 17)
    let leading = Leading(fontSize: 18.573551263001487, lineSpacing: 3.7264487369985124, startPointTop: 463.0)
    
    func testMissingLines() {
       let test = leading.missingLinesFrame(in: frame)
        print("")
    }

}
