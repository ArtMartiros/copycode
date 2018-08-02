//
//  WordStructure.swift
//  CopyCode
//
//  Created by Артем on 19/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

protocol ColumnProtocol: Rectangle {
    var words: [WordRectangle_] { get }
}

protocol BlockProtocol: Rectangle {
    var blockWords: [WordRectangle_] { get }
    init(blockWords: [WordRectangle_], frame: CGRect)
}

//MARK: Rectangle
struct Column: ColumnProtocol {
    let frame: CGRect
    var pixelFrame: CGRect {
        return words.map { $0.pixelFrame }.compoundFrame
    }
    
    let words: [WordRectangle_]
    init(words: [WordRectangle_], frame: CGRect) {
        self.words = words
        self.frame = frame
    }
    
    static func from(_ words: [WordRectangle_]) -> Column {
        let frame = words.map { $0.frame }.compoundFrame
        return Column(words: words, frame: frame)
    }
}

struct Block: BlockProtocol {
    
    let frame: CGRect
    let blockWords: [WordRectangle_]
    
    var pixelFrame: CGRect {
        return blockWords.map { $0.pixelFrame }.compoundFrame
    }
    init(blockWords words: [WordRectangle_], frame: CGRect) {
        self.blockWords = words
        self.frame = frame
    }
    
    static func from(_ words: [WordRectangle_]) -> Block {
        let frame = words.map { $0.frame }.compoundFrame
        return Block(blockWords: words, frame: frame)
    }
}

//MARK: Final
protocol ValueProtocol {
    var value: String { get }
}





