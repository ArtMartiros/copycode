//
//  CGRectEdge.swift
//  CopyCode
//
//  Created by Артем on 31/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

extension CGRectEdge {
    var rate: CGFloat {
        switch self {
        case .maxXEdge: return 1
        case .minXEdge: return 0
        case .maxYEdge: return 1
        case .minYEdge: return 0
        }
    }
}
