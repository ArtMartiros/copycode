//
//  Scenes.swift
//  CopyCodeTests
//
//  Created by Артем on 11/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

enum Scene: String {
    case sc1, sc2, sc3_p1, sc3_p2, sc4, sc5, sc6, sc7, sc8, sc9, sc10
    case sc11, sc13_p1
    case block_with_comments, block_one, block_one_code, block_two

    func getImage(isLow: Bool) -> NSImage {
        let name = getName(withoutPart, isLow: isLow)
        return NSImage(name)
    }

    private var rectsName: String { return withoutPart + "_rects" }
/// первоначально поделенный блок обычно один или жва
    private var blockName: String { return rawValue + "_block" }
    private var wordsName: String { return rawValue + "_words" }
    private var customLettersName: String { return rawValue + "_custom_letters" }
    private var customLettersPositionName: String { return rawValue + "_custom_letters_position" }
    private var trackingInfo: String { return rawValue + "_tracking_info" }
    private var gridBlockName: String { return rawValue + "_grid" }
    private var trackingBlockName: String { return rawValue + "_tracking_block" }
    private var restoredName: String { return rawValue + "_restored" }
    private var completedWithStuckName: String { return rawValue + "_stuck_completed" }

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

    private var lowLetterTypeDictionary: [Int: String] {
        switch self {
        case .sc1: return sc1_type_low
        case .sc2: return sc2_type_low
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
        case .sc3_p2: return sc3_p2_letter
        case .sc9: return sc9_letter
        case .sc11: return sc11_letter
        default: return [:]
        }
    }

    private var lowLetterDictionary: [Int: String] {
        switch self {
        case .sc1: return sc1_letter_low
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

    func getRects(_ object: AnyObject, low: Bool) -> [SimpleWord] {
        let name = rectsName + (low ? "_low" : "")
        return CodableHelper.decode(object, path: name, structType: [SimpleWord].self, shouldPrint: false)!
    }

    func getWords(_ object: AnyObject) -> [SimpleWord] {
        return CodableHelper.decode(object, path: wordsName, structType: [SimpleWord].self, shouldPrint: false)!
    }

    func getTrackingInfos(_ object: AnyObject) -> [TrackingInfo] {
        return CodableHelper.decode(object, path: trackingInfo, structType: [TrackingInfo].self, shouldPrint: false)!
    }
    
    func getLetterTypes(for lineIndex: Int, isLow: Bool) -> [LetterType] {
        let dictionary = isLow ? lowLetterTypeDictionary : letterTypeDictionary
        guard lineIndex < dictionary.count else { return [] }
        let newString = dictionary[lineIndex]?.replacingOccurrences(of: " ", with: "")
        let types = newString?.compactMap { LetterType(letter: String($0)) }
        return types ?? []
    }
    
    func getLetters(for lineIndex: Int, isLow: Bool) -> [String] {
        let dictionary = isLow ? lowLetterDictionary : letterDictionary
        guard lineIndex < dictionary.count else { return [] }
        let newString = dictionary[lineIndex]?.replacingOccurrences(of: " ", with: "")
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

    func getRestoredBlock(_ object: AnyObject, low: Bool) -> SimpleBlock {
        let name = getName(restoredName, isLow: low)
        return CodableHelper.decode(object, path: name, structType: SimpleBlock.self, shouldPrint: false)!
    }

    func getGridBlock(_ object: AnyObject, isLow: Bool) -> SimpleBlock {
        let name = getName(gridBlockName, isLow: isLow)
        return CodableHelper.decode(object, path: name, structType: SimpleBlock.self, shouldPrint: false)!
    }
    
    func getCompletedWithStuck(_ object: AnyObject) -> CompletedBlock {
        return CodableHelper.decode(object, path: completedWithStuckName, structType: CompletedBlock.self, shouldPrint: false)!
    }

    private func getName(_ name: String, isLow: Bool) -> String {
        return name + (isLow ? "_low" : "")
    }
    private var withoutPart: String { return rawValue.removeAll(after: "_p") }
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
