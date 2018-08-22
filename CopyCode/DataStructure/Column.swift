//
//  Column.swift
//  CopyCode
//
//  Created by Артем on 02/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

protocol Column_: StandartRectangle, Layerable { }

struct DigitColumn<Child: Rectangle>: Column_ {
    
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

struct CustomColumn: Column_ {
     let frame: CGRect
}
