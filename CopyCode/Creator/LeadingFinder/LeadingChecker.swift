//
//  LeadingChecker.swift
//  CopyCode
//
//  Created by Артем on 13/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct LeadingChecker {
    let maxLineHeight: CGFloat
    
    init(maxLineHeight: CGFloat) {
        self.maxLineHeight = maxLineHeight
    }
    
    func check(_ lines: [Line<LetterRectangle>], with distance: CGFloat, at point: CGFloat) -> Bool {
        let allCorrespond = lines.first { !check($0, with: distance, at: point) } == nil
        return allCorrespond
    }
    
    private func check(_ line: Line<LetterRectangle>, with distance: CGFloat, at point: CGFloat) -> Bool {
        let leading = Leading(fontSize: maxLineHeight, lineSpacing: distance - maxLineHeight, startPointTop: point)
        let isInside = leading.checkIsFrameInsideLinePosition(frame: line.frame)
        return isInside
    }
}


