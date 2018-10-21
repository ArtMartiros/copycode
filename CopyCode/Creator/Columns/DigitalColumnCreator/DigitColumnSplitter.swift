//
//  DigitColumnSplitter.swift
//  CopyCode
//
//  Created by Артем on 31/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

protocol DigitColumnCreatorProtocol {
    associatedtype ColumnWithBlockWords
    func spltted(from rectangles: [SimpleWord]) -> ColumnWithBlockWords
}

final class DigitColumnSplitter: DigitColumnCreatorProtocol {
    private let kMinimumColumnWordsCount = 4
    private let columnDetection: DigitColumnDetection
    private let columnMerger: DigitColumnMerger
    typealias ColumnWithBlockWords = (columnWords: [DigitColumn<LetterRectangle>], shitWords: [SimpleWord])

    init(columnDetection: DigitColumnDetection, columnMerger: DigitColumnMerger) {
        self.columnDetection = columnDetection
        self.columnMerger = columnMerger
    }

    convenience init(in bitmap: NSBitmapImageRep) {
        let recognizer = WordRecognizer(in: bitmap)
        let detection = DigitColumnDetection(recognizer: recognizer)
        let merger = DigitColumnMerger()
        self.init(columnDetection: detection, columnMerger: merger)
    }

    func spltted(from rectangles: [SimpleWord]) -> ColumnWithBlockWords {
        let dictionaryWordsByOriginX = rectangleDictionaryByXValue(rectangles)
        let values = dictionaryWordsByOriginX.sorted { $0.key < $1.key }
        for item in values where item.key == 923 {
          let value = CodableHelper.encode(item.value)
        print(value)
        }
        var pre = createPreliminaryWord(from: dictionaryWordsByOriginX)
        pre = updateByNearestXkey(pre)
        pre.dictionaryWordsByOriginX.values.forEach { pre.blockWords.append(contentsOf: $0) }

        let columns = pre.columnsWords.map { DigitColumn.from($0) }
        let mergedColumns = columnMerger.mergeSameColumn(columns)
        return (mergedColumns, pre.blockWords.sortedFromLeftToRight() )
    }

    ///вырезает из словаря значения и разделяет их на column и block слова
    private func createPreliminaryWord(from dictionary: [Int: [SimpleWord]]) -> PreliminaryWords {
        var dictionaryToUpdate = dictionary
        var columnsWords: [[SimpleWord]] = []
        var blockWords: [SimpleWord] = []
        for (key, value) in dictionary where value.count >= kMinimumColumnWordsCount {
            if let detectedValue = columnDetection.detect(value) {
                dictionaryToUpdate.removeValue(forKey: key)
                columnsWords.append(detectedValue.digitColumnWords)
                blockWords.append(contentsOf: detectedValue.shitWords)
            }
        }
        return PreliminaryWords(dictionaryToUpdate, block: blockWords, columns: columnsWords)
    }

    ///Возвращает словарь с массивами слов с ключами origin X
    private func rectangleDictionaryByXValue(_ rectangles: [SimpleWord]) -> [Int: [SimpleWord]] {
        var dictionary: [Int: [SimpleWord]] = [:]
        rectangles.forEach { dictionary.append(element: $0, toKey: Int($0.frame.leftX.rounded()))  }
        return dictionary
    }

    //x это ключ в словаре, бывает так, что элемент в column имеет погрешность в пиксель от основного массива column
    //тогда в словаре у него может быть другой ключ
    //здесь то мы и ищем ключ с погрешностью в пиксель
    private func updateByNearestXkey(_ preliminary: PreliminaryWords) -> PreliminaryWords {
        var preliminary = preliminary
        let columnsCount = preliminary.columnsWords.count
        for i in 0..<columnsCount {
            let word = preliminary.columnsWords[i][0]
            let leftX = Int(word.frame.leftX.rounded())
            let newWidth = (word.frame.width / 3) * 2
            let rightX = Int((word.frame.leftX + newWidth).rounded())
            let number = word.symbolsCount.rawValue

            preliminary = updated(preliminary, index: i, key: leftX + 1, number: number)
            preliminary = updated(preliminary, index: i, key: leftX - 1, number: number)

            guard case .two = word.symbolsCount else { continue }
            for x in leftX...rightX {
                preliminary = updated(preliminary, index: i, key: x, number: 1)
            }

        }
        return preliminary
    }

    private func updated(_ preliminary: PreliminaryWords, index: Int, key: Int, number: Int) -> PreliminaryWords {
        var preliminary = preliminary
        if let value = preliminary.dictionaryWordsByOriginX.removeValue(forKey: key) {
            let splittedWords = WordSplitter.split(value, after: number)
            preliminary.blockWords.append(contentsOf: splittedWords.shitWords)
            let columns = preliminary.columnsWords[index]
            preliminary.columnsWords[index] = columns + splittedWords.words
        }
        return preliminary
    }

}

extension DigitColumnSplitter {
    struct PreliminaryWords {
        var columnsWords: [[SimpleWord]]
        var blockWords: [SimpleWord]
        var dictionaryWordsByOriginX: [Int: [SimpleWord]]
        init (_ dictionary: [Int: [SimpleWord]], block: [SimpleWord], columns: [[SimpleWord]] ) {
            self.dictionaryWordsByOriginX = dictionary
            self.blockWords = block
            self.columnsWords = columns
        }
    }
}
