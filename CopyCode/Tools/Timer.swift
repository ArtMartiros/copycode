//
//  Timer.swift
//  CopyCode
//
//  Created by Артем on 18/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

final class Timer {
    private static var startTime: CFAbsoluteTime = 0
    private static var stopTime: CFAbsoluteTime = 0
    private static var previous: String = ""
    static func start() {
        startTime = CFAbsoluteTimeGetCurrent()
        stopTime = CFAbsoluteTimeGetCurrent()
    }

    static func stop(text: String) {
        let newStop = CFAbsoluteTimeGetCurrent()
        let stopDiff = newStop - stopTime
        stopTime = newStop
        let diff = stopTime - startTime
        if !previous.isEmpty {
            Swift.print("(\(previous) ➡️ \(text)): \(stopDiff.rounded(toPlaces: 4))")
        }
        Swift.print("(\(text)): \(diff.rounded(toPlaces: 4)) 🏁")
        previous = text
    }
}
