//
//  PreliminaryTrackingChecker.swift
//  CopyCode
//
//  Created by Артем on 01/12/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct PreliminaryTrackingChecker {
    private let maxRateHight: CGFloat = 1.8
    ///чтобы исключить всякую хрень как логотипы
    func check(_ word: SimpleWord, trackingWidth: CGFloat) -> Bool {
        guard word.frame.height / trackingWidth < maxRateHight else { return false }

        for letter in word.letters {
            let width = letter.frame.width

            if width < trackingWidth ||
                EqualityChecker.check(of: width, with: trackingWidth, errorPercentRate: 10) {
                continue
            } else {
                let newWidth = (trackingWidth * 2)
                guard EqualityChecker.check(of: newWidth, with: width, errorPercentRate: 4) else {
                    return false
                }
            }
        }
        return true
    }
}
