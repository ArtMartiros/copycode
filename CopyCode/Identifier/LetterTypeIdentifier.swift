//
//  LetterTypeIdentifier.swift
//  CopyCode
//
//  Created by Артем on 22/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct LetterTypeIdentifier {
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
    
   private func detectType(for letters: [LetterRectangle]) -> [LetterType] {
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
    
    func detectType(for letters: [LetterRectangle], typography: Typography) -> [LetterType] {
        switch typography {
        case .empty, .tracking:
            return detectType(for: letters)
        case .grid(let grid):
            let frame = grid.leading.createVirtualFrame(from: letters[0].frame)
            let newWordInformation = WordInformation(standartLetter: frame)
            
            var types: [LetterType] = []
            for(index, letter) in letters.enumerated() {
                print("\n LetterTypeIdentifier letterIndex \(index), height: \(letter.frame.height) ")
                let type = gridUndefineType.find(letter, with: newWordInformation, recognizer: recognizer)
                print("LetterType: \(type)")
                types.append(type)
            }
            return types
        }
    }
}

struct WordInformation: TypeChecker {
    private let _midDiffRate: CGFloat = 30

    private let checker = Checker()
    let maxHeightChar: CGRect
    let lowerYChar: CGRect
    let word: CGRect
    init(max: Rectangle, lowerY: Rectangle, word: Rectangle) {
        self.maxHeightChar = max.frame
        self.lowerYChar = lowerY.frame
//        self.checker = Checker(height: maxHeightChar.height)
        self.word = word.frame
    }
    
    init(standartLetter: CGRect) {
        self.maxHeightChar = standartLetter
        self.lowerYChar = standartLetter
//        self.checker = Checker(height: standartLetter.height)
        self.word = standartLetter
    }
    
    func exist(in position: Position, with frame: CGRect) -> Bool {
        switch position {
        case .top:
            return checker.isSame(word.topY, with: frame.topY, height: frame.height, accuracy: .high)
        case .mid:
            return positionOf(currentY: frame.bottomY, relativeTo: word) > _midDiffRate
        case .bottom:
            return checker.isSame(frame.bottomY, with: word.bottomY,
                                  height: maxHeightChar.height, accuracy: .high)
        }
    }
    
    func maxHeightRatio(with frame: CGRect) -> CGFloat {
        let ratio = frame.height / maxHeightChar.height
        print("Ratio: \(ratio) = \(frame.height) / \(maxHeightChar.height)")
        return ratio
    }
    
    func lowWithTail(with frame: CGRect) -> Bool {
        print("first top \(frame), second top \(lowerYChar.bottomY) ")
        let same = checker.isSame(frame.bottomY, with: lowerYChar.bottomY, height: frame.height, accuracy: .superHigh)
        print("lowWithTail \(same)")
        return same
    }
    
    func lowWithTailCustom(with frame: CGRect) -> Bool {
        let topDifferent =  word.topY - frame.topY
        let bottomDifferent = frame.bottomY - lowerYChar.bottomY
        let different = topDifferent - bottomDifferent
        print("Different: \(different), topDifferent \(topDifferent), bottomDifferent \(bottomDifferent) ")
        let differenceRate = different / word.height * 100
        print("differenceRate \(differenceRate )")
        return differenceRate > 15
    }
    
    func quotesOrColumn(with frame: CGRect) -> Bool {
        let same = checker.isSame(word.topY, with: frame.topY, height: frame.height, accuracy: .superLow)
        let inTheMid = positionOf(currentY: frame.bottomY, relativeTo: word) > _midDiffRate
        return same && inTheMid
    }
    
    private func positionOf(currentY: CGFloat, relativeTo frame: CGRect) -> CGFloat {
        let diff = currentY - frame.bottomY
        return diff / frame.height * 100
    }
}
