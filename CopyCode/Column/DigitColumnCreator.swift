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
    typealias ColumnWithBlockWords = (columnWords: [Column], shitWords: [WordRectangleProtocol])
    
    init(columnDetection: DigitColumnDetection) {
        self.columnDetection = columnDetection
    }
    
    func create(from rectangles: [WordRectangleProtocol]) -> ColumnWithBlockWords {
        let dictionary = rectangleDictionaryByXValue(rectangles)
        var columnsWords: [[WordRectangleProtocol]] = []
        var blockRectangles: [WordRectangleProtocol] = []
        var newDictionary = dictionary
        initialFilling(dictionary, dictionaryToUpdate: &newDictionary, columnsWords: &columnsWords, blockRectangles: &blockRectangles)
        additionUpdate(&newDictionary, columnsWords: &columnsWords, blockRectangles: &blockRectangles)
        newDictionary.values.forEach { blockRectangles.append(contentsOf: $0) }
        return (columnsWords.map { Column.from($0) }, blockRectangles.sorted { $0.leftX < $1.leftX } )
    }
    
    private func initialFilling(_ dictionary: [Int: [WordRectangleProtocol]],
                                dictionaryToUpdate: inout [Int: [WordRectangleProtocol]],
                                columnsWords: inout [[WordRectangleProtocol]],
                                blockRectangles: inout [WordRectangleProtocol]) {
        
        for (key, value) in dictionary where value.count > 5 {
            if let detectedValue = columnDetection.detecte1(value) {
                dictionaryToUpdate.removeValue(forKey: key)
                columnsWords.append(detectedValue.words)
                blockRectangles.append(contentsOf: detectedValue.shitWords)
            }
        }
    }
    
    private func additionUpdate(_ dictionary: inout [Int: [WordRectangleProtocol]],
                                columnsWords: inout [[WordRectangleProtocol]],
                                blockRectangles: inout [WordRectangleProtocol]) {
        for i in 0..<columnsWords.count {
            var words = columnsWords[i]
            let word = words[0]
            let x = Int(word.leftX.rounded())
            let number = word.symbolsCount.hashValue
            update(&dictionary, columnWords: &words, blockRectangles: &blockRectangles, key: x + 1, number: number)
            update(&dictionary, columnWords: &words, blockRectangles: &blockRectangles, key: x - 1, number: number)
            columnsWords[i] = words
        }
    }
    
    private func update(_ dictionary: inout [Int: [WordRectangleProtocol]],
                        columnWords: inout [WordRectangleProtocol],
                        blockRectangles: inout [WordRectangleProtocol],
                        key: Int, number: Int) {
        guard let value = dictionary.removeValue(forKey: key) else { return }
        let splittedWords = WordRectangleSplitter.split(value, after: number)
        blockRectangles.append(contentsOf: splittedWords.shitWords)
        columnWords = columnWords + splittedWords.words
    }
    
    private func rectangleDictionaryByXValue(_ rectangles: [WordRectangleProtocol]) -> [Int: [WordRectangleProtocol]] {
        var dictionary: [Int: [WordRectangleProtocol]] = [:]
        rectangles.forEach { dictionary.append(element: $0, toKey: Int($0.leftX.rounded()))  }
        return dictionary
    }
}
