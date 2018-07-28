//
//  WordFactor.swift
//  CopyCode
//
//  Created by Артем on 20/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

class WhiteColorChecker {
   private let backgroundWhite: CGFloat
    /// From 0 to 100%
    /// Диапазон от backgroundWhite до letterWhite в котором ответ считается правильным
    /// При 100% весь диапазон счтается правильным при 0% только letterWhite
    private let whitePercent: UInt
    init(backgroundWhite: CGFloat, whitePercent: UInt) {
        self.backgroundWhite = backgroundWhite
        self.whitePercent = whitePercent
    }

    func isRight(currentValue value: CGFloat, with letterWhite: CGFloat) -> Bool {
        let allowedInterval = abs(letterWhite - backgroundWhite) / 100 * CGFloat(whitePercent)
        let ranges = [allowedInterval, letterWhite].sorted(by: < )
        return ranges[0] ... ranges[1] ~= value
    }
}

protocol ColorFinderProtocol {
    var findedColor: CGFloat { get }
}

class BackgroundWhiteColorFinder: ColorFinderProtocol {

    private let wordFrame: CGRect
    private let lettersFrame: [CGRect]
    
    init(wordFrame: CGRect, lettersFrame: [CGRect]) {
        self.wordFrame = wordFrame
        self.lettersFrame = lettersFrame
    }
    
    var findedColor: CGFloat {
        return 0
    }
}

class LetterWhiteColorFinder: ColorFinderProtocol {
    private let letterFrame: CGRect
    init(letterFrame: CGRect) {
        self.letterFrame = letterFrame
    }
    var findedColor: CGFloat {
        return 0
    }
    
    
}

class WordFactor {
    private let zTLXRatio: CGFloat = 31
    private let frame: CGRect
    private let bitmap: NSBitmapImageRep
    
    var whiteFactor2: UInt {
        switch baseRatio {
        case let x where x < 1 && x > 2:  return 80
        case let x where x < 2: return 75
        default: return 60
        }
    }
    
    var whiteFactor: CGFloat {
        switch baseRatio {
        case let x where x < 1 && x > 2:  return 0.80
        case let x where x < 2: return 0.75
        default: return 0.6
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
    
    
    init(frame: CGRect, in bitmap: NSBitmapImageRep) {
        self.frame = frame
        self.bitmap = bitmap
    }
    
    func frameCrop() -> CGRect {
        let point = CGPoint(x: frame.minX + xyOffset, y: frame.minY + xyOffset)
        let size = CGSize(width: frame.width - sizeOffset, height: frame.height - sizeOffset)
        return CGRect(origin: point.rounded, size: size.rounded)
    }
    
//    func frameCropExtended() -> CGRect {
//        let leftXOffset = offsetX(left: true) + 1
//        let rightXOffset = offsetX(left: false) + 1
//        let topOffsetY = offsetY(isBottom: false)
//        let bottomOffsetY = offsetY(isBottom: true)
//        let width = round(frame.width) - leftXOffset - rightXOffset
//        let height = round(frame.height) - bottomOffsetY - topOffsetY
//        return CGRect(x: round(frame.origin.x) + leftXOffset,
//                      y: round(frame.origin.y) + bottomOffsetY,
//                      width: width, height: height)
//    }
//
//    private let arrayOfParts = [5, 0, 10, 1, 9, 2, 8, 3, 7, 4, 6]
//
//    private func offsetX(left: Bool) -> CGFloat {
//        let x = round(left ? frame.minX : frame.maxX)
//        var newX = x
//        let thing = true
//        while thing {
//            for i in arrayOfParts {
//                let y = frame.yPositionAs(part: i, of: 10)
//                if bitmap.isGrayscale(at: CGPoint(x: newX, y: y), in: frame) {
//                    return abs(newX - x)
//                }
//            }
//            newX = newX + (left ? 1 : -1)
//        }
//    }
//
//    private func offsetY(isBottom: Bool) -> CGFloat {
//        let y = round(isBottom ? frame.minY : frame.maxY)
//        var newY = y
//        let thing = true
//        while thing {
//            for i in arrayOfParts {
//                let x = frame.xPositionAs(part: i, of: 10)
//                if bitmap.isGrayscale(at: CGPoint(x: x, y: newY), in: frame) {
//                    return abs(newY - y)
//                }
//
//            }
//            newY = newY + (isBottom ? 1 : -1)
//        }
//
//    }
    
}


