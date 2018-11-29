//
//  Gap.swift
//  CopyCode
//
//  Created by Артем on 30/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct Gap: Rectangle {
    func updated(by rate: Int) -> Gap {
       let frame = updatedFrame(by: rate)
       return Gap(frame: frame)
    }

    let frame: CGRect
    init(frame: CGRect) {
        self.frame = frame
    }
}

extension Gap {
    private static var errorRate: CGFloat = 7
    static func updatedOutside(_ gaps: [CGRect], with letterWidth: CGFloat) -> [CGRect]? {
        guard gaps.count > 1 else { return gaps }
        var gaps = gaps

        guard let first = getCutedFirst(from: gaps, letterWidth: letterWidth),
            let last = getCutedLast(from: gaps, letterWidth: letterWidth) else { return nil }

        gaps[0] = first
        gaps[gaps.count - 1] = last
        return gaps
    }

    static func getCutedFirst(from gaps: [CGRect], letterWidth: CGFloat) -> CGRect? {
        guard gaps.count > 1 else { return gaps.first }
        return getCutedGap(outer: gaps[0], inner: gaps[1],
                           letterWidth: letterWidth, edge: .minXEdge)
    }

    static func getCutedLast(from gaps: [CGRect], letterWidth: CGFloat) -> CGRect? {
        let count = gaps.count
        guard count > 1 else { return gaps.first }
        let penultimate = gaps[count - 2]
        let last = gaps[count - 1]
        return getCutedGap(outer: last, inner: penultimate,
                           letterWidth: letterWidth, edge: .maxXEdge)
    }

    private static func getCutedGap(outer: CGRect, inner: CGRect, letterWidth: CGFloat, edge: CGRectEdge) -> CGRect? {
        let letterWidth = letterWidth
        let width = outer.width + minWidth(between: outer, and: inner)
        if width < letterWidth {
            return outer
        } else {
            let difference = width - letterWidth
            guard difference <= outer.width ||
                EqualityChecker.check(of: difference, with: outer.width, errorPercentRate: errorRate)
                else { return nil }

            let divider = outer.divided(atDistance: difference, from: edge)
            return divider.remainder
        }
    }

    private static func minWidth(between left: CGRect, and right: CGRect) -> CGFloat {
        let distance1 = abs(left.leftX - right.rightX)
        let distance2 = abs(left.rightX - right.leftX)
        let distance = min(distance1, distance2)
        return distance
    }
}
