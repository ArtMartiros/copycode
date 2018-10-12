//
//  Scenes.swift
//  CopyCodeTests
//
//  Created by Артем on 11/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

enum Scene: String {
    case sc1 = "sc1_text_view_creator"
    case sc2 = "sc2_block_creator"
    case sc3_p1 = "sc3_p1_firebase_chat"
    case sc3_p2 = "sc3_p2_user_main_view_controller"
    case sc4 = "sc4_leading_finder"
    case sc5 = "sc5_tree_letter_type"
    case sc6 = "sc6"
    case sc7 = "sc7"
    case sc8 = "sc8"
    case comments = "block_with_comments"
    case one = "block_one"
    case oneCode = "block_one_code"
    case two = "block_two"
    
    var imageName: String {
        switch self {
        case .sc1: return "sc1_text_view_creator"
        case .sc2: return "sc2_block_creator"
        case .sc3_p1, .sc3_p2: return "sc3_firebase_chat"
        case .sc6: return "sc6_tree_letter_type"
        case .sc7: return "sc7_panel"
        case .sc8: return "sc8_panel_controller"
        default: return ""
        }
    }
    
    var preDigitColumnWordsNames: [String] {
        switch self {
        case .sc6: return ["sc6_pre_digit_column_words"]
        case .sc7: return ["sc7_panel_pre_digit_column_words"]
        case .sc8: return ["sc8_panel_controller_pre_digit_column_words_2",
                           "sc8_panel_controller_pre_digit_column_words_3"]
        default: return []
        }
    }
    
    var wordsName: String {
        switch self {
        case .sc6: return "sc6_words"
        default: return ""
        }
    }
    
    func gePreDigitColumnWords(_ object: AnyObject) -> [[SimpleWord]] {
        return preDigitColumnWordsNames.map {
            CodableHelper.decode(object, path: $0, structType: [SimpleWord].self, shouldPrint: false)!
        }
    }
    
    func getWords(_ object: AnyObject) -> [SimpleWord] {
       return CodableHelper.decode(object, path: wordsName, structType: [SimpleWord].self, shouldPrint: false)!
    }
    
    var image: NSImage {
        return NSImage(named: .init(imageName))!
    }
    
    var customLettersName: String {
        switch self {
        case .sc1: return "sc1_custom_letters"
        case .sc2: return "sc2_custom_letters"
        default: return ""
        }
    }
    
    var trackingInfo: String {
        return "sc1_tracking_info"
    }
    
    var gridBlockName: String {
        switch self {
        case .sc1: return "sc1_text_view_creator_grid"
        case .sc2: return "sc2_block_creator_grid"
        case .sc3_p1: return "sc3_p1_firebase_chat_grid"
        case .sc3_p2: return "sc3_p2_user_main_view_controller_grid"
        default: return ""
        }
    }
    
    var gridWithTypeBlockName: String {
        switch self {
        case .sc1: return "sc1_block_text_view_creator_grid_with_type"
        case .sc2: return "sc2_block_creator_grid_with_type"
        case .sc3_p1: return "sc3_p1_firebase_chat_grid_with_type"
        default: return ""
        }
        
    }
    
    var letterTypeDictionary: [Int: String] {
        switch self {
        case .sc1: return sc1_type
        case .sc2: return sc2_type
        case .sc3_p1: return sc3_p1_type
        case .sc3_p2: return sc3_p2_type
        default: return [:]
        }
    }
    
    var letterDictionary: [Int: String] {
        switch self {
        case .sc1: return sc1_letter
        case .sc2: return sc2_letter
        case .sc3_p1: return sc3_p1_letter
        default: return [:]
        }
    }
    
    func getTrackingInfos(_ object: AnyObject) -> [TrackingInfo] {
        return CodableHelper.decode(object, path: trackingInfo, structType: [TrackingInfo].self, shouldPrint: false)!
    }
    
    func getLetterTypes(for lineIndex: Int) -> [LetterType] {
        guard lineIndex < letterTypeDictionary.count else { return [] }
        let newString = letterTypeDictionary[lineIndex]?.replacingOccurrences(of: " ", with: "")
        let types = newString?.compactMap { LetterType(letter: String($0)) }
        return types ?? []
    }
    
    func getLetters(for lineIndex: Int) -> [String] {
        guard lineIndex < letterDictionary.count else { return [] }
        let newString = letterDictionary[lineIndex]?.replacingOccurrences(of: " ", with: "")
        let array = newString?.compactMap { String($0) }
        return array ?? []
    }
    
    func getCustomLetters(_ object: AnyObject) -> [LetterRectangle] {
        return CodableHelper.decode(object, path: customLettersName, structType: [LetterRectangle].self, shouldPrint: false)!
    }
    
    func getBlock(_ object: AnyObject) -> SimpleBlock {
        return CodableHelper.decode(object, path: self.rawValue, structType: SimpleBlock.self, shouldPrint: false)!
    }
    
    func getGridBlock(_ object: AnyObject) -> SimpleBlock {
        return CodableHelper.decode(object, path: gridBlockName, structType: SimpleBlock.self, shouldPrint: false)!
    }
    
    func getGridWithTypeBlock(_ object: AnyObject) -> SimpleBlock {
        return CodableHelper.decode(object, path: self.gridWithTypeBlockName,
                                    structType: SimpleBlock.self, shouldPrint: false)!
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
        } else if letter == "\"" {
            self = .doubleQuote
        } else {
            self = .undefined
        }
    }
}
