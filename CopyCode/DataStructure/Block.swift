//
//  Block.swift
//  CopyCode
//
//  Created by Артем on 02/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct Block<WordChild: Rectangle>: BlockProtocol {
    let frame: CGRect
    let lines: [Line<WordChild>]

    init(lines: [Line<WordChild>], frame: CGRect) {
        self.lines = lines
        self.frame = frame
    }
    
    static func from(_ lines: [Line<WordChild>]) -> Block {
        let frame = lines.map { $0.frame }.compoundFrame
        return Block(lines: lines, frame: frame)
    }
}
