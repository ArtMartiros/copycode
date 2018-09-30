//
//  LineData.swift
//  CopyCode
//
//  Created by Артем on 13/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation
///Структура состоит из высоты линии, междустрочный интервал и стартовой позиции
struct Leading: Codable {
    let fontSize: CGFloat
    let lineSpacing: CGFloat
    let startPointTop: CGFloat
    
    init(fontSize: CGFloat, lineSpacing: CGFloat, startPointTop: CGFloat) {
        self.fontSize = fontSize
        self.lineSpacing = lineSpacing
        self.startPointTop = startPointTop
    }
}

extension Leading {
    ///sum of **fontSize** and **lineSpacing**
    var leading: CGFloat {
        return fontSize + lineSpacing
    }

    func checkIsFrameInsideLinePosition(frame: CGRect) -> Bool {
        let point = findNearestPointTop(to: frame)
        let errorRate: CGFloat = 1
        guard !(point < frame.topY &&
            !EqualityChecker.check(of: point, with: frame.topY, errorPercentRate: errorRate))
            else { return false }
        
        let lowerPoint = point - fontSize
        if lowerPoint <= frame.bottomY {
            return true
        } else {
            return EqualityChecker.check(of: lowerPoint, with: frame.bottomY, errorPercentRate: errorRate)
        }
    }
    
    func missingLinesFrame(in frame: CGRect) -> [CGRect] {
        guard frame.height > leading else { return [] }
        let startPoint = findStartPoint(inside: frame)
        let difference = frame.topY - startPoint
        let height = startPoint - frame.bottomY
        let lineCount = ((height - fontSize - difference) / leading).rounded()
        
        var currentFrame = frame
        var frames: [CGRect] = []
        
        for i in 0...Int(lineCount) {
            let afterDistance = i == 0 ? difference : lineSpacing
            let divided = currentFrame.divided(atDistance: fontSize,
                                        afterDistance: afterDistance, from: .maxYEdge)
            frames.append(divided.slice)
            currentFrame = divided.remainder
        }
        return frames
    }
    
    private func findNearestPointTop(to frame: CGRect) -> CGFloat {
        let distance = abs(frame.topY - startPointTop)
        let value = (distance / leading).rounded()
        if frame.topY < startPointTop {
            let point = startPointTop - value * leading
            return point
        } else {
            let point = startPointTop + value * leading
            return point
        }
    }
    
    ///topY
    func findStartPoint(inside frame: CGRect) -> CGFloat {
        let point = findNearestPointTop(to: frame)
        var startPoint = point
        if point > frame.topY, !EqualityChecker.check(of: point, with: frame.topY, errorPercentRate: 10) {
            startPoint -= leading
        }
        return startPoint
    }
    
    func createVirtualFrame(from frame: CGRect) -> CGRect {
        let startPoint = findStartPoint(inside: frame) - fontSize
        let frame = CGRect(x: frame.origin.x, y: startPoint, width: frame.width, height: fontSize)
        return frame
    }
    
    
}

enum Position {
    case top
    case mid
    case bottom
}

protocol TypeChecker {
    func maxHeightRatio(with frame: CGRect) -> CGFloat
    func lowWithTail(with frame: CGRect) -> Bool
    func quotesOrColumn(with frame: CGRect) -> Bool
    func exist(in position: Position, with frame: CGRect) -> Bool
}
