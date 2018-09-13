//
//  Tracking.swift
//  CopyCode
//
//  Created by Артем on 06/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct TrackingInfo: Codable {
    let tracking: Tracking?
    let startIndex: Int
    let endIndex: Int
    init(tracking: Tracking?, startIndex: Int, endIndex: Int) {
        self.tracking = tracking
        self.startIndex = startIndex
        self.endIndex = endIndex
    }
}

struct Tracking: Codable {
    let width: CGFloat
    let startPoint: CGFloat
    init(startPoint: CGFloat, width: CGFloat) {
        self.width = width
        self.startPoint = startPoint
    }
}

extension Tracking {
    func nearestPoint(to frame: CGRect) -> CGFloat {
        let distance = abs(frame.leftX - startPoint)
        let value = (distance / width).rounded()
        
        if frame.leftX < startPoint {
            let point = startPoint - value * width
            return point
        } else {
            let point = startPoint + value * width
            return point
        }
    }
}

struct TrackingPixelConverter {
    static func toPixel(from tracking: Tracking) -> Tracking {
        let startPoint = PixelConverter.shared.toPixel(from: tracking.startPoint)
        let width = PixelConverter.shared.toPixel(from: tracking.width)
        return Tracking(startPoint: startPoint, width: width)
    }
}
