//
//  Column.swift
//  CopyCode
//
//  Created by Артем on 02/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

protocol ColumnProtocol: Rectangle { }

struct DigitColumn<Child: Rectangle>: ColumnProtocol {
    func updated(by rate: Int) -> DigitColumn<Child> {
        let newWords = words.map { $0.updated(by: rate) }
        let frame = updatedFrame(by: rate)
        return DigitColumn<Child>(words: newWords, frame: frame)
    }

    let frame: CGRect
    let words: [Word<Child>]
    init(words: [Word<Child>], frame: CGRect) {
        self.words = words
        self.frame = frame
    }

    static func from(_ words: [Word<Child>]) -> DigitColumn {
        let frame = words.map { $0.frame }.compoundFrame
        return DigitColumn(words: words, frame: frame)
    }
}

struct CustomColumn: ColumnProtocol {
    func updated(by rate: Int) -> CustomColumn {
        let frame = updatedFrame(by: rate)
        return CustomColumn(frame: frame)
    }

     let frame: CGRect
}
