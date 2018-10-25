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
    fileprivate var array = SortedArray<CGFloat>()
    fileprivate (set) var dictionary: [CGFloat: Tracking] = [:]

    var trackings: [Tracking] {
        return dictionary.sorted { $0.key > $1.key }.map { $0.value }
    }

    ///записывай по топ позиции, вытаскивай по бот позиции для того чтобы точно входил
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

}

extension TrackingData: RatioUpdatable {
    func updated(by rate: Int) -> TrackingData {
        let floatRate = CGFloat(rate)

        let lower = self.range.lowerBound / floatRate
        let upper = self.range.upperBound / floatRate

        let defaultTracking = self.defaultTracking.updated(by: rate)

        var newData = TrackingData(range: lower...upper, defaultTracking: defaultTracking)

        for (key, value) in dictionary {
            let newKey = key / floatRate
            let newValue = value.updated(by: rate)
            newData[newKey] = newValue
        }

        return newData
    }
}
