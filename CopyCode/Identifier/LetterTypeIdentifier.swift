//
//  LetterTypeIdentifier.swift
//  CopyCode
//
//  Created by Артем on 22/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct LetterTypeIdentifier {
    let information: WordInformation
    let recognizer: LetterRecognizer

    init(_ information: WordInformation, recognizer: LetterRecognizer) {
        self.information = information
        self.recognizer = recognizer
    }

    func detectType(for letters: [LetterRectangle], grid: TypographicalGrid,
                    actionType: ActionForLetterType) -> [LetterType] {
            var types: [LetterType] = []
            for(index, letter) in letters.enumerated() {
                print("\n LetterTypeIdentifier letterIndex \(index), height: \(letter.frame.height) ")
                let type = getTree(from: actionType).find(letter, with: information, recognizer: recognizer)
                let rate = information.maxHeightRatio(with: letter.frame)
                print("LetterType: \(type), rate: \(rate)")
                types.append(type)
            }
            return types
        }

    private func getTree(from type: ActionForLetterType) -> TreeType {
        switch type {
        case .all:
            print("Noam gridUndefineType")
            return gridUndefineType
        case .onlyLow:
            print("Noam gridOnlyLowType")
            return gridOnlyLowType
        case .withOutLow: return gridWithOutLowType
        }
    }
}

//очень опасный метод он нужен только для теста, он слишком трудозатратный
//    func testDetectType(for letter: LetterRectangle, in letters: [LetterRectangle]) -> LetterType {
//        let types = detectType(for: letters)
//        for (index, item) in letters.enumerated() {
//            if item.hashValue == letter.hashValue {
//                return types[index]
//            }
//        }
//        return .undefined
//    }
//
//    func detectType(for letters: [LetterRectangle]) -> [LetterType] {
//        let types = letters.compactMap { undefinedTypeTree.find($0, with: wordInformation, recognizer: recognizer) }
//        let lowExist = types.first { $0 == .low } != nil
//        let upperExist = types.first { $0 == .upper } != nil
//
//        guard !lowExist && !upperExist else { return types }
//        let lowWIthTailCount = types.filter { $0 == .lowWithTail }.count
//        guard lowWIthTailCount != 0 else { return types }
//        let lettersCount = types.count
//        let tooMuchTail = lettersCount / lowWIthTailCount * 100 > 30
//        if (tooMuchTail && lettersCount >= 3) || lettersCount == lowWIthTailCount {
//            return types.map { $0 == .lowWithTail ? .upper : $0 }
//        }
//        return types
//    }
//
