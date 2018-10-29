//
//  Checker.swift
//  CopyCode
//
//  Created by Артем on 03/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

final class Checker {
    enum AccuracyPercentRate: CGFloat {
        case superHigh = 4
        case high = 6
        case medium = 15
        case low = 30
        case superLow = 50
    }

    func isSameHeight(first: CGFloat, with second: CGFloat, accuracy: CGFloat) -> Bool {
        let diff = first / second
        print("first \(first), second \(second), diff \(diff), accuracy \(accuracy)")
        return diff < accuracy
    }

    func isSame(_ first: CGFloat, with second: CGFloat, height: CGFloat, accuracy: AccuracyPercentRate = .high) -> Bool {
        return isSame(first, with: second, relativelyTo: height, accuracy: accuracy.rawValue)
    }

    ///accuracy in percent
    func isSame(_ first: CGFloat, with second: CGFloat, relativelyTo: CGFloat, accuracy: CGFloat) -> Bool {
        let diff = abs(first - second)
        let different = (diff / relativelyTo) * 100 > accuracy
//        print("first \(first), second \(second), diff \(diff), different \(diff / relativelyTo)")
        return !different
    }
}
