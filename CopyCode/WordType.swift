//
//  WordType.swift
//  CopyCode
//
//  Created by Артем on 20/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

enum WordType: CustomStringConvertible, Equatable {
    static func == (lhs: WordType, rhs: WordType) -> Bool {
        return lhs.description == rhs.description
    }
    
    var description: String {
        switch self {
        case .mix: return "mix"
        case .same(let type): return type.rawValue
        }
    }
    
    case mix
    case same(type: SameType)
    enum SameType: String {
        case allUpper
        case allLower
        case allLowWithTail
        case undefined
    }
    
}

extension WordType.SameType {
    init(type: LetterType) {
        switch type {
        case .low: self = .allLower
        case .upper: self = .allUpper
        case .undefined: self = .undefined
        case .lowWithTail: self = .allLowWithTail
            
        }
    }
}

enum LetterType: String {
    case upper
    case low
    case lowWithTail
    case undefined
}


