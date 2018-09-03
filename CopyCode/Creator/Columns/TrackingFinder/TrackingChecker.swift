//
//  TrackingChecker.swift
//  CopyCode
//
//  Created by Артем on 06/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct TrackingChecker {
    typealias CountResult = (positive: Int, negative: Int)
    
    //проверяет текущий гап
    func check(_ gap: CGRect, withDistance distance: CGFloat, startPoint: CGFloat) -> Bool {
        let leftX: CGFloat
        let rightX: CGFloat

        if gap.width < 2 {
            leftX = gap.leftX - 0.5
            rightX = gap.rightX + 0.5
        } else if gap.width < 3 {
            leftX = gap.leftX - 0.2
            rightX = gap.rightX + 0.2
        } else {
            leftX = gap.leftX
            rightX = gap.rightX
        }

        let width =  leftX - startPoint
        let width1 =  rightX - startPoint
        var amount = (width / distance)
        var amount1 = (width1 / distance)
        amount.round(toPlaces: 1)
        amount1.round(toPlaces: 1)
        print("amount \(amount), amount1 \(amount1),  startPoint: \(startPoint), left \(leftX), right \(rightX) ")

        
        if abs(amount) < 1 {
            amount.round()
            amount1.round()
        }
        
        let integers = rangeOf(one: amount, two: amount1).integers
        return !integers.isEmpty
    }
    
    func check(_ gaps: [CGRect], with tracking: Tracking) -> Bool {
        return check(gaps, withDistance: tracking.width, startPoint: tracking.startPoint)
    }
    
    func check(_ gaps: [CGRect], withDistance distance: CGFloat, startPoint: CGFloat) -> Bool {
        for gap in gaps {
            if !check(gap, withDistance: distance, startPoint: startPoint) {
                return false
            }
        }
        return true
    }
    

    func checkWithCounts(_ gaps: [CGRect], with tracking: Tracking) -> CountResult {
        return checkWithCounts(gaps, withDistance: tracking.width, startPoint: tracking.startPoint)
    }

    func checkWithCounts(_ gaps: [CGRect], withDistance distance: CGFloat, startPoint: CGFloat) -> CountResult {
        var trueCount: Int = 0
        var falseCount: Int = 0
        for gap in gaps {
            if check(gap, withDistance: distance, startPoint: startPoint) {
                trueCount += 1
            } else {
                falseCount += 1
            }
        }
        
        return (trueCount, falseCount)
    }

    
//    func check(_ gaps: [CGRect], withDistance distance: CGFloat, startPoint: CGFloat) -> Bool {
//        for gap in gaps {
//            check(gap, withDistance: distance, startPoint: startPoint)
//        }
//        return true
//    }

}
