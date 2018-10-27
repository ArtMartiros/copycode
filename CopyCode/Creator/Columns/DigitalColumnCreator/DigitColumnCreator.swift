//
//  DigitColumnCreator.swift
//  CopyCode
//
//  Created by Артем on 31/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

protocol DigitColumnCreatorProtocol {
    associatedtype ColumnWithBlockWords
    func create(from rectangles: [Word<LetterRectangle>]) -> ColumnWithBlockWords
}

struct DigitColumnCreator: DigitColumnCreatorProtocol {
    private let kMinimumColumnWordsCount = 4
    private let columnDetection: DigitColumnDetection
    private let columnMerger: DigitColumnMerger
    typealias ColumnWithBlockWords = (columnWords: [DigitColumn<LetterRectangle>], shitWords: [WordAlias])
    typealias WordAlias = Word<LetterRectangle>
    init(columnDetection: DigitColumnDetection, columnMerger: DigitColumnMerger) {
        self.columnDetection = columnDetection
        self.columnMerger = columnMerger
    }

    func create(from rectangles: [WordAlias]) -> ColumnWithBlockWords {
        var dictionaryWordsByOriginX = rectangleDictionaryByXValue(rectangles)
//        Array(dictionaryWordsByOriginX.values).sorted { $0.count > $1.count }.forEach {
//            $0.forEach { element in
//                print("x: \(element.frame.leftX), y: \(element.frame.bottomY), w: \(element.frame.width), h: \(element.frame.height)")
//            }
//            print("\($0.count) --------------------------end\n")
//        }
        var columnsWords: [[WordAlias]] = []
        var blockRectangles: [WordAlias] = []
        divide(from: &dictionaryWordsByOriginX, toColumnsWords: &columnsWords, and: &blockRectangles)
        additionUpdate(&dictionaryWordsByOriginX, columnsWords: &columnsWords, blockRectangles: &blockRectangles)
        dictionaryWordsByOriginX.values.forEach { blockRectangles.append(contentsOf: $0) }
        let columns = columnsWords.map { DigitColumn.from($0) }
        let mergedColumns = columnMerger.mergeSameColumn(columns)
        return (mergedColumns, blockRectangles.sorted { $0.frame.leftX < $1.frame.leftX })
    }

    ///вырезает из словаря значения и разделяет их на column и block слова
    private func divide(from dictionaryToUpdate: inout [Int: [WordAlias]],
                                toColumnsWords columnsWords: inout [[WordAlias]],
                                and blockRectangles: inout [WordAlias]) {
        let dictionary = dictionaryToUpdate
        for (key, value) in dictionary where value.count >= kMinimumColumnWordsCount {
            if let detectedValue = columnDetection.detecte(value) {
                dictionaryToUpdate.removeValue(forKey: key)
                columnsWords.append(detectedValue.digitColumnWords)
                blockRectangles.append(contentsOf: detectedValue.shitWords)
            }
        }
    }

    //если погрешность в пиксель то добавляем его в digital column
    private func additionUpdate(_ dictionary: inout [Int: [WordAlias]],
                                columnsWords: inout [[WordAlias]],
                                blockRectangles: inout [WordAlias]) {
        for i in 0..<columnsWords.count {
            var words = columnsWords[i]
            let word = words[0]
            let x = Int(word.frame.leftX.rounded())
            let number = word.symbolsCount.rawValue + 1
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
        let splittedWords = WordSplitter.split(value, after: number)
        blockRectangles.append(contentsOf: splittedWords.shitWords)
        columnWords += splittedWords.words
    }

    ///Возвращает словарь с массивами слов с ключами origin X
    private func rectangleDictionaryByXValue(_ rectangles: [WordAlias]) -> [Int: [WordAlias]] {
        var dictionary: [Int: [WordAlias]] = [:]
        rectangles.forEach { dictionary.append(element: $0, toKey: Int($0.frame.leftX.rounded()))  }
        return dictionary
    }
}
