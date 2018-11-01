//
//  ForbiddensCreator.swift
//  CopyCode
//
//  Created by Артем on 01/11/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

extension TrackingInfoFinder {
    struct ForbiddensCreator {
        func create(from infos: [PositionInfo], lineIndex: Int) -> [Int: CGFloat] {
            var forbiddens: [Int: CGFloat] = [:]
            if infos.count > 1 {
                forbiddens[lineIndex] = infos[1].startX
            }
            return forbiddens
        }
    }
}
