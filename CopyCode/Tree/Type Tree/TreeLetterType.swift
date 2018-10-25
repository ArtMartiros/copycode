//
//  TreeLetterType.swift
//  CopyCode
//
//  Created by Артем on 03/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

extension Tree where Node == LetterTypeOperations, Result == LetterType {
    func find(_ rect: LetterRectangle, with information: WordInformation, recognizer: LetterRecognizer) -> LetterType {
        switch rect.type {
        case .custom, .doubleQuote:
            return rect.type
        default: break
        }

        switch self {
        case .empty: return .undefined
        case .r(let result): return result
        case let .n(operation, left, right):
            print("🌳 find operation: \(operation.description)")
            let exist: Bool
            switch operation.action {
            case .frame(let action): exist = action(rect.frame)
            case .checkerWithFrame(let action): exist = action(information, rect.frame)
            case .recognizerWithFrame(let action): exist = action(recognizer, rect.frame)
            }
            return (exist ? left : right).find(rect, with: information, recognizer: recognizer)
        }
    }
}

enum LetterTypeOperations: CustomStringConvertible {
    enum Action {
        case frame((CGRect) -> Bool)
        case checkerWithFrame((WordInformation, CGRect) -> Bool)
        case recognizerWithFrame((LetterRecognizer, CGRect) -> Bool)

    }
    case squareForDot
    case isLowWithTail
    case isLowWithTailCustom
    case quotesOrColumn
    case bottomY
    case dashOrComma
    case dashOrHyphen
    ///Height ratio between current letter and highest letter the word
    case maxHRatio(((CGFloat, CGFloat) -> Bool), CGFloat)
    var action: Action {
        switch self {
        case let .maxHRatio(operation, ratio): return .checkerWithFrame { operation($0.maxHeightRatio(with: $1), ratio) }
        case .bottomY: return .checkerWithFrame { $0.exist(in: .bottom, with: $1) }
        case .dashOrComma: return .frame { 0.6 > $0.ratio }
        case .isLowWithTail:  return .checkerWithFrame { $0.lowWithTail(with: $1) }
        case .isLowWithTailCustom:  return .checkerWithFrame { $0.lowWithTailCustom(with: $1) }

        case .squareForDot: return .frame { (0.66...1.5).contains($0.ratio) }
        case .dashOrHyphen: return .recognizerWithFrame { $0.recognize(from: $1, with: dashOrHyphenOCRTree) == "-" }
        case .quotesOrColumn: return .checkerWithFrame { $0.quotesOrColumn(with: $1) }
        }
    }

    var description: String {
        switch self {
        case .squareForDot: return "squareForDot"
        case let .maxHRatio(_, ratio): return "maxHRatio: \(ratio)"
        case .isLowWithTail: return "isLowWithTail"
        case .isLowWithTailCustom: return "isLowWIthTailCustom"
        case .dashOrHyphen: return "dashOrHyphen"
        case .bottomY: return "bottomY"
        case .dashOrComma: return "dashOrComma"
        case .quotesOrColumn: return "quotesOrColumn"
        }
    }
}
