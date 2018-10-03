//
//  TrackingFinder.swift
//  CopyCode
//
//  Created by Артем on 02/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct TrackingFinder {
    private let startPointFinder = TrackingStartPointFinder()
    private let distanceFinder = TrackingDistanceFinder()
    
    func findTrackings(from word: SimpleWord) -> [Tracking] {
        let result = distanceFinder.find(from: word)
        switch result {
        case .success(let range):
            let trackings = startPointFinder.find(in: word, with: range)
            return trackings
        case .failure:
            return []
        }
    }
}
