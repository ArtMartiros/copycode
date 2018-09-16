//
//  Typography.swift
//  CopyCode
//
//  Created by Артем on 16/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

enum Typography {
    case empty
    case tracking(TrackingData)
    case grid(TypographicalGrid)
}

extension Typography: Codable {
    
    private enum CodingKeys: CodingKey {
        case base
        case trackingData
        case gridData
    }
    private enum Base: String, Codable {
        case empty, tracking, grid
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .tracking(let value):
            try container.encode(Base.tracking, forKey: .base)
            try container.encode(value, forKey: .trackingData)
        case .grid(let value):
            try container.encode(Base.grid, forKey: .base)
            try container.encode(value, forKey: .gridData)
        case .empty:
            try container.encode(Base.empty, forKey: .base)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let base = try container.decode(Base.self, forKey: .base)
        switch base {
        case .empty: self = .empty
        case .tracking:
            let tracking = try container.decode(TrackingData.self, forKey: .trackingData)
            self = .tracking(tracking)
        case .grid:
            let grid = try container.decode(TypographicalGrid.self, forKey: .gridData)
            self = .grid(grid)
        }
    }
}
