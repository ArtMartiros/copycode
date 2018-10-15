//
//  LeadingChecker.swift
//  CopyCode
//
//  Created by Артем on 13/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct LeadingChecker {

    func check(_ lines: [Line<LetterRectangle>], with leading: Leading) -> SimpleSuccess<Leading.Rate> {
        return check(lines, fontSize: leading.fontSize, spacing: leading.lineSpacing, at: leading.startPointTop)
    }
    
    func check(_ lines: [Line<LetterRectangle>], fontSize: CGFloat, spacing: CGFloat,
               at point: CGFloat) -> SimpleSuccess<Leading.Rate> {
        var errorRateSum: CGFloat = 0
        var preciseRateSum: CGFloat = 0
        
        lineLoop: for line in lines {
            let result = check(line, with: fontSize, and: spacing, at: point)
            switch result {
            case .failure: return .failure
            case .success(let errorRate, let preciseRate):
                errorRateSum += errorRate
                preciseRateSum += preciseRate
            }
        }
        return .success((errorRateSum, preciseRateSum))
    }
    
    private func check(_ line: Line<LetterRectangle>, with fontSize: CGFloat, and spacing: CGFloat,
                       at point: CGFloat) -> SimpleSuccess<Leading.Rate> {
        let leading = Leading(fontSize: fontSize, lineSpacing: spacing, startPointTop: point)
        return leading.checkIsFrameInsideLinePosition(frame: line.frame)
    }
}

