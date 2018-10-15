//
//  LeadingMostAccurateFinder.swift
//  CopyCode
//
//  Created by Артем on 17/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct LeadingMostAccurateFinder {
    func find(from errors: [LeadigError]) -> Leading? {
        let value = errors
            .sorted { $0.errorRate < $1.errorRate }
            .chunkForSorted { $0.errorRate == $1.errorRate }
        let chanked = value
            .first?
            .sorted { $0.preciseRate > $1.preciseRate }
            .first
        return chanked?.leading
    }
}
