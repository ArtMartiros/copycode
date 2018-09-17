//
//  TypographicalGrid.swift
//  CopyCode
//
//  Created by Артем on 16/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct TypographicalGrid: Codable {
    let trackingData: TrackingData
    let leading: Leading
    
    init(data: TrackingData, leading: Leading) {
        self.trackingData = data
        self.leading = leading
    }
}

extension TypographicalGrid {
    func getArrayOfFrames(from frame: CGRect) -> [[CGRect]] {
        print(frame)
        let lineFrames = leading.missingLinesFrame(in: frame)
        let arrayOfFrames: [[CGRect]] = lineFrames.map {
            let tracking = trackingData[$0.topY]
            return tracking.missingCharFrames(in: $0)
        }
        return arrayOfFrames
    }
}
