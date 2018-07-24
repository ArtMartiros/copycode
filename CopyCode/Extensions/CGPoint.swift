//
//  CGPoint.swift
//  CopyCode
//
//  Created by Артем on 18/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

extension CGPoint {
    var rounded: CGPoint {
        return CGPoint(x: round(x), y: round(y))
    }
}
