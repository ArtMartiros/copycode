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
    

    func checkFrameInsideLinePosition(frame: CGRect) -> Bool {
        let point = findNearestPoint(to: frame)
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
    
    func findMissingLineFrames(in frame: CGRect) -> [CGRect] {
        let lineCount = (frame.height / leading).rounded(.down)
        guard lineCount != 0 else { return [] }
        let startPoint = findStartPoint(inside: frame)
        let difference = frame.topY - startPoint
        var currentFrame = frame
        var frames: [CGRect] = []
        
        for i in 0..<Int(lineCount) {
            let afterDistance = i == 0 ? difference : lineSpacing
            let divided = currentFrame.divided(atDistance: fontSize,
                                        afterDistance: afterDistance, from: .maxYEdge)
            frames.append(divided.slice)
            currentFrame = divided.remainder
        }
        return frames
    }
    
    private func findNearestPoint(to frame: CGRect) -> CGFloat {
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
    
    
    private func findStartPoint(inside frame: CGRect) -> CGFloat {
        let point = findNearestPoint(to: frame)
        var startPoint = point
        if point > frame.topY {
            startPoint -= leading
        }
        return startPoint
    }
}
