//
//  LeadingStartPointGenerator.swift
//  CopyCode
//
//  Created by Артем on 17/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct LeadingStartPointGenerator {

    private let kStep: CGFloat = 0.25
    private let kExpanded: CGFloat = 2
    func generate(from point: CGFloat) -> [CGFloat] {
        let range = (point - kExpanded)...(point + kExpanded)
        return range.splitToChunks(withStep: kStep)
    }
}
