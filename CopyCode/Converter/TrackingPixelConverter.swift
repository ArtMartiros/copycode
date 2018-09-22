//
//  TrackingPixelConverter.swift
//  CopyCode
//
//  Created by Артем on 27/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct TrackingPixelConverter {
    static func toPixel(from tracking: Tracking) -> Tracking {
        let startPoint = PixelConverter.shared.toPixel(from: tracking.startPoint)
        let width = PixelConverter.shared.toPixel(from: tracking.width)
        return Tracking(startPoint: startPoint, width: width)
    }
}
