//
//  WordFactor.swift
//  CopyCode
//
//  Created by Артем on 20/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

struct WordFactor {
    private let kRatioValue: CGFloat = 25
    private let frame: CGRect
    private var baseRatio: CGFloat { return frame.height / kRatioValue }
    private var xyOffset: CGFloat { return round(baseRatio) }
    private var sizeOffset: CGFloat { return xyOffset * 2 }
    
    var whiteRate: UInt {
        print("baseRatio \(baseRatio)")
        switch baseRatio {
        case let x where x > 0 && x < 0.8:  return 65
        case let x where x >= 0.8 && x < 1:  return 80
        case let x where x >= 1 && x < 1.45:  return 70
        case let x where x >= 1.45 && x < 3:  return 65
        case let x where x >= 3: return 45
        default: return 25
        }
    }
    

    
    init(frame: CGRect) {
        self.frame = frame
    }
    
    init(rectangle: PixelRectangle) {
        self.frame = rectangle.pixelFrame
    }
    
    func frameCrop() -> CGRect {
        let point = CGPoint(x: frame.minX + xyOffset, y: frame.minY + xyOffset)
        let size = CGSize(width: frame.width - sizeOffset, height: frame.height - sizeOffset)
        return CGRect(origin: point.rounded, size: size.rounded)
    }
}


