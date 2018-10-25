//
//  TrackingStartPointGenerator.swift
//  CopyCode
//
//  Created by Артем on 25/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct TrackingStartPointGenerator {
    private let kGapWidthStep: CGFloat = 0.5

    func generate(from gap: CGRect) -> [CGFloat] {
        let range = (gap.leftX...gap.rightX).expandEqually(toDistance: 1)
        return range.splitToChunks(withStep: kGapWidthStep)
    }
}

extension ClosedRange where Bound == CGFloat {
    fileprivate func expandEqually(toDistance distance: CGFloat) -> TrackingRange {
        let difference = distance - self.distance
        guard difference > 0 else { return self }

        let addedValue = difference / 2
        let newRange = (lowerBound - addedValue)...(upperBound + addedValue)
        return newRange
    }
}
