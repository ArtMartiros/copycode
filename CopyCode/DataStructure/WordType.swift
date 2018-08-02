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
        case .undefined: return "undefined"
        }
    }
    case undefined
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
    init(_ type: LetterType) {
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

extension LetterType {
    init(_ type: WordType) {
        switch type {
        case .mix, .undefined: self = .undefined
        case .same(let sameType):
            self.init(sameType)
        }
    }
    
    init(_ sameType: WordType.SameType) {
        switch sameType {
        case .allLower: self = .low
        case .allUpper: self = .upper
        case .allLowWithTail: self = .lowWithTail
        case .undefined: self = .undefined
        }
    }
}


