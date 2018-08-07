//
//  Checker.swift
//  CopyCode
//
//  Created by Артем on 03/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation
enum Compare {
    case more
    case less
    case equal
}

class Checker {

    private let height: CGFloat
    enum Accuracy: CGFloat {
        case superHigh = 0.04
        case high = 0.06
        case medium = 0.15
        case low = 0.3
        case superLow = 0.5
    }
    
    init(height: CGFloat) {
        self.height = height
    }
    
    func isSameHeight(first: CGFloat, with second: CGFloat, accuracy: CGFloat) -> Bool {
        let diff = first / second
        print("first \(first), second \(second), diff \(diff), accuracy \(accuracy)")
        return diff < accuracy
    }
    
    func isSame(first: CGFloat, with second: CGFloat, accuracy: Accuracy = .high) -> Bool {
        let diff = abs(first - second)
        let different = (diff / height) > accuracy.rawValue
        print("first \(first), second \(second), diff \(diff), different \(diff / height)")
        return !different
    }
    
    func difference(first: CGFloat, is compare: Compare, then second: CGFloat, height: CGFloat, accuracy: Accuracy = .high) -> Bool {
        let diff = first - second
        let rate = diff / height
        print("first \(first), second \(second), diff \(diff), rate \(rate)")
        switch compare {
        case .more:
            if diff > 0, abs(rate) > accuracy.rawValue {
                return true
            }
            return false
        case .less:
            if diff < 0, abs(rate) > accuracy.rawValue {
                return true
            }
            return false
        case .equal:
            break
        }
        return false
    }
    
    func isSame(first: CGFloat, with second: CGFloat, height: CGFloat, accuracy: Accuracy = .high) -> Bool {
        let diff = abs(first - second)
        let different = (diff / height) > accuracy.rawValue
        print("first \(first), second \(second), diff \(diff), different \(diff / height)")
        return !different
    }
    
    func isSame(first: CGFloat, with second: CGFloat, height: CGFloat, accuracy: CGFloat) -> Bool {
        let diff = abs(first - second)
        let different = (diff / height) > accuracy
        print("first \(first), second \(second), diff \(diff), different \(diff / height)")
        return !different
    }
}
