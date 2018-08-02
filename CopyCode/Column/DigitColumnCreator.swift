//
//  DigitColumnCreator.swift
//  CopyCode
//
//  Created by Артем on 31/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

final class DigitColumnCreator {
    private let columnDetection: DigitColumnDetection
    typealias ColumnWithBlockWords = (columnWords: [Column], shitWords: [WordRectangle_])
    
    init(columnDetection: DigitColumnDetection) {
        self.columnDetection = columnDetection
    }
    
    func create(from rectangles: [WordRectangle_]) -> ColumnWithBlockWords {
        let dictionary = rectangleDictionaryByXValue(rectangles)
        var columnsWords: [[WordRectangle_]] = []
        var blockRectangles: [WordRectangle_] = []
        var newDictionary = dictionary
        initialFilling(dictionary, dictionaryToUpdate: &newDictionary, columnsWords: &columnsWords, blockRectangles: &blockRectangles)
        additionUpdate(&newDictionary, columnsWords: &columnsWords, blockRectangles: &blockRectangles)
        newDictionary.values.forEach { blockRectangles.append(contentsOf: $0) }
        return (columnsWords.map { Column.from($0) }, blockRectangles.sorted { $0.frame.leftX < $1.frame.leftX } )
    }
    
    private func initialFilling(_ dictionary: [Int: [WordRectangle_]],
                                dictionaryToUpdate: inout [Int: [WordRectangle_]],
                                columnsWords: inout [[WordRectangle_]],
                                blockRectangles: inout [WordRectangle_]) {
        
        for (key, value) in dictionary where value.count > 5 {
            if let detectedValue = columnDetection.detecte1(value) {
                dictionaryToUpdate.removeValue(forKey: key)
                columnsWords.append(detectedValue.words)
                blockRectangles.append(contentsOf: detectedValue.shitWords)
            }
        }
    }
    
    private func additionUpdate(_ dictionary: inout [Int: [WordRectangle_]],
                                columnsWords: inout [[WordRectangle_]],
                                blockRectangles: inout [WordRectangle_]) {
        for i in 0..<columnsWords.count {
            var words = columnsWords[i]
            let word = words[0]
            let x = Int(word.frame.leftX.rounded())
            let number = word.symbolsCount.hashValue
            update(&dictionary, columnWords: &words, blockRectangles: &blockRectangles, key: x + 1, number: number)
            update(&dictionary, columnWords: &words, blockRectangles: &blockRectangles, key: x - 1, number: number)
            columnsWords[i] = words
        }
    }
    
    private func update(_ dictionary: inout [Int: [WordRectangle_]],
                        columnWords: inout [WordRectangle_],
                        blockRectangles: inout [WordRectangle_],
                        key: Int, number: Int) {
        guard let value = dictionary.removeValue(forKey: key) else { return }
        let splittedWords = WordRectangleSplitter.split(value, after: number)
        blockRectangles.append(contentsOf: splittedWords.shitWords)
        columnWords = columnWords + splittedWords.words
    }
    
    private func rectangleDictionaryByXValue(_ rectangles: [WordRectangle_]) -> [Int: [WordRectangle_]] {
        var dictionary: [Int: [WordRectangle_]] = [:]
        rectangles.forEach { dictionary.append(element: $0, toKey: Int($0.frame.leftX.rounded()))  }
        return dictionary
    }
}
