//
//  OCRPicture.swift
//  CopyCodeTests
//
//  Created by Артем on 14/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

protocol PictureNameProtocol {
    var imageName: String { get }
}

enum OCRPicture: PictureNameProtocol {
    //    case sublimeDark12
    //    case sublimeDark14
    case sublimeDark18
    case sublimeDark20
    case xcodeDark12
    case xcodeDark14
    case xcodeDark18
    case xcodeLight12
    case xcodeLight14
    case xcodeLight18
    case visual12
    case visual14
    case visual18
    case visual20
    
    var imageName: String {
        switch self {
            //        case .typeWhite: return "picLetterTypeClassificationWhite"
            //        case .typeBlack: return "picLetterTypeClassificationBlack3"
            //        case .sublimeDark12: return "picOCRSublimeDark12"
        //        case .sublimeDark14: return "picOCRSublimeDark14"
        case .sublimeDark18: return "picOCRSublimeDark18"
        case .sublimeDark20: return "picOCRSublimeDark20"
        case .xcodeDark12: return "picOCRXcodeDark12"
        case .xcodeDark14: return "picOCRXcodeDark14"
        case .xcodeDark18: return "picOCRXcodeDark18"
        case .xcodeLight12: return "picOCRXcodeW12"
        case .xcodeLight14: return "picOCRXcodeW14"
        case .xcodeLight18: return "picOCRXcodeW18"
        case .visual12: return "picOCRVisualDark12"
        case .visual14: return "picOCRVisualDark14"
        case .visual18: return "picOCRVisualDark18"
        case .visual20: return "picOCRVisualDark20"
        }
    }
    
    var image: NSImage {
        return NSImage(named: .init(imageName))!
    }
    
    var lettersName: String {
        switch self {
        case .sublimeDark18: return "ocr_sublime_dark_18_words"
        case .sublimeDark20: return "ocr_sublime_dark_20_words"
        case .xcodeDark12: return "ocr_xcode_dark_12_words"
        case .xcodeDark14: return "ocr_xcode_dark_14_words"
        case .xcodeDark18: return "ocr_xcode_dark_18_words"
        case .xcodeLight12: return "ocr_xcode_light_12_words"
        case .xcodeLight14: return "ocr_xcode_light_14_words"
        case .xcodeLight18: return "ocr_xcode_light_18_words"
        case .visual12: return "ocr_visual_12_words"
        case .visual14: return "ocr_visual_14_words"
        case .visual18: return "ocr_visual_18_words"
        case .visual20: return "ocr_visual_20_words"
        }
    }
    
    var answersName: String {
        switch self {
            //        case .sublimeDark12: return "ocr_sublime_dark_12"
            //        case .sublimeDark14: return "ocr_sublime_dark_14"
        //%# + ^
        case .sublimeDark18: return "ocr_sublime_dark_18"
        //%# &@ + ^
        case .sublimeDark20: return "ocr_sublime_dark_20"
        //%# VW + ^
        case .xcodeDark12: return "ocr_xcode_dark_12"
        //%# VW + ^
        case .xcodeDark14: return "ocr_xcode_dark_14"
        //+ %, #, - ''
        case .xcodeDark18: return "ocr_xcode_dark_18"
        //*%#, ^
        case .xcodeLight12: return "ocr_xcode_light_12"
        //% #, + ^ VW
        case .xcodeLight14: return "ocr_xcode_light_14"
        case .xcodeLight18: return "ocr_xcode_light_18"
        //%# &@  + ^
        case .visual12: return "ocr_visual_12"
        //%# &@ VW  + ^
        case .visual14: return "ocr_visual_14"
        //VW, %# (ошибочка) + ^,
        case .visual18: return "ocr_visual_18"
        // %(2 части) + #, ^
        case .visual20: return "ocr_visual_20"
        }
    }
    
    func getWord(_ object: AnyObject) -> SimpleWord {
        return CodableHelper.decode(object, path: lettersName, structType: [SimpleWord].self, shouldPrint: false)![0]
    }
    
    func getAnswers(_ object: AnyObject) -> [Answer] {
        return  CodableHelper.decode(object,
                                     path: answersName,
                                     structType: [Answer].self)!
    }
    
    struct Answer: Codable {
        let letter: String
        let type: LetterType
    }
    
}

enum LetterPixelFinderPicture: PictureNameProtocol {
    case dot, dash, quotes, equal, underscore
    var imageName: String {
        switch self {
        case .dot: return "picDot"
        case .dash: return "picDash"
        case .quotes: return "picQuotes"
        case .equal: return "picEqual"
        case .underscore: return "picUnderscore"
        }
    }
    
    var json: String {
        switch self {
        case .dot: return "missing_dot"
        case .dash: return "missing_dash"
        case .quotes: return "missing_quotes"
        case .equal: return "missing_equal"
        case .underscore: return "missing_underscore"
        }
    }
}
