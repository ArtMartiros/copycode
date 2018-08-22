//
//  ClosedRange.swift
//  CopyCode
//
//  Created by Артем on 21/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

extension ClosedRange where Bound == CGFloat{
    func intesectedGap(with newRange: ClosedRange<CGFloat>) -> ClosedRange<CGFloat>? {
        guard contains(newRange.lowerBound) || contains(newRange.upperBound)
            else { return nil }
        return clamped(to: newRange)
    }
    
    var distance: CGFloat {
        return upperBound - lowerBound
    }
}
