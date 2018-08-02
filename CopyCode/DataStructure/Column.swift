//
//  Column.swift
//  CopyCode
//
//  Created by Артем on 02/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct Column<Child: Rectangle>: ColumnProtocol {
    
    let frame: CGRect
    var pixelFrame: CGRect {
        return words.map { $0.pixelFrame }.compoundFrame
    }
    
    let words: [Word<Child>]
    init(words: [Word<Child>], frame: CGRect) {
        self.words = words
        self.frame = frame
    }
    
    static func from(_ words: [Word<Child>]) -> Column {
        let frame = words.map { $0.frame }.compoundFrame
        return Column(words: words, frame: frame)
    }
}
