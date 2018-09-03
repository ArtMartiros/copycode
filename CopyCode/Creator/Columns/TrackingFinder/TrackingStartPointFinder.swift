//
//  TrackingStartPointFinder.swift
//  CopyCode
//
//  Created by Артем on 06/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct TrackingStartPointFinder {
    //если ширина мин гапа > 0, то тогда изменяем стартовую точку в пределе ширигны гапа в диапазоне kGapWidthStep
    private let kGapWidthStep: CGFloat = 0.5
    private let kRangeTimes = 4
    private let checker = TrackingChecker()
    func find(in gaps: [CGRect], with range: TrackingRange) -> [Tracking] {
        guard !gaps.isEmpty else { return [] }
        let (small, leftReversed, right) = gapsDivider(gaps)
        let trackings = findGapWithDifferentStep(small, leftReversed: leftReversed, right: right, range: range)
        return trackings
    }
    
    
    private func findGapWithDifferentStep(_ smallestGap: CGRect, leftReversed: [CGRect],
                                           right: [CGRect], range: TrackingRange) -> [Tracking] {
        let width = range.upperBound - range.lowerBound
        let singleWidth = width / CGFloat(kRangeTimes)
        let lastNumber = singleWidth == 0 ? 0 : kRangeTimes
        var trackings: [Tracking] = []
        for i in 0...lastNumber {
            let distance = range.lowerBound + (singleWidth * CGFloat(i))
            let points = findPointInDifferentStartPoint(smallestGap, leftReversed: leftReversed,
                                                           right: right, distance: distance)
            points.forEach { trackings.append(Tracking(startPoint: $0, width: distance)) }
        }
        return trackings
    }
    

    
    private func findPointInDifferentStartPoint(_ smallestGap: CGRect, leftReversed: [CGRect],
                                                right: [CGRect], distance: CGFloat) -> [CGFloat] {
        
        let distance = distance.rounded(toPlaces: 3)
        var points: [CGFloat] = []
        for point in getStartPoints(from: smallestGap) {
            print("\nfindPointInDifferentStartPoint , startPoint: \(point), distance: \(distance)")
            let gaps = leftReversed + right
            if checker.check(gaps, withDistance: distance, startPoint: point) {
                points.append(point)
            }
        }
        return points
    }
    
    private func getStartPoints(from gap: CGRect) -> [CGFloat] {
        let newGap = gap.width == 0 ? CGRect(x: gap.leftX - 0.5, y: gap.bottomY, width: 1, height: gap.height) : gap

        let amount = Int(newGap.width / kGapWidthStep)
        var startPoints: [CGFloat] = []
        for i in 0...amount {
            let point = newGap.leftX + (CGFloat(i) * kGapWidthStep)
            startPoints.append(point)
        }
        
        return startPoints
    }
    
//    private func findGapWithDifferentStep(_ smallestGap: CGRect,
//                                          gaps: [CGRect], range: TrackingRange) -> Tracking? {
//        let width = range.upperBound - range.lowerBound
//        let singleWidth = width / CGFloat(kRangeTimes)
//        let lastNumber = singleWidth == 0 ? 0 : kRangeTimes
//        for i in 0...lastNumber {
//            let distance = range.lowerBound + (singleWidth * CGFloat(i))
//            if let point = findPointInDifferentStartPoint(smallestGap, gaps: gaps, distance: distance) {
//                let tracking = Tracking(startPoint: point, width: distance)
//                return tracking
//            }
//        }
//        return nil
//    }
//
//    private func findPointInDifferentStartPoint(_ smallestGap: CGRect,
//                                        gaps: [CGRect], distance: CGFloat) -> CGFloat? {
//        let amount = Int(smallestGap.width / kGapWidthStep)
//        for i in 0...amount {
//            let leftX = smallestGap.leftX - 1
//            let startPoint = leftX + (CGFloat(i) * kGapWidthStep)
//            print("\nfindPointInDifferentStartPoint index \(i), startPoint: \(startPoint), distance: \(distance)")
//            if checker.check(gaps, withDistance: distance, startPoint: startPoint) {
//                return startPoint
//            }
//        }
//        return nil
//    }
    
    
    typealias DividedGaps = (smallest: CGRect, leftReversed: [CGRect], right: [CGRect])
    
    private func gapsDivider(_ gaps: [CGRect]) -> DividedGaps {
        var smallestWidth: CGFloat = 10
        var smallestIndex: Int = 0
        
        for (index, gap) in gaps.enumerated() {
            if gap.width < smallestWidth {
                smallestIndex = index
                smallestWidth = gap.width
            }
        }
        
        let leftReversed = Array(Array(gaps[0..<smallestIndex]).reversed())
        let nexIndex = smallestIndex + 1
        let right = Array(gaps[nexIndex..<gaps.count])
        let smallest = gaps[smallestIndex]
        print("smallest \(smallest) indes: \(smallestIndex)")
        return (smallest, leftReversed, right)
    }
    
   
}
