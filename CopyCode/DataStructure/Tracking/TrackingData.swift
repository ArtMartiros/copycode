//
//  TrackingData.swift
//  CopyCode
//
//  Created by Артем on 27/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct TrackingData: Codable {
    let range: TrackingRange

    init(range: TrackingRange, defaultTracking: Tracking) {
        self.range = range
        self.defaultTracking = defaultTracking
        let yPosition = range.upperBound
        dictionary[yPosition] = defaultTracking
        array.insert(yPosition)
    }

    fileprivate (set) var defaultTracking: Tracking
    fileprivate (set) var array = SortedArray<CGFloat>()
    fileprivate var dictionary: [CGFloat: Tracking] = [:]

    subscript(yPosition: CGFloat) -> Tracking {
        get {
            let nearestNextIndex = array.index(for: yPosition)
            guard range.contains(yPosition),
                !array.isEmpty,
                nearestNextIndex < array.count else { return defaultTracking }

            let element = array[nearestNextIndex]
            return dictionary[element] ?? defaultTracking
        }
        set {
            dictionary[yPosition] = newValue
            array.insert(yPosition)
        }
    }

    mutating func insert(toTopY newElement: Tracking) {
        let yPosition = range.upperBound
        dictionary[yPosition] = newElement
        array.insert(yPosition)
    }
}
