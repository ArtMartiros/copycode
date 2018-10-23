//
//  ColumnType.swift
//  CopyCode
//
//  Created by Артем on 03/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

enum ColumnType: ColumnProtocol {
    func updated(by rate: Int) -> ColumnType {
        switch self {
        case .digit(column: let column):
            let newColumn = column.updated(by: rate)
            return .digit(column: newColumn)
        case .standart(column: let column):
            let newColumn = column.updated(by: rate)
            return .standart(column: newColumn)
        }
    }


    var frame: CGRect {
        switch self {
        case .digit(let column): return column.frame
        case .standart(let column): return column.frame
        }
    }

    case digit(column: DigitColumn<LetterRectangle>)
    case standart(column: CustomColumn)
}

extension ColumnType: Codable {

   private enum CodingKeys: CodingKey {
        case digit
        case standart
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .digit(let value):
            try container.encode(value, forKey: .digit)
        case .standart(let value):
            try container.encode(value, forKey: .standart)
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let digitValue =  try container.decode(DigitColumn<LetterRectangle>.self, forKey: .digit)
            self = .digit(column: digitValue)
        } catch {
            let standartValue =  try container.decode(CustomColumn.self, forKey: .standart)
            self = .standart(column: standartValue)
        }
    }
}
