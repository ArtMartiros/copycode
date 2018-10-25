//
//  Scenes.swift
//  CopyCodeTests
//
//  Created by Артем on 11/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

enum Scene {
    case sc1, sc2, sc3_p1, sc3_p2, sc4, sc5, sc6, sc7, sc8, sc9, sc10
    case sc11, sc13_p1
    case comments, one, oneCode, two

    var image: NSImage { return NSImage(named: .init(imageName))! }

    private var blockName: String {
        switch self {
        case .sc1: return "sc1_text_view_creator"
        case .sc2: return "sc2_block_creator"
        case .sc3_p1: return "sc3_p1_firebase_chat"
        case .sc3_p2: return "sc3_p2_user_main_view_controller"
        case .sc4: return "sc4_leading_finder"
        case .sc5: return "sc5_tree_letter_type"
        case .sc11: return "sc11_block"
        case .comments: return "block_with_comments"
        case .one: return "block_one"
        case .oneCode: return "block_one_code"
        case .two: return "block_two"
        default: return ""
        }
    }

    private var imageName: String {
        switch self {
        case .sc1: return "sc1_text_view_creator"
        case .sc2: return "sc2_block_creator"
        case .sc3_p1, .sc3_p2: return "sc3_firebase_chat"
        case .sc6: return "sc6_tree_letter_type"
        case .sc7: return "sc7_panel"
        case .sc8: return "sc8_panel_controller"
        case .sc9: return "sc9_playground"
        case .sc10: return "sc10_nscolor"
        case .sc11: return "sc11_video"
        case .sc13_p1: return "sc13"
        default: return ""
        }
    }
    
    private var preDigitColumnWordsNames: [String] {
        switch self {
        case .sc6: return ["sc6_pre_digit_column_words"]
        case .sc7: return ["sc7_panel_pre_digit_column_words"]
        case .sc8: return ["sc8_panel_controller_pre_digit_column_words_2",
                           "sc8_panel_controller_pre_digit_column_words_3"]
        case .sc3_p2: return ["sc3_p2_pre_digit_column_words_f"]
        case .sc10: return ["sc10_nscolor_pre_digit_column_words", "sc10_nscolor_pre_digit_column_words_f"]
        default: return []
        }
    }

    private var wordsName: String {
        switch self {
        case .sc3_p1: return "sc3_words"
        case .sc3_p2: return "sc3_words"
        case .sc6: return "sc6_words"
        default: return ""
        }
    }

    private var customLettersName: String {
        switch self {
        case .sc1: return "sc1_custom_letters"
        case .sc2: return "sc2_custom_letters"
        default: return ""
        }
    }

    private var customLettersPositionName: String {
        switch self {
        case .sc1: return "sc1_custom_letters_position"
        case .sc2: return "sc2_custom_letters_position"
        case .sc9: return "sc9_custom_letters_position"
        default: return ""
        }
    }
    
    private var trackingInfo: String {
        return "sc1_tracking_info"
    }

    private var trackingBlockName: String {
        switch self {
        case .sc11: return "sc11_tracking_block"
        default: return ""
        }
    }

    private var gridBlockName: String {
        switch self {
        case .sc1: return "sc1_text_view_creator_grid"
        case .sc2: return "sc2_block_creator_grid"
        case .sc3_p1: return "sc3_p1_firebase_chat_grid"
        case .sc3_p2: return "sc3_p2_user_main_view_controller_grid"
        case .sc9: return "sc9_playground_grid"
        case .sc11: return "sc11_video_grid"
        case .sc13_p1: return "sc13_p1_grid"
        default: return ""
        }
    }

    private var restoredName: String {
        switch self {
        case .sc1: return "sc1_text_view_creator_restored"
        case .sc2: return "sc2_block_creator_restored"
        case .sc3_p1: return "sc3_p1_restored"
        case .sc3_p2: return "sc3_p2_restored"
        case .sc9: return "sc9_restored"
        case .sc11: return "sc11_restored"
        default:
            return ""
        }
    }


    
    private var gridWithTypeBlockName: String {
        switch self {
        case .sc1: return "sc1_block_text_view_creator_grid_with_type"
        case .sc2: return "sc2_block_creator_grid_with_type"
        case .sc3_p1: return "sc3_p1_firebase_chat_grid_with_type"
        case .sc9: return "sc9_playground_grid_with_type"
        case .sc11: return "sc11_video_grid_with_type"
        default: return ""
        }
        
    }
    
    private var completedWithStuckName: String {
        switch self {
        case .sc11:
            return "sc11_video_stuck_completed"
        default:
            return ""
        }
    }
    
    private var letterTypeDictionary: [Int: String] {
        switch self {
        case .sc1: return sc1_type
        case .sc2: return sc2_type
        case .sc3_p1: return sc3_p1_type
        case .sc3_p2: return sc3_p2_type
        case .sc9: return sc9_type
        case .sc11: return sc11_type
        default: return [:]
        }
    }
    
    private var letterDictionary: [Int: String] {
        switch self {
        case .sc1: return sc1_letter
        case .sc2: return sc2_letter
        case .sc3_p1: return sc3_p1_letter
        case .sc9: return sc9_letter
        case .sc11: return sc11_letter
        default: return [:]
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
    
    func getCustomLettersPosition(_ object: AnyObject) -> [SimpleLetterPosition] {
        return CodableHelper.decode(object, path: customLettersPositionName,
                                    structType: [SimpleLetterPosition].self, shouldPrint: false)!
    }
    
    func getBlock(_ object: AnyObject) -> SimpleBlock {
        return CodableHelper.decode(object, path: blockName, structType: SimpleBlock.self, shouldPrint: false)!
    }

    ///блок сразу после определения тракинга
    func getTrackingBlock(_ object: AnyObject) -> SimpleBlock {
        return CodableHelper.decode(object, path: trackingBlockName, structType: SimpleBlock.self, shouldPrint: false)!
    }

    func getRestoredBlock(_ object: AnyObject) -> SimpleBlock {
        return CodableHelper.decode(object, path: restoredName, structType: SimpleBlock.self, shouldPrint: false)!
    }

    func getGridBlock(_ object: AnyObject) -> SimpleBlock {
        return CodableHelper.decode(object, path: gridBlockName, structType: SimpleBlock.self, shouldPrint: false)!
    }
    
    func getCompletedWithStuck(_ object: AnyObject) -> CompletedBlock {
        return CodableHelper.decode(object, path: completedWithStuckName, structType: CompletedBlock.self, shouldPrint: false)!
    }
    
    func getGridWithTypeBlock(_ object: AnyObject) -> SimpleBlock {
        return CodableHelper.decode(object, path: gridWithTypeBlockName, structType: SimpleBlock.self, shouldPrint: false)!
    }
    
}

extension LetterType {
    fileprivate init(letter: String ) {
        switch letter {
        case "u": self = .upper
        case "l": self = .low
        case "t": self = .lowWithTail
        case ".": self = .dot
        case "'": self = .quote
        case "c": self = .custom
        case "-": self = .dashOrHyphen
        case "_": self = .underscore
        case ",": self = .comma
        case "\"": self = .doubleQuote
        default:
            self = .undefined
        }
    }
}
