//
//  LeadingStartPointGenerator.swift
//  CopyCode
//
//  Created by Артем on 17/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct LeadingStartPointGenerator {

    private let kLineStartPositionStep: CGFloat = 0.5

    func generate(from point: CGFloat) -> [CGFloat] {
        return [point + 1,
                point + 0.75,
                point + kLineStartPositionStep,
                point,
                point - kLineStartPositionStep,
                point - 0.75,
                point - 1]
    }

}
