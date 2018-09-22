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
    /// For example:
    ///
    ///     let x: CGFloat = 1.2345
    ///     print(x(toPlaces: 3))
    ///     // Prints "1.235"
    ///
    func rounded(toPlaces places:Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return (self * divisor).rounded() / divisor
    }
    
    mutating func round(toPlaces places:Int) {
        let divisor = pow(10.0, CGFloat(places))
        let newValue = (self * divisor).rounded() / divisor
        self = newValue
    }
}

extension Int {
    func of(_ number: Int, _ operation: (Int, Int) -> Bool, percent percentNumber: Int) -> Bool {
        guard number != 0 else { return false }
        let value = self * 100 / number
        return  operation(value, percentNumber)
    }
}

extension CGFloat {
    var remainder: CGFloat {
        let divider: CGFloat = 1000
        let value = Int(self * divider)
        let test = value % Int(divider)
        return CGFloat(test) / divider
    }
}
