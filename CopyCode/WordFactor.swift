//
//  WordFactor.swift
//  CopyCode
//
//  Created by Артем on 20/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

final class LetterPixelChecker {
   private let backgroundWhite: CGFloat
    /// From 0 to 100%
    /// Диапазон от backgroundWhite до letterWhite в котором ответ считается правильным
    /// При 100% весь диапазон счтается правильным при 0% только letterWhite
    private let whitePercent: UInt
    init(backgroundWhite: CGFloat, whitePercent: UInt) {
        self.backgroundWhite = backgroundWhite
        self.whitePercent = whitePercent
    }

    func exist(currentValue value: CGFloat, withLetterDefaultWhite letterWhite: CGFloat) -> Bool {
        let allowedInterval = abs(letterWhite - backgroundWhite) / 100 * CGFloat(whitePercent)
        if letterWhite >= backgroundWhite{
            let startPoint = letterWhite - allowedInterval
            let range = startPoint.rounded(toPlaces: 3) ... 1
            print("Range \(range)")
            return range ~= value
        } else {
            let endPoint = letterWhite + allowedInterval
            let range =  0...endPoint.rounded(toPlaces: 3)
            print("Range \(range)")
            return range ~= value
        }
    }
}


final class WordFactor {
    private let zTLXRatio: CGFloat = 31
    private let frame: CGRect
    
    var whiteRate: UInt {
        switch baseRatio {
        case let x where x > 0 && x < 1:  return 55
        case let x where x > 1 && x < 3:  return 65
        case let x where x >= 3: return 45
        default: return 25
        }
    }
    
    private var baseRatio: CGFloat {
        return frame.height / 25
    }
    
    var zTLx: CGFloat {
        return frame.width / zTLXRatio
    }
    
    var zTLXWhite: CGFloat {
        return  zTLx < 1 ? 0.75 : 0.5
    }
    
    private var xyOffset: CGFloat {
        return round(baseRatio)
    }
    
    private var sizeOffset: CGFloat {
        return xyOffset * 2
    }
    
    
    init(frame: CGRect) {
        self.frame = frame
    }
    
    func frameCrop() -> CGRect {
        let point = CGPoint(x: frame.minX + xyOffset, y: frame.minY + xyOffset)
        let size = CGSize(width: frame.width - sizeOffset, height: frame.height - sizeOffset)
        return CGRect(origin: point.rounded, size: size.rounded)
    }
}


