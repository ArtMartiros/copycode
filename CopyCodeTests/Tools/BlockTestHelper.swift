//
//  BlockTestHelper.swift
//  CopyCodeTests
//
//  Created by Артем on 11/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

struct BlockTestHelper {
    private static let blockNames = ["block_one", "block_two"]
    
    static func getBlocks(_ object: AnyObject) -> [Block<LetterRectangle>] {
      return blockNames.compactMap {
            CodableHelper.decode(object, path: $0, structType: Block<LetterRectangle>.self, shouldPrint: false)
        }
    }
}

enum BlockTest: String {
    case comments = "block_with_comments"
    case one = "block_one"
    case oneCode = "block_one_code"
    case two = "block_two"
    case sc1 = "sc1_text_view_creator"
    case sc2 = "sc2_block_creator"
    
    func getBlock(_ object: AnyObject) -> SimpleBlock {
        return CodableHelper.decode(object, path: self.rawValue, structType: SimpleBlock.self, shouldPrint: false)!
    }
}

enum TrackingInfoTest: String {
    case sc1 = "tracking_info_sc1"
    func get(_ object: AnyObject) -> [TrackingInfo] {
        return CodableHelper.decode(object, path: self.rawValue, structType: [TrackingInfo].self, shouldPrint: false)!
    }
}

enum Scene: String {
    case sc1 = "sc1_text_view_creator"
    case sc2 = "sc2_block_creator"
    var image: NSImage {
       return NSImage(named: .init(rawValue))!
    }
    
    var customLettersName: String {
        switch self {
        case .sc1:
            return "sc1_custom_letters"
        case .sc2:
            return "sc2_custom_letters"
        }
    }
    
    var gridBlockName: String {
        return "sc2_block_creator_grid"
    }
    
    func letterTypes(for lineIndex: Int) -> [LetterType] {
        guard lineIndex < sc2_type.count else { return [] }
        let newString = sc2_type[lineIndex]?.replacingOccurrences(of: " ", with: "")
        let types = newString?.compactMap { LetterType(letter: String($0)) }
        return types ?? []
    }
    
    var lineTypes: [Int: String] {
        return sc2_type
    }
    
    func getCustomLetters(_ object: AnyObject) -> [LetterRectangle] {
        return CodableHelper.decode(object, path: customLettersName, structType: [LetterRectangle].self, shouldPrint: false)!
    }
    
    func getBlock(_ object: AnyObject) -> SimpleBlock {
        return CodableHelper.decode(object, path: self.rawValue, structType: SimpleBlock.self, shouldPrint: false)!
    }
    
    func getGridBlock(_ object: AnyObject) -> SimpleBlock {
        return CodableHelper.decode(object, path: self.gridBlockName, structType: SimpleBlock.self, shouldPrint: false)!
    }
    
}

extension LetterType {
   fileprivate init(letter: String ) {
        if letter == "u" {
            self = .upper
        } else if letter == "l" {
            self = .low
        } else if letter == "t" {
            self = .lowWithTail
        } else if letter == "." {
            self = .dot
        } else if letter == "'" {
            self = .quote
        } else if letter == "c" {
            self = .custom
        } else if letter == "-" {
            self = .dashOrHyphen
        } else if letter == "_" {
            self = .underscore
        } else if letter == "," {
            self = .comma
        } else {
            self = .undefined
        }
    }
}
