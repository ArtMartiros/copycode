//
//  GapsCreator.swift
//  CopyCode
//
//  Created by Артем on 21/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

final class GapsCreator {
    func createVertical(from rects: [StandartRectangle], last: CGFloat) -> [ClosedRange<CGFloat>] {
        var gaps: [ClosedRange<CGFloat>] = []
        for (index, rect) in rects.enumerated() {
            if index == 0 { gaps.append(0.0...rect.frame.bottomY) }
            let nextIndex = index + 1
            if rects.count > nextIndex {
                let nextRect = rects[nextIndex]
                if rect.frame.topY < nextRect.frame.bottomY {
                    gaps.append(rect.frame.topY...nextRect.frame.bottomY)
                }
            } else {
                gaps.append(rect.frame.topY...last)
            }
        }
        return gaps
    }
}
