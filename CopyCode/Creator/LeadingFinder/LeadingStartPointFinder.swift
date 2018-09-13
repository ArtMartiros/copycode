//
//  LeadingStartPointFinder.swift
//  CopyCode
//
//  Created by Артем on 13/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct LeadingStartPointFinder {
    let lines: [Line<LetterRectangle>]
    let maxLineHeight: CGFloat
    let gaps: [CGRect]
    private let kRangeTimes = 4
    private let kLineStartPositionStep: CGFloat = 0.5
    private let checker: LeadingChecker
    
    func find(in range: LeadingRange) -> [Leading] {
       return findPointWithDifferentStep(in: range)
    }

    private func findPointWithDifferentStep(in range: LeadingRange) -> [Leading] {
        let width = range.upperBound - range.lowerBound
        let widths = Slicer.sliceToArray(width: width, times: kRangeTimes)
        var leadings: [Leading] = []
        for singleWidth in widths {
            let leading = range.lowerBound + singleWidth
            let points = findPointInDifferentStartPoint(leading: leading)
            let gap = (leading - maxLineHeight).rounded(toPlaces: 2)
            let newLeadings = points.map { Leading(fontSize: maxLineHeight, lineSpacing: gap, startPointTop: $0) }
            leadings.append(contentsOf: newLeadings)
        }
        
        return leadings
    }
    
    private func findPointInDifferentStartPoint(leading: CGFloat) -> [CGFloat] {
        let leading = leading.rounded(toPlaces: 2)
        let points = getStartPoints().filter { checker.check(lines, with: leading, at: $0) }
        return points
    }
    
    private func getStartPoints() -> [CGFloat] {
        let maxLine = lines.sorted { $0.frame.height > $1.frame.height }[0]
        return [maxLine.frame.topY + 0.5, maxLine.frame.topY, maxLine.frame.topY - 0.5]
    }
}

extension LeadingStartPointFinder {
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
        self.checker = LeadingChecker(maxLineHeight: maxLineHeight)
    }
}
