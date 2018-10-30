//
//  WordType.swift
//  CopyCode
//
//  Created by Артем on 20/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

enum WordType: CustomStringConvertible, Equatable {
    case undefined
    case mix
    case same(type: SameType)
    enum SameType: String, Codable {
        case allUpper
        case allLower
        case allLowWithTail
        case allCustom
        case undefined
    }

    var description: String {
        switch self {
        case .mix: return "mix"
        case .same(let type): return type.rawValue
        case .undefined: return "undefined"
        }
    }

    static func == (lhs: WordType, rhs: WordType) -> Bool {
        return lhs.description == rhs.description
    }
}

extension WordType: Codable {
    private enum CodingKeys: String, CodingKey {
        case sameType, base
    }

    private enum Base: String, Codable {
        case undefined, mix, same
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let base = try container.decode(Base.self, forKey: .base)

        switch base {
        case .undefined: self = .undefined
        case .mix: self = .mix
        case .same:
            let sameTypeValue = try container.decode(SameType.self, forKey: .sameType)
            self = .same(type: sameTypeValue)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .undefined: try container.encode(Base.undefined, forKey: .base)
        case .mix:
             try container.encode(Base.mix, forKey: .base)
        case .same(let type):
            try container.encode(Base.same, forKey: .base)
            try container.encode(type, forKey: .sameType)
        }
    }
}

extension WordType.SameType {
    init(_ type: LetterType) {
        switch type {
        case .low: self = .allLower
        case .upper: self = .allUpper
        case .undefined: self = .undefined
        case .lowWithTail: self = .allLowWithTail
        default: self = .allLower
        }
    }
}

enum LetterType: String, Codable {
    case upper
    case low
    case lowWithTail
    case dot
    case underscore
    //- ~
    case dashOrHyphen
    //,
    case comma
    case quote
    case doubleQuote
    case custom
    case undefined
}

extension LetterType {
    init(_ type: WordType) {
        switch type {
        case .mix, .undefined: self = .undefined
        case .same(let sameType): self.init(sameType)
        }
    }

    init(_ sameType: WordType.SameType) {
        switch sameType {
        case .allLower: self = .low
        case .allUpper: self = .upper
        case .allLowWithTail: self = .lowWithTail
        case .allCustom: self = .custom
        case .undefined: self = .undefined
        }
    }
}
