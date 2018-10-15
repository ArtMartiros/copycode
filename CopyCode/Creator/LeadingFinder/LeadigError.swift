//
//  LeadigError.swift
//  CopyCode
//
//  Created by Артем on 17/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct LeadigError: ErrorRateProtocol {
    let errorRate: CGFloat
    let preciseRate: CGFloat
    let leading: Leading
}
