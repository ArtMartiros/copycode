//
//  LeadingStartPointFinder.swift
//  CopyCode
//
//  Created by Артем on 13/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct LeadingStartPointFinder {
    struct LeadigError: ErrorRateProtocol {
        let errorRate: CGFloat
        let preciseRate: CGFloat
        let leading: Leading
    }
    
    let lines: [Line<LetterRectangle>]
    let maxLineHeight: CGFloat
    let gaps: [CGRect]
    private let kRangeTimes = 8
    private let kLineStartPositionStep: CGFloat = 0.5
    private let checker: LeadingChecker
    
    func find(in range: LeadingRange) -> Leading? {
        let leadingsErrors = findPointWithDifferentStep(in: range)
        let value = leadingsErrors
            .sorted { $0.errorRate < $1.errorRate }
            .chunkForSorted { $0.errorRate == $1.errorRate }
        let chanked = value
            .first?
            .sorted { $0.preciseRate > $1.preciseRate }
            .first
        
        return chanked?.leading
    }

    private func findPointWithDifferentStep(in range: LeadingRange) -> [LeadigError] {
        let width = range.upperBound - range.lowerBound
        let widths = Slicer.sliceToArray(width: width, times: kRangeTimes)
        var leadingErrors: [LeadigError] = []
        for singleWidth in widths {
            let leading = range.lowerBound + singleWidth
            let newLeadingErrors = findLeadingErrorsInDifferentStartPoint(leading: leading)
            leadingErrors.append(contentsOf: newLeadingErrors)
        }
        
        return leadingErrors
    }
    
    private func findLeadingErrorsInDifferentStartPoint(leading: CGFloat) -> [LeadigError] {
        let gap = (leading - maxLineHeight).rounded(toPlaces: 3)
        let leading = leading.rounded(toPlaces: 3)
        var leadingErrors: [LeadigError] = []
        for point in getStartPoints() {
            if case .success(let error, let precise) = checker.check(lines, with: leading, at: point) {
                let newLeading = Leading(fontSize: maxLineHeight, lineSpacing: gap, startPointTop: point)
                let leadingError = LeadigError(errorRate: error, preciseRate: precise, leading: newLeading)
                leadingErrors.append(leadingError)
            }
        }
       
        return leadingErrors
    }
    
    private func getStartPoints() -> [CGFloat] {
        let maxLine = lines.sorted { $0.frame.height > $1.frame.height }[0]
        return [maxLine.frame.topY + 1,
                maxLine.frame.topY + 0.75,
                maxLine.frame.topY + kLineStartPositionStep,
                maxLine.frame.topY,
                maxLine.frame.topY - kLineStartPositionStep,
                maxLine.frame.topY - 0.75,
                maxLine.frame.topY - 1]
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
