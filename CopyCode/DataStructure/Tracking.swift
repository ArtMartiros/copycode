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
    
    private var kErrorTrackingWidthPercent: CGFloat { return 10 }
    
    //разбивает frame с помощью tracking
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
        let nearestPoint = self.nearestPoint(to: frame)
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

struct TrackingPixelConverter {
    static func toPixel(from tracking: Tracking) -> Tracking {
        let startPoint = PixelConverter.shared.toPixel(from: tracking.startPoint)
        let width = PixelConverter.shared.toPixel(from: tracking.width)
        return Tracking(startPoint: startPoint, width: width)
    }
}

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
    fileprivate var dictionary: [CGFloat:Tracking] = [:]
    
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
