//
//  DigitColumnDetection.swift
//  CopyCode
//
//  Created by Артем on 27/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

final class WordRectangleSplitter<WordChild: Rectangle> {
    typealias WordAlias = Word<WordChild>
    typealias SplittedWord = (word: WordAlias, shitWord: WordAlias?)
    typealias SplittedWords = (words: [WordAlias], shitWords: [WordAlias])
    
   static func split(_ rectangle: WordAlias, after number: Int) -> SplittedWord {
        let letters = rectangle.letters.sorted { $0.frame.leftX < $1.frame.leftX }
        guard letters.count >= number else { return (Word.from(letters), nil) }
        let first = Array(letters[0..<number])
        let second = Array(letters[number..<letters.count])
        return (Word.from(first), Word.from(second))
    }

   static func split(_ rectangles: [WordAlias], after number: Int) -> SplittedWords {
        let splitted = rectangles.map { split($0, after: number) }
        return (splitted.map { $0.word }, splitted.compactMap { $0.shitWord } )
    }
}

final class DigitColumnDetection {
    typealias WordAlias = Word<LetterRectangle>
    typealias SplittedWords = (words: [WordAlias], shitWords: [WordAlias])
    ///Отвечает за то какой процент из распознанных слов являются цифрами
    ///Чем лучше будет распознавание тем больше следует делать процент
    private let kDigitConcentrationRate = 20
    private let recognizer: WordRecognizer
    
    init(recognizer: WordRecognizer) {
        self.recognizer = recognizer
    }
    
    func detecte1( _ wordRectangles: [WordAlias]) -> SplittedWords? {
        let sortedWordRectangles = wordRectangles.sorted { $0.pixelFrame.origin.y > $1.pixelFrame.origin.y}
        let (types, manyRectangles, otherRectangles) = getTypesWithSplitedArrays(sortedWordRectangles)
        
        switch types.count {
        case let x where x == 1:
            let isMany = types[0] == .many
            let allWordsMixed = wordRectangles.allWordsMixed
            let concentration = digitConcentration(moreThan: kDigitConcentrationRate, in: otherRectangles, with: recognizer)
            guard !isMany, !allWordsMixed, concentration else { return nil }
            return (otherRectangles, [])
            
        case let x where x == 2:
            guard !manyRectangles.isEmpty else { return nil }
            let type = SymbolsCount.symbols(withRatio: otherRectangles[0].frame.ratio)
            let allWordsMixed = otherRectangles.allWordsMixed
            let conc = digitConcentration(moreThan: kDigitConcentrationRate, in: otherRectangles, with: recognizer)
            let conc2 = digitConcentrationInManyType(moreThan: kDigitConcentrationRate, in: manyRectangles, type: type, with: recognizer)
            guard !allWordsMixed && conc && conc2 else { return nil }
            let splitted = WordRectangleSplitter.split(manyRectangles, after: type.rawValue)
            let columnRectangles = otherRectangles + splitted.words
            return (columnRectangles, splitted.shitWords)
        default: return nil
        }
    }
    

    func detecte( _ wordRectangles: [WordAlias]) -> Bool {
        let sortedWordRectangles = wordRectangles.sorted { $0.pixelFrame.origin.y > $1.pixelFrame.origin.y}
        let (types, manyRectangles, otherRectangles) = getTypesWithSplitedArrays(sortedWordRectangles)
        
        
        switch types.count {
        case let x where x == 1:
            let isMany = types[0] == .many
            let allWordsMixed = wordRectangles.allWordsMixed
            let concentration = digitConcentration(moreThan: kDigitConcentrationRate, in: otherRectangles, with: recognizer)
            return  !isMany && !allWordsMixed && concentration
            
            
        case let x where x == 2:
            guard !manyRectangles.isEmpty else { return false }
            let type = SymbolsCount.symbols(withRatio: otherRectangles[0].frame.ratio)
            let allWordsMixed = otherRectangles.allWordsMixed
            let conc = digitConcentration(moreThan: kDigitConcentrationRate, in: otherRectangles, with: recognizer)
            let conc2 = digitConcentrationInManyType(moreThan: kDigitConcentrationRate, in: manyRectangles, type: type, with: recognizer)
            return !allWordsMixed && conc && conc2
            
            
        default: return false
        }
    }
    
    private func getTypesWithSplitedArrays(_ wordRectangles: [WordAlias])
        -> (types: [SymbolsCount], manyRectangles: [WordAlias],  otherRectangles: [WordAlias]) {
            var types: [SymbolsCount] = []
            var manyRectangles: [WordAlias] = []
            var otherRectangles: [WordAlias] = []
            for rect in wordRectangles {
                print("ratio \(rect.frame.ratio)")
                let type = SymbolsCount.symbols(withRatio: rect.frame.ratio)
                types.append(type)
                type == .many ? manyRectangles.append(rect) : otherRectangles.append(rect)
            }
            return (Array(Set(types)), manyRectangles, otherRectangles)
    }
    
    private func digitConcentrationInManyType(moreThan rate: Int, in rectangles: [WordAlias],
                                              type: SymbolsCount, with recognizer: WordRecognizer) -> Bool {
        let words = rectangles
            .map { recognizer.recognize($0, with: .allUpper) }
            .map { String($0.value.prefix(type.rawValue)) }
            .compactMap { Int($0) }
        return words.count.of(rectangles.count, >, percent: rate)
    }
    
    private func digitConcentration(moreThan rate: Int, in rectangles: [WordAlias], with recognizer: WordRecognizer) -> Bool {
        let words = rectangles.map { recognizer.recognize($0, with: .allUpper) }
        let numbers: [Int] = words.compactMap {
            print("Value \($0.value)")
            return Int($0.value)
            
        }
        return numbers.count.of(words.count, >, percent: rate)
    }
}


enum SymbolsCount: Int {
    static let oneSymbolRatio: CGFloat = 1.2
    static let twoSymbolRatio: CGFloat = 0.65
    static let threeSymbolRatio: CGFloat = 0.45
//    static let fourSymbolRatio: CGFloat = 0.2
    
    case one = 1, two = 2, three = 3, many = 4
    
    static func symbols(withRatio ratio: CGFloat) -> SymbolsCount {
        switch ratio {
        case let x where x > SymbolsCount.oneSymbolRatio: return .one
        case let x where x <= SymbolsCount.oneSymbolRatio && x > SymbolsCount.twoSymbolRatio: return .two
        case let x where x <= SymbolsCount.twoSymbolRatio && x > SymbolsCount.threeSymbolRatio: return .three
//        case let x where x <= SymbolsCount.threeSymbolRatio && x > SymbolsCount.fourSymbolRatio: return .four
        default: return .many
        }
    }
}
