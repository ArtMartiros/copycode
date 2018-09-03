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
