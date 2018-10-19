//
//  Tracking.swift
//  CopyCode
//
//  Created by Артем on 06/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct Tracking: Codable {
    let width: CGFloat
    let startPoint: CGFloat
    init(startPoint: CGFloat, width: CGFloat) {
        self.width = width
        self.startPoint = startPoint
    }
}

extension Tracking {
    func nearestPointToLeftX(from frame: CGRect) -> CGFloat {
        let distance = abs(frame.leftX - startPoint)
        let result = startPoint + (frame.leftX < startPoint ? -distance : distance)
        return result
    }
    
    private var kErrorTrackingWidthPercent: CGFloat { return 30 }
    
    //разбивает frame с помощью tracking на мелкие фреймы
    func missingCharFrames(in frame: CGRect) -> [CGRect] {
        let updatedFrame = updateFrame(from: frame)
        var frames = updatedFrame.chunkToSmallRects(byWidth: width)
        guard let last = frames.last else { return [] }
        if !EqualityChecker.check(of: self.width, with: last.width, errorPercentRate: kErrorTrackingWidthPercent) {
            let _ = frames.removeLast()
        }
        return frames
    }
    
    //нужен обновленный фрейм исходя из стартовой позиции tracking иногда надо немного расщирить иногда сузить
    private func updateFrame(from frame: CGRect) -> CGRect {
        let nearestPoint = self.nearestPointToLeftX(from: frame)
        var newFrame: CGRect?
        var difference = nearestPoint - frame.leftX
        
        if nearestPoint < frame.leftX {
            difference += self.width
            if EqualityChecker.check(of: difference, with: self.width, errorPercentRate: kErrorTrackingWidthPercent) {
                newFrame = CGRect(left: nearestPoint, right: frame.rightX, top: frame.topY, bottom: frame.bottomY)
            }
        }
        return newFrame ?? frame.divided(atDistance: difference, from: .minXEdge).remainder
    }
}
