//
//  LeadingDistanceFinder.swift
//  CopyCode
//
//  Created by Артем on 13/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

typealias LeadingRange = ClosedRange<CGFloat>

struct LeadingDistanceFinder {
    let lines: [Line<LetterRectangle>]
    let maxLineHeight: CGFloat
    let gaps: [CGRect]

    func find() -> LeadingRange? {
        guard !gaps.isEmpty, let first = lines.first, let last = lines.last else { return nil }
        let linesCount = findCompleteLinesCount()
        let distanceRange = findRangeDistance(topmostLine: first, bottommostLine: last)
        let leadingRange = findLeadingRange(in: distanceRange, linesCount: linesCount)
        return leadingRange
    }

    private func findCompleteLinesCount() -> Int {
        let additionalCount = findAdditionalCount()
        return lines.count + additionalCount
    }

    private func findAdditionalCount() -> Int {
        let gapHeight = calculateGapHeight()
        var additionalCount = 0
        let height = maxLineHeight + gapHeight
        for gap in gaps {
            let counts = gap.height / height
            additionalCount += Int(counts.rounded(.down))
        }
        return additionalCount
    }

    //при случае когда минимальный гап это два гапа и больше
    private func calculateGapHeight() -> CGFloat {
        let gapHeight = gaps.sorted { $0.height < $1.height }[0].height
        guard gapHeight > maxLineHeight else { return gapHeight }
        let preliminaryGapHeight = maxLineHeight / 2
        let height = gapHeight - preliminaryGapHeight

        let count = (height / maxLineHeight).rounded(.down)
        let allLineHeight = maxLineHeight * count
        let allGapsHeight = gapHeight - allLineHeight
        let newGapHeight = allGapsHeight / (count + 1)
        return newGapHeight
    }

    private func findLeadingRange(in distance: LeadingRange, linesCount: Int) -> LeadingRange {
        let minResult = findLeading(in: distance.lowerBound, count: linesCount)
        let maxResult = findLeading(in: distance.upperBound, count: linesCount)
        return minResult...maxResult
    }

    private func findLeading(in distance: CGFloat, count: Int) -> CGFloat {
        let result = ((distance - maxLineHeight) / CGFloat(count - 1)).rounded(toPlaces: 1)
        return result
    }

    private func findRangeDistance(topmostLine: Line<LetterRectangle>,
                                   bottommostLine: Line<LetterRectangle>) -> LeadingRange {
        let startPoint = topmostLine.frame.topY
        let lastPoint = bottommostLine.frame.bottomY

        let startPointDifference = maxLineHeight - topmostLine.frame.height
        let lastPointDifference = maxLineHeight - bottommostLine.frame.height

        let minDistanceBetweenLines = startPoint - lastPoint
        let maxDistanceBetweenLines = minDistanceBetweenLines + startPointDifference + lastPointDifference
        return minDistanceBetweenLines...maxDistanceBetweenLines
    }
}

extension LeadingDistanceFinder {
    init(block: Block<LetterRectangle>) {
        let lines = block.lines
        let maxLineHeight = block.maxLineHeight()
        let gaps = block.gaps.map { $0.frame }
        self.init(lines: lines, gaps: gaps, maxLineHeight: maxLineHeight)
    }

    init(lines: [Line<LetterRectangle>], gaps: [CGRect], maxLineHeight: CGFloat) {
        self.lines = lines
        self.gaps = gaps
        self.maxLineHeight = maxLineHeight
    }
}
