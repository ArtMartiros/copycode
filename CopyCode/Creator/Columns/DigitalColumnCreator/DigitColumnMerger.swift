//
//  DigitColumnMerger.swift
//  CopyCode
//
//  Created by Артем on 27/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

/// Отвечает за соединение столбца с цифрами в одну
/// Может понадобиться в случае, когда отличается количество цифр допустим сотни и тысячи
/// а также в случае если одинаковая разрядность но отличается на пиксель
final class DigitColumnMerger {
    func mergeSameColumn<T: Rectangle>(_ things: [DigitColumn<T>]) -> [DigitColumn<T>] {
        let sortedColumns = things.sortedFromLeftToRight()
        let mergedLeftColumns = merge(sortedColumns, fault: 1, valueToCheck: { $0.frame.leftX })
        let mergedRightColumns = merge(mergedLeftColumns, fault: 1, valueToCheck: { $0.frame.rightX })
        return mergedRightColumns
    }

    func merge<T: Rectangle>(_ columns: [DigitColumn<T>], fault: CGFloat, valueToCheck: (StandartRectangle) -> CGFloat) -> [DigitColumn<T>] {
        var value: CGFloat = 0
        var arrayOfRectangles: [[Word<T>]] = []
        var newRectangles: [Word<T>] = []
        for rect in columns {
            let newValue = valueToCheck(rect)
            let range = (newValue - fault)...(newValue + fault)
            if range.contains(value) {
                newRectangles.append(contentsOf: rect.words)
            } else {
                value = newValue
                if !newRectangles.isEmpty { arrayOfRectangles.append(newRectangles) }
                newRectangles = rect.words
            }
        }
        if !newRectangles.isEmpty {
            arrayOfRectangles.append(newRectangles)
        }
        return arrayOfRectangles.map { DigitColumn.from($0) }
    }
}
