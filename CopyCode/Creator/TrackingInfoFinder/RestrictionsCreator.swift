//
//  RestrictionsCreator.swift
//  CopyCode
//
//  Created by Артем on 01/11/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct LineRestriction: Codable {
    var leftX: CGFloat?
    var rightX: CGFloat?

    init(leftX: CGFloat? = 0, rightX: CGFloat? = 0) {
        self.leftX = leftX
        self.rightX = rightX
    }
}

extension TrackingInfoFinder {
    struct PositionInfoWithForbidden {
        let posInfo: PositionInfo
        let forbiddens: [Int: LineRestriction]
    }

    struct RestrictionsCreator {
        ///определяет границы для каждого posInfo
        func create(from infos: [PositionInfo], lineIndex: Int) -> [PositionInfoWithForbidden] {
            var infosWithForbidden: [PositionInfoWithForbidden] = []
            for item in infos.previousCurrentNext() {
                let forbidden = LineRestriction(leftX: item.previous?.lastKnowX, rightX: item.next?.startX)
                let info = PositionInfoWithForbidden(posInfo: item.present, forbiddens: [lineIndex: forbidden])
                infosWithForbidden.append(info)
            }
            return infosWithForbidden
        }
    }
}
