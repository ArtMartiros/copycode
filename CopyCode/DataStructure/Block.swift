//
//  Block.swift
//  CopyCode
//
//  Created by Артем on 02/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

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
