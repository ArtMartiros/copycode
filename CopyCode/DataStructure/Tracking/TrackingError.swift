//
//  TrackingError.swift
//  CopyCode
//
//  Created by Артем on 04/12/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct TrackingError: ErrorRateProtocol {
    let tracking: Tracking
    let errorRate: CGFloat
}

extension Array where Element == TrackingError {
    var smallestErrorRate: TrackingError? {
        let trackings = sorted { $0.errorRate < $1.errorRate }
        return trackings.first
    }
}
