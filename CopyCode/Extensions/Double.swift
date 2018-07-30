//
//  Double.swift
//  CopyCode
//
//  Created by Артем on 18/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension CGFloat {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Int {
    func of(_ number: Int, _ operation: (Int, Int) -> Bool, percent percentNumber: Int) -> Bool {
        guard number != 0 else { return false }
        let value = self * 100 / number
        return  operation(value, percentNumber)
    }
}

//extension Comparable {
//
//    func clamped(to r: ClosedRange<Self>) -> Self {
//        let min = r.lowerBound, max = r.upperBound
//        return self < min ? min : (max < self ? max : self)
//    }
//}
