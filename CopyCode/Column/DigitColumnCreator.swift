//
//  DigitColumnCreator.swift
//  CopyCode
//
//  Created by Артем on 31/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

final class DigitColumnCreator<WordChild:Rectangle> {
    private let columnDetection: DigitColumnDetection
    typealias ColumnWithBlockWords = (columnWords: [Column<LetterRectangle>], shitWords: [WordAlias])
    typealias WordAlias = Word<LetterRectangle>
    init(columnDetection: DigitColumnDetection) {
        self.columnDetection = columnDetection
    }
    
    func create(from rectangles: [WordAlias]) -> ColumnWithBlockWords {
        let dictionary = rectangleDictionaryByXValue(rectangles)
        var columnsWords: [[WordAlias]] = []
        var blockRectangles: [WordAlias] = []
        var newDictionary = dictionary
        initialFilling(dictionary, dictionaryToUpdate: &newDictionary, columnsWords: &columnsWords, blockRectangles: &blockRectangles)
        additionUpdate(&newDictionary, columnsWords: &columnsWords, blockRectangles: &blockRectangles)
        newDictionary.values.forEach { blockRectangles.append(contentsOf: $0) }
        return (columnsWords.map { Column.from($0) }, blockRectangles.sorted { $0.frame.leftX < $1.frame.leftX } )
    }
    
    private func initialFilling(_ dictionary: [Int: [WordAlias]],
                                dictionaryToUpdate: inout [Int: [WordAlias]],
                                columnsWords: inout [[WordAlias]],
                                blockRectangles: inout [WordAlias]) {
        
        for (key, value) in dictionary where value.count > 5 {
            if let detectedValue = columnDetection.detecte1(value) {
                dictionaryToUpdate.removeValue(forKey: key)
                columnsWords.append(detectedValue.words)
                blockRectangles.append(contentsOf: detectedValue.shitWords)
            }
        }
    }
    
    private func additionUpdate(_ dictionary: inout [Int: [WordAlias]],
                                columnsWords: inout [[WordAlias]],
                                blockRectangles: inout [WordAlias]) {
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
    
    private func update(_ dictionary: inout [Int: [WordAlias]],
                        columnWords: inout [WordAlias],
                        blockRectangles: inout [WordAlias],
                        key: Int, number: Int) {
        guard let value = dictionary.removeValue(forKey: key) else { return }
        let splittedWords = WordRectangleSplitter.split(value, after: number)
        blockRectangles.append(contentsOf: splittedWords.shitWords)
        columnWords = columnWords + splittedWords.words
    }
    
    private func rectangleDictionaryByXValue(_ rectangles: [WordAlias]) -> [Int: [WordAlias]] {
        var dictionary: [Int: [WordAlias]] = [:]
        rectangles.forEach { dictionary.append(element: $0, toKey: Int($0.frame.leftX.rounded()))  }
        return dictionary
    }
}
