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
final class DigitColumnMerger {
    func mergeSameColumn<T: Rectangle>(_ things: [Column<T>]) -> [Column<T>] {
        let sortedThings = things.sorted { $0.frame.leftX < $1.frame.leftX }
        //С одинаковым количеством цифр, но со смещением в пиксель
//        let mergedColumns = Merger.merge(sortedThings, valueToCheck: { $0.rightX })
        //соединить если с разной разрядностью
        return things
    }
}

final class Merger {
   static func merge<R>(_ rectangles: [R], valueToCheck:(R) -> CGFloat ) -> [[R]] where R: Rectangle {
        let checker = Checker(height: 20)
        var value: CGFloat = 0
        var arrayOfRectangles: [[R]] = []
        var newRectangles: [R] = []
        for rect in rectangles {
            let newValue = valueToCheck(rect)
            if checker.isSame(first: value, with: newValue) {
                newRectangles.append(rect)
            } else {
                value = newValue
                arrayOfRectangles.append(newRectangles)
                newRectangles = [rect]
            }
        }
        arrayOfRectangles.append(newRectangles)
        return arrayOfRectangles
    }
}

