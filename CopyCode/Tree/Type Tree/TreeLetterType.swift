//
//  TreeLetterType.swift
//  CopyCode
//
//  Created by Артем on 03/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

extension Tree where Node == LetterTypeOperations, Result == LetterType {
    func find(_ rect: Rectangle, with information: WordInformation, recognizer: LetterRecognizer) -> LetterType {
        switch self {
        case .empty: return .undefined
        case .r(let result): return result
        case let .n(operation, left, right):
            print("🌳 find operation: \(operation.description)")
            let exist: Bool
            switch operation.action {
            case .frame(let action): exist = action(rect.frame)
            case .checkerWithFrame(let action): exist = action(information, rect.frame)
            case .recognizerWithFrame(let action): exist = action(recognizer, rect.pixelFrame)
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
    case square
    case isLowWIthTail
    case quotesOrColumn
    case bottomY
    case dashOrHyphen
    ///Height ratio between current letter and highest letter the word
    case maxHRatio(((CGFloat,CGFloat) -> Bool), CGFloat)
    var action: Action {
        switch self {
        case let .maxHRatio(operation, ratio): return .checkerWithFrame { operation($0.maxHeightRatio(with: $1), ratio) }
        case .bottomY: return .checkerWithFrame { $0.exist(in: .bottom, with: $1) }
        case .isLowWIthTail:  return .checkerWithFrame { $0.lowWithTail(with: $1) }
        case .square: return .frame { (0.8...1.2).contains($0.ratio) }
        case .dashOrHyphen: return .recognizerWithFrame { $0.recognize(from: $1, with: dashOrHyphenOCRTree) == "-" }
        case .quotesOrColumn: return .checkerWithFrame { $0.quotesOrColumn(with: $1) }
        }
    }
    
    var description: String {
        switch self {
        case .square: return "square"
        case let .maxHRatio(_, ratio): return "maxHRatio: \(ratio)"
        case .isLowWIthTail: return "isLowWithTail"
        case .dashOrHyphen: return "dashOrHyphen"
        case .bottomY: return "bottomY"
        case .quotesOrColumn: return "quotesOrColumn"
        }
    }
}
