//
//  DigitColumnDetection.swift
//  CopyCode
//
//  Created by Артем on 27/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

final class DigitColumnDetection {
    typealias SplittedWords = (digitColumnWords: [SimpleWord], shitWords: [SimpleWord])
    ///Отвечает за то какой процент из распознанных слов являются цифрами
    ///Чем лучше будет распознавание тем больше следует делать процент
    private let kDigitConcentrationRate = 40
    private let recognizer: WordRecognizer
    
    init(recognizer: WordRecognizer) {
        self.recognizer = recognizer
    }
    
    convenience init(in bitmap: NSBitmapImageRep) {
        let recognizer = WordRecognizer(in: bitmap)
        self.init(recognizer: recognizer)
    }
    
    ///Обнаруживает если массив слов это digit column
    ///бывает так, что он сцеплен с другими словами, поэтому нужно отделить одни от другого
    func detect( _ words: [SimpleWord]) -> SplittedWords? {
        let dictionary = getWordsByType(from: words)
        let types = Array(dictionary.keys)
        switch types.count {
        case 1:
            let type = types[0]
            guard let words = dictionary[type] , type != .many,
                words.allWordsSame, checkIsDigit(words)  else { return nil }
            return (words, [])
            
        case 2:
            if let manyWords = dictionary[.many] {
                let (type, words) = dictionary.filter { $0.key != .many }[0]
                let splitted = WordSplitter.split(manyWords, after: type.rawValue )
                let columnWords = words + splitted.words
                guard columnWords.allWordsSame, checkIsDigit(columnWords) else { return nil }
                return (columnWords, splitted.shitWords)
            } else {
                //может потом отличаться поэтому пока оставлю
                let sortedElements = dictionary.sorted { $0.value.count > $1.value.count }
                let mainType = sortedElements[0]
                let subType = sortedElements[1]
                let splitted = WordSplitter.split(subType.value, after: mainType.key.rawValue )
                let columnWords = mainType.value + splitted.words
                guard columnWords.allWordsSame, checkIsDigit(columnWords) else { return nil }
                return (columnWords, splitted.shitWords)
            }
            
        case 3:
            guard let manyWords = dictionary[.many] else { return nil }
            let sortedElements = dictionary
                .filter { $0.key != .many }
                .sorted { $0.value.count > $1.value.count }
            let mainType = sortedElements[0]
            let subType = sortedElements[1]
            let subSplitted = WordSplitter.split(subType.value, after: mainType.key.rawValue)
            let manySplitted = WordSplitter.split(manyWords, after: mainType.key.rawValue)
            let columnWords = mainType.value + subSplitted.words + manySplitted.words
            guard columnWords.allWordsSame, checkIsDigit(columnWords) else { return nil }
            return (columnWords, subSplitted.shitWords + manySplitted.shitWords)
            
        default: return nil
        }
    }
    
    func detectFirstLetter(_ wordRectangles: [SimpleWord]) -> SplittedWords? {
        let sortedWordRectangles = wordRectangles.sortedFromTopToBottom()
        let splitted = WordSplitter.split(sortedWordRectangles, after: 1)
        guard checkIsDigit(splitted.words) else { return nil }
        return  (splitted.words, splitted.shitWords)
    }
    
    private func getTypesWithSplitedArrays(_ wordRectangles: [SimpleWord])
        -> (types: [SymbolsCount], manyRectangles: [SimpleWord],  otherRectangles: [SimpleWord]) {
            var types: [SymbolsCount] = []
            var manyRectangles: [SimpleWord] = []
            var otherRectangles: [SimpleWord] = []
            for rect in wordRectangles {
                print("ratio \(rect.frame.ratio)")
                let type = SymbolsCount.symbols(withRatio: rect.frame.ratio)
                types.append(type)
                type == .many ? manyRectangles.append(rect) : otherRectangles.append(rect)
            }
            return (Array(Set(types)), manyRectangles, otherRectangles)
    }
    
    
    
    private func getWordsByType(from words: [SimpleWord]) -> [SymbolsCount: [SimpleWord]] {
        var dictionary: [SymbolsCount: [SimpleWord]] = [:]
        words.forEach {
            
            let type = SymbolsCount.symbols(withRatio: $0.frame.ratio)
            print("ratio \($0.frame.ratio) type: \(type), y: \($0.frame.minY)")
            dictionary.append(element: $0, toKey: type)
        }
        return dictionary
    }
    
    private func checkIsDigit(_ otherRectangles: [SimpleWord]) -> Bool {
        let (chCount, nCount) = charsAndNumbers(otherRectangles)
        let concentration = nCount.of(chCount, >, percent: kDigitConcentrationRate)
        print(" CharsAndNumbers nCount: \(nCount), chCount: \(chCount), concentration: \(concentration)")
        return concentration
    }
    
    private func charsAndNumbers(_ rectangles: [SimpleWord]) -> (Int, Int) {
        let words = rectangles.map { recognizer.recognize($0, with: .allUpper) }
        
        let chars = words.reduce([String]()) { result, word in
            print("CharsAndNumbers word value \(word.value)")
            let values = word.letters.map { $0.value }
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
    static let twoSymbolRatio: CGFloat = 0.62
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
