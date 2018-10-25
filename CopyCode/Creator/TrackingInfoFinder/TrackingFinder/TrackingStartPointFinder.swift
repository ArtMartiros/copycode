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
    private let generator = TrackingStartPointGenerator()

    func find(in word: SimpleWord, with range: TrackingRange) -> [Tracking] {
        let trackings = findPointWithDifferentStep(word, range: range)
        return trackings
    }

    private func findPointWithDifferentStep(_ word: SimpleWord, range: TrackingRange) -> [Tracking] {

        let wordGaps = word.fixedGapsWithOutside
        let width = range.upperBound - range.lowerBound
        let widths = Slicer.sliceToArray(width: width, times: kRangeTimes)
        var trackings: [Tracking] = []
        for singleWidth in widths {
            let distance = range.lowerBound + singleWidth
            guard let gaps = Gap.updatedOutside(wordGaps, with: distance), !gaps.isEmpty else { continue }
            let (smallestGap, leftReversed, right) = gapsDivider(gaps)
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

        let points = generator.generate(from: smallestGap).filter {
            checker.check(gaps, withDistance: distance, startPoint: $0).result
        }

        return points
    }

    typealias DividedGaps = (smallest: CGRect, leftReversed: [CGRect], right: [CGRect])

    private func gapsDivider(_ gaps: [CGRect]) -> DividedGaps {
        var smallestWidth: CGFloat = 10
        var smallestIndex: Int = 0

        for (index, gap) in gaps.enumerated() where gap.width < smallestWidth {
            smallestIndex = index
            smallestWidth = gap.width
        }

        let leftReversed = Array(Array(gaps[0..<smallestIndex]).reversed())
        let nexIndex = smallestIndex + 1
        let right = Array(gaps[nexIndex..<gaps.count])
        let smallest = gaps[smallestIndex]
        print("smallest \(smallest) indes: \(smallestIndex)")
        return (smallest, leftReversed, right)
    }

}
