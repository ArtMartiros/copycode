//
//  EqualityChecker.swift
//  CopyCode
//
//  Created by Артем on 12/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct EqualityChecker {
   static func check(of left: CGFloat, with right: CGFloat, errorPercentRate: CGFloat) -> Bool {
        let percent = 100 - errorPercentRate
        let first = left / right * 100
        let second = right / left * 100
        let value = min(first, second)
        return value >= percent
    }
}
