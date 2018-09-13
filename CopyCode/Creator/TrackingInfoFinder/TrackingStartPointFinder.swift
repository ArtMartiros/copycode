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
        let trackings = findPointWithDifferentStep(small, leftReversed: leftReversed, right: right, range: range)
        return trackings
    }
    
    
    private func findPointWithDifferentStep(_ smallestGap: CGRect, leftReversed: [CGRect],
                                           right: [CGRect], range: TrackingRange) -> [Tracking] {
        let width = range.upperBound - range.lowerBound
        let widths = Slicer.sliceToArray(width: width, times: kRangeTimes)
        var trackings: [Tracking] = []
        for singleWidth in widths {
            let distance = range.lowerBound + singleWidth
            let points = findPointInDifferentStartPoint(smallestGap, leftReversed: leftReversed,
                                                        right: right, distance: distance)
            points.forEach { trackings.append(Tracking(startPoint: $0, width: distance)) }
        }

        return trackings
    }
    

    
    private func findPointInDifferentStartPoint(_ smallestGap: CGRect, leftReversed: [CGRect],
                                                right: [CGRect], distance: CGFloat) -> [CGFloat] {
        
        let distance = distance.rounded(toPlaces: 3)
        let gaps = leftReversed + right
        let points = getStartPoints(from: smallestGap).filter {
            checker.check(gaps, withDistance: distance, startPoint: $0)
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
