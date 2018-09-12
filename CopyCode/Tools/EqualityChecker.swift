//
//  EqualityChecker.swift
//  CopyCode
//
//  Created by Артем on 12/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct EqualityChecker {
   static func check(of left: CGFloat, with right: CGFloat, errorPercentRate: UInt) -> Bool {
        let percent = 100 - CGFloat(errorPercentRate)
        let first = left / right * 100
        let second = right / left * 100
        let value = min(first, second)
        return value >= percent
    }
}
