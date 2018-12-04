//
//  Scenes.swift
//  CopyCodeTests
//
//  Created by Артем on 11/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

enum Scene: String {
    case sc1, sc2, sc3_p1, sc3_p2, sc4, sc5, sc6, sc7, sc8, sc9
    case sc10, sc11, sc13_p1, sc14, sc15, sc16, sc17, sc18, sc19
    case sc20, sc21, sc22, sc23, sc24, sc25, sc26, sc27, sc28
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
        case .sc14: return sc14_type
        case .sc15: return sc15_type
        case .sc16: return sc16_type
        case .sc17: return sc17_type
        case .sc18: return sc18_type
        case .sc21: return sc21_type
        case .sc22: return sc22_type
        case .sc23: return sc23_type
        case .sc24: return sc24_type
        case .sc25: return sc25_type
        case .sc26: return sc26_type
        default: return [:]
        }
    }

    private var lowLetterTypeDictionary: [Int: String] {
        switch self {
        case .sc1: return sc1_type_low
        case .sc2: return sc2_type_low
        case .sc3_p1: return sc3_p1_type_low
        case .sc3_p2: return sc3_p2_type_low
        case .sc9: return sc9_type
        case .sc11: return sc11_type_low
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
        case .sc14: return sc14_letter
        case .sc15: return sc15_letter
        case .sc16: return sc16_letter
        default: return [:]
        }
    }

    private var lowLetterDictionary: [Int: String] {
        switch self {
        case .sc1: return sc1_letter_low
        case .sc2: return sc2_letter
        case .sc3_p1: return sc3_p1_letter_low
            case .sc3_p2: return sc3_p2_letter_low
        case .sc9: return sc9_letter
        case .sc11: return sc11_letter_low
        default: return [:]
        }
    }
    func gePreDigitColumnWords(_ object: AnyObject) -> [[SimpleWord]] {
        return preDigitColumnWordsNames.map { $0.decode(as: [SimpleWord].self)! }
    }

    func getRects(_ object: AnyObject, low: Bool) -> [SimpleWord] {
        return getName(rectsName, isLow: low).decode(as: [SimpleWord].self)!
    }

    func getBlock(low: Bool) -> SimpleBlock {
        return getName(blockName, isLow: low).decode(as: SimpleBlock.self)!
    }

    func getWords(low: Bool) -> [SimpleWord] {
        return getName(wordsName, isLow: low).decode(as: [SimpleWord].self)!
    }

//    func getTrackingInfos(_ object: AnyObject) -> [TrackingInfo] {
//        return trackingInfo.decode(as: [TrackingInfo].self)!
//    }
    
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
    
    func getCustomLetters() -> [LetterRectangle] {
        return customLettersName.decode(as: [LetterRectangle].self)!
    }
    
    func getCustomLettersPosition() -> [SimpleLetterPosition] {
       return customLettersPositionName.decode(as: [SimpleLetterPosition].self)!
    }
    


    ///блок сразу после определения тракинга
    func getTrackingBlock() -> SimpleBlock {
        return trackingBlockName.decode(as: SimpleBlock.self)!
    }

    func getRestoredBlock(low: Bool) -> SimpleBlock {
        let name = getName(restoredName, isLow: low)
        return name.decode(as: SimpleBlock.self)!
    }

    func getGridBlock(isLow: Bool) -> SimpleBlock {
        return getName(gridBlockName, isLow: isLow).decode(as: SimpleBlock.self)!
    }
    
    func getCompletedWithStuck() -> CompletedBlock {
        return completedWithStuckName.decode(as: CompletedBlock.self)!
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

