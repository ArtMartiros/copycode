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

func print(_ object: Any) {
    #if DEBUG
    Swift.print(object)
    #endif
}

/// Cases: or, and, allFalse, someFalse
enum LogicalOperator: String {
    case or
    case and
    case allFalse
    case someFalse
}

///case empty or case value(T)
enum SimpleResult<T> {
    case empty
    case value(T)
}

enum SimpleSuccess<T> {
    case failure
    case success(T)
}

/// Cases: left, right, top, bottom
enum Direction {
    case left
    case right
    case top
    case bottom
}
