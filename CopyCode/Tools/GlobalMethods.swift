//
//  GlobalMethods.swift
//  CopyCode
//
//  Created by Артем on 02/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

/// Create ClosedRange if you dont know what number is greater
func rangeOf<T: Numeric>(one: T, two: T) -> ClosedRange<T> {
    let minValue = min(one, two)
    let maxValue = max(one, two)
    return minValue...maxValue
}
