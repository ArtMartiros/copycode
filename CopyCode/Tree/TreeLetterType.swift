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
        case .isLowWIthTail: return "isLowWIthTail"
        case .dashOrHyphen: return "dashOrHyphen"
        case .bottomY: return "bottomY"
        case .quotesOrColumn: return "quotesOrColumn"
        }
    }
}


struct NewLetterTypeClassification {
    let wordInformation: WordInformation
    let recognizer: LetterRecognizer
    
    init(information: WordInformation, recognizer: LetterRecognizer) {
        self.wordInformation = information
        self.recognizer = recognizer
    }
    
    //очень опасный метод он нужен только для теста, он слишком трудозатратный
    func testDetectType(for letter: LetterRectangle, in letters: [LetterRectangle]) -> LetterType {
        let types = detectType(for: letters)
        for (index, item) in letters.enumerated() {
            if item.hashValue == letter.hashValue {
                return types[index]
            }
        }
        return .undefined
    }
    
    func detectType(for letters: [LetterRectangle]) -> [LetterType] {
        let types = letters.compactMap { undefinedTypeTree.find($0, with: wordInformation, recognizer: recognizer) }
        let lowExist = types.first { $0 == .low } != nil
        let upperExist = types.first { $0 == .upper } != nil
        guard !lowExist && !upperExist else { return types }
        let lowWIthTailCount = types.filter { $0 == .lowWithTail }.count
        guard lowWIthTailCount != 0 else { return types }
        let lettersCount = types.count
        let tooMuchTail = lettersCount / lowWIthTailCount * 100 > 30
        if (tooMuchTail && lettersCount >= 3) || lettersCount == lowWIthTailCount {
            return types.map { $0 == .lowWithTail ? .upper : $0 }
        }
        return types
    }
}

struct WordInformation {
    private let _midDiffRate: CGFloat = 30
    enum Position {
        case top
        case mid
        case bottom
    }
    private let checker: Checker
    let maxHeightChar: Rectangle
    let lowerYChar: Rectangle
    let word: Rectangle
    init(max: Rectangle, lowerY: Rectangle, word: Rectangle) {
        self.maxHeightChar = max
        self.lowerYChar = lowerY
        self.checker = Checker(height: maxHeightChar.frame.height)
        self.word = word
    }
    
    func exist(in position: Position, with frame: CGRect) -> Bool {
        switch position {
        case .top:
            return checker.isSame(first: word.frame.topY, with: frame.topY, height: frame.height, accuracy: .high)
        case .mid:
            return positionOf(currentY: frame.bottomY, relativeTo: word.frame) > _midDiffRate
        case .bottom:
            return checker.isSame(first: frame.bottomY, with: word.frame.bottomY, accuracy: .high)
        }
    }
    
    func maxHeightRatio(with frame: CGRect) -> CGFloat {
        let ratio = frame.height / maxHeightChar.frame.height
        print("Ratio: \(ratio)")
        return ratio
    }
    
    func lowWithTail(with frame: CGRect) -> Bool {
        print("first top \(frame), second top \(lowerYChar.frame.bottomY) ")
        let same = checker.isSame(first: frame.bottomY, with: lowerYChar.frame.bottomY, height: frame.height, accuracy: .superHigh)
        print("lowWithTail \(same)")
        return same
    }
    
    func quotesOrColumn(with frame: CGRect) -> Bool {
        let same = checker.isSame(first: word.frame.topY, with: frame.topY, height: frame.height, accuracy: .superLow)
        let inTheMid = positionOf(currentY: frame.bottomY, relativeTo: word.frame) > _midDiffRate
        return same && inTheMid
    }
    
    private func positionOf(currentY: CGFloat, relativeTo frame: CGRect) -> CGFloat {
        let diff = currentY - frame.bottomY
        return diff / frame.height * 100
    }
}
