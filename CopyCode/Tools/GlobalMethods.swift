//
//  GlobalMethods.swift
//  CopyCode
//
//  Created by Артем on 02/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

typealias TrackingRange = ClosedRange<CGFloat>
typealias SimpleWord = Word<LetterRectangle>
typealias SimpleLine = Line<LetterRectangle>
typealias SimpleBlock = Block<LetterRectangle>
typealias SimpleLetterPosition = LetterWithPosition<LetterRectangle>
typealias CompletedWord = Word<Letter>
typealias CompletedLine = Line<Letter>
typealias CompletedBlock = Block<Letter>
typealias CompletedLetterPosition = LetterWithPosition<Letter>
/// Create ClosedRange if you dont know what number is greater
func rangeOf<T: Numeric>(one: T, two: T) -> ClosedRange<T> {
    let minValue = min(one, two)
    let maxValue = max(one, two)
    return minValue...maxValue
}

func releasePrint(_ object: Any) {
    Swift.print(object)
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
///case failure or case success(T)
enum SimpleSuccess<T> {
    case failure
    case success(T)
}

/// Cases: left, right, top, bottom
enum Direction: Int {
    case left = 0
    case right = 1
    case top = 2
    case bottom = 3
}
extension Direction {
    var optionSet: DirectionOptions {
       return DirectionOptions(rawValue: 1 << rawValue)
    }
}

struct DirectionOptions: OptionSet {
    let rawValue: Int

    static let left = DirectionOptions(rawValue: 1 << Direction.left.rawValue)
    static let right = DirectionOptions(rawValue: 1 << Direction.right.rawValue)
    static let top = DirectionOptions(rawValue: 1 << Direction.top.rawValue)
    static let bottom = DirectionOptions(rawValue: 1 << Direction.bottom.rawValue)

    static let horizontal: DirectionOptions = [.left, .right]
    static let vertical: DirectionOptions = [.top, .bottom]
    static let all: DirectionOptions = [.vertical, .horizontal]
}

extension DirectionOptions {
    var directions: [Direction] {
        var values: [Direction] = []

        if self.contains(.left) {
            values.append(.left)
        }

        if self.contains(.right) {
            values.append(.right)
        }

        if self.contains(.top) {
            values.append(.top)
        }

        if self.contains(.bottom) {
            values.append(.bottom)
        }
        return values
    }
}
