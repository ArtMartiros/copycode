//
//  TrackingChecker.swift
//  CopyCode
//
//  Created by Артем on 06/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct TrackingChecker {
    typealias Result = (result: Bool, errorRate: CGFloat)
    private let kMiscalculationSuccessedRate: CGFloat = 0.04
    private let kMiscalculationSuccessedRateValue: CGFloat = 0.000265
    func miscalculationSuccessedRate(basedOn distance: CGFloat) -> CGFloat {
        return distance * kMiscalculationSuccessedRateValue
    }

    func getMiscalculation(_ gap: CGRect, withDistance distance: CGFloat, startPoint: CGFloat) -> CGFloat {
        let leftX = gap.leftX - (gap.width == 0 ? 0.5 : 0)
        let rightX = gap.rightX + (gap.width == 0 ? 0.5 : 0)

        let width = leftX - startPoint
        let width1 = rightX - startPoint
        var amount = (width / distance)
        var amount1 = (width1 / distance)
        amount.round(toPlaces: 3)
        amount1.round(toPlaces: 3)
        print("amount \(amount), amount1 \(amount1),  startPoint: \(startPoint)" )
        print("Gap border: (left: \(leftX), right: \(rightX))")

        let integers = rangeOf(one: amount, two: amount1).integers

        guard integers.isEmpty else { return 0 }

        let amountRemainder = abs(amount.remainder)
        let amountReminder1 = abs(amount1.remainder)
        let reversedAmountRemainder = 1 - amountRemainder
        let reversedAmountRemainder1 = 1 - amountReminder1
        let one = min(reversedAmountRemainder, amountRemainder)
        let two = min(reversedAmountRemainder1, amountReminder1)
        let miscalculation = min(one, two)
        return miscalculation

    }

    func check(_ gaps: [CGRect], with tracking: Tracking) -> Result {
        return check(gaps, withDistance: tracking.width, startPoint: tracking.startPoint)
    }

    func check(_ gaps: [CGRect], withDistance distance: CGFloat, startPoint: CGFloat) -> Result {

        let miscalculation = gaps
            .map { getMiscalculation($0, withDistance: distance, startPoint: startPoint) }
            .reduce(0, +)

        let average = miscalculation / CGFloat(gaps.count)
        print("sumRemainder: \(miscalculation.rounded(toPlaces: 4)), average \(average.rounded(toPlaces: 4))")
        let result = average < kMiscalculationSuccessedRate
        return (result, average)
    }

}
