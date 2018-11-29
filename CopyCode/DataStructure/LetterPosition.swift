//
//  LetterPosition.swift
//  CopyCode
//
//  Created by Артем on 29/11/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct LetterInLinePosition: LetterInLinePositionProtocol {
    let wordIndex: Int
    let letterIndex: Int
}

struct LetterInBlockPosition: LetterInBlockPositionProtocol {
    let lineIndex: Int
    let wordIndex: Int
    let letterIndex: Int
    init(inLine: LetterInLinePosition, line: Int) {
        lineIndex = line
        wordIndex = inLine.wordIndex
        letterIndex = inLine.letterIndex
    }
}

protocol LetterInLinePositionProtocol {
    var wordIndex: Int { get }
    var letterIndex: Int { get }
}

protocol LetterInBlockPositionProtocol: LetterInLinePositionProtocol {
    var lineIndex: Int { get }
}
