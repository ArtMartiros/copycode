//
//  TrackingCheckerTests.swift
//  CopyCodeTests
//
//  Created by Артем on 24/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

class TrackingCheckerTests: XCTestCase {

    func testExample() {
        let checker = TrackingChecker()
        let block = Scene.sc1.getBlock(self)

        for (lineIndex, line) in block.lines.enumerated() {
//            print("Bukaki lineIndex: \(lineIndex)\n")
            
            for (wordIndex, word) in line.words.enumerated() {
//               print("Bukaki wordIndex: \(wordIndex)")
                let width: CGFloat = 7.125
                
                if let gaps = word.fixedGapsWthCutedOutside(letterWidth: width) {
                    checker.check(gaps, withDistance: width, startPoint: 1239)
                }
                
            }
            print("\n\n")
        }
    }

}
