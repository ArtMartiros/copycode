//
//  DigitColumnDetection.swift
//  CopyCode
//
//  Created by Артем on 27/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

final class DigitColumnDetection {
    typealias WordAlias = Word<LetterRectangle>
    typealias SplittedWords = (digitColumnWords: [WordAlias], shitWords: [WordAlias])
    ///Отвечает за то какой процент из распознанных слов являются цифрами
    ///Чем лучше будет распознавание тем больше следует делать процент
    private let kDigitConcentrationRate = 25
    private let recognizer: WordRecognizer
    
    init(recognizer: WordRecognizer) {
        self.recognizer = recognizer
    }
    
    ///Обнаруживает если массив слов это digit column
    ///бывает так, что он сцеплен с другими словами, поэтому нужно отделить одни от другого
    func detecte( _ wordRectangles: [WordAlias]) -> SplittedWords? {
        let sortedWordRectangles = wordRectangles.sorted { $0.pixelFrame.origin.y > $1.pixelFrame.origin.y}
        let (types, manyRectangles, otherRectangles) = getTypesWithSplitedArrays(sortedWordRectangles)
        
        switch types.count {
        case let x where x == 1:
            let isMany = types[0] == .many
            let allWordsMixed = wordRectangles.allWordsMixed
            let concentration = concentrationOf(otherRectangles, with: recognizer)
            guard !isMany, !allWordsMixed, concentration else { return nil }
            return (otherRectangles, [])
            
        case let x where x == 2:
            guard !manyRectangles.isEmpty else { return nil }
            let type = SymbolsCount.symbols(withRatio: otherRectangles[0].frame.ratio)
            guard !otherRectangles.allWordsMixed,
                concentrationOf(otherRectangles, many: manyRectangles, with: recognizer, type: type)
                else { return nil }
            let splitted = WordSplitter.split(manyRectangles, after: type.rawValue)
            let columnRectangles = otherRectangles + splitted.words
            return (columnRectangles, splitted.shitWords)
        default: return nil
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
    
    private func concentrationOf(_ otherRectangles: [WordAlias],
                               many manyRectangles: [WordAlias] = [],
                               with recognizer: WordRecognizer,
                               type: SymbolsCount? = nil) -> Bool {
        var (chCount, nCount) = charsAndNumbers(otherRectangles, with: recognizer)
        
        if !manyRectangles.isEmpty {
            let (chCount1, nCount1) = charsAndNumbers(manyRectangles, with: recognizer, type: type)
            chCount = chCount + chCount1
            nCount = nCount + nCount1
        }
        let concentration = nCount.of(chCount, >, percent: kDigitConcentrationRate)
        return concentration
    }
    
    private func charsAndNumbers(_ rectangles: [WordAlias], with recognizer: WordRecognizer, type: SymbolsCount? = nil) -> (Int, Int) {
        let words = rectangles.map { recognizer.recognize($0, with: .allUpper) }
        let chars = words.reduce([String]()) { result, word in
            print("CharsAndNumbers word value \(word.value)")
            var values = word.letters.map { $0.value }
            values = type?.rawValue == nil ? values : Array(values.prefix(type!.rawValue))
            print("CharsAndNumbers word filtered value \(values)")
            return result + values
        }
        let numbers: [Int] = chars.compactMap {
            print("CharsAndNumbers number value \($0)")
            return Int($0)
            
        }
        return (chars.count, numbers.count)
    }
    
    
}


enum SymbolsCount: Int {
    static let oneSymbolRatio: CGFloat = 1.2
    static let twoSymbolRatio: CGFloat = 0.65
    static let threeSymbolRatio: CGFloat = 0.45
    
    case one = 1, two = 2, three = 3, many = 4
    
    static func symbols(withRatio ratio: CGFloat) -> SymbolsCount {
        switch ratio {
        case let x where x > SymbolsCount.oneSymbolRatio: return .one
        case let x where x <= SymbolsCount.oneSymbolRatio && x > SymbolsCount.twoSymbolRatio: return .two
        case let x where x <= SymbolsCount.twoSymbolRatio && x > SymbolsCount.threeSymbolRatio: return .three
        default: return .many
        }
    }
}
