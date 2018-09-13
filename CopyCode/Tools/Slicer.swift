//
//  Slicer.swift
//  CopyCode
//
//  Created by Артем on 13/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct Slicer {
    static func sliceToArray(width: CGFloat, times: Int) -> [CGFloat] {
        let singleWidth = width / CGFloat(times)
        let lastNumber = singleWidth == 0 ? 0 : times
        let array = (0...Int(lastNumber)).map { CGFloat($0) * singleWidth }
        return array
    }
    
    ///sliceToArray(width: 10, byStep: 3) return [0, 3, 6, 9, 1]
    static func sliceToArray(width: CGFloat, byStep step: CGFloat) -> [CGFloat] {
        guard step != 0 else { return [] }
        let times = width / step
        let lastNumber = step == 0 ? 0 : times
        var array = (0...Int(lastNumber)).map { CGFloat($0) * step }
        guard let last = array.last else { return [] }
        if last != width {
            array.append(width - last)
        }
        return array
    }
}
