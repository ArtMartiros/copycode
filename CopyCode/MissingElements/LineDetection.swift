//
//  LineDetection.swift
//  CopyCode
//
//  Created by Артем on 30/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

class LineDetection {
    private let rate: CGFloat = 0.5
    
    func getLinesCount(from mainGap: CGRect, lineHeight: CGFloat) -> CGFloat {
        let gapHeight = lineHeight * rate
        let height = mainGap.height - gapHeight
        let counts = height / (lineHeight + gapHeight)
        return counts.rounded()
    }
    
    func getLines(from mainGap: CGRect, lineHeight: CGFloat) -> [CGRect] {
        let lineCount = getLinesCount(from: mainGap, lineHeight: lineHeight)
        let allLineHeight = lineHeight * lineCount
        let averageGapHeight = (mainGap.height - allLineHeight) / (lineCount + 1)
        var lastGap = mainGap
        var lines: [CGRect] = []
        for _ in 0..<Int(lineCount) {
            let divided = lastGap.divided(atDistance: lineHeight, afterDistance: averageGapHeight, from: .maxYEdge)
            lines.append(divided.slice)
            lastGap = divided.remainder
        }
        return lines
    }
}
