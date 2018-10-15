//
//  LeadingSpaceFinder.swift
//  CopyCode
//
//  Created by Артем on 17/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct LeadingSpaceFinder {
    private let kRangeTimes = 8
    private let fontSize: CGFloat
    private let checker = LeadingChecker()
    private let lines: [SimpleLine]
    
    func find(in range: LeadingRange, startPoint: CGFloat) -> [LeadigError] {
        let width = range.upperBound - range.lowerBound
        let widths = Slicer.sliceToArray(width: width, times: kRangeTimes)
        var leadingErrors: [LeadigError] = []
        for singleWidth in widths {
            let spacing = range.lowerBound + singleWidth - fontSize
            let leading = Leading(fontSize: fontSize, lineSpacing: spacing, startPointTop: startPoint)
            guard case .success(let error, let precise) = checker.check(lines, with: leading) else { continue }
            let leadingError = LeadigError(errorRate: error, preciseRate: precise, leading: leading)
            leadingErrors.append(leadingError)
        }
        return leadingErrors
    }
    
    init(block: Block<LetterRectangle>) {
        self.fontSize = block.maxLineHeight()
        self.lines = block.lines
    }
}
