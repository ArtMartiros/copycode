//
//  TreeOCRCustomData.swift
//  CopyCode
//
//  Created by Артем on 29/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

let customOCRTree: TreeOCR = .n(.xRange(x: 6...8, y: 0.5, op: .or),
                                .r("-"),
                                .n(.yRange(x: 0.5, y: 6...9, op: .or),
                                   .r("="),
                                   .r("\"")))
