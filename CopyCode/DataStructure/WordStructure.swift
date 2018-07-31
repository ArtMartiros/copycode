//
//  WordStructure.swift
//  CopyCode
//
//  Created by Артем on 19/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

protocol RectangleProtocol {
    var frame: CGRect { get }
    var pixelFrame: CGRect { get }
}

extension RectangleProtocol {
    var pixelLeftX: CGFloat { return pixelFrame.minX }
    var pixelRightX: CGFloat { return pixelFrame.maxX }
    var pixelTopY: CGFloat { return pixelFrame.maxY }
    var pixelBottomY: CGFloat { return pixelFrame.minY }
}

extension RectangleProtocol {
    var leftX: CGFloat { return frame.minX }
    var rightX: CGFloat { return frame.maxX }
    var topY: CGFloat { return frame.maxY }
    var bottomY: CGFloat { return frame.minY }
}

protocol WordRectangleProtocol: RectangleProtocol {
    var letters: [RectangleProtocol] { get }
}
extension WordRectangleProtocol {
    var symbolsCount: SymbolsCount {
       return SymbolsCount.symbols(withRatio: frame.ratio)
    }
}

extension WordRectangleProtocol {
    private var ascendingLettersBottomY: [RectangleProtocol] {
       return letters.sorted { $0.bottomY < $1.bottomY }
    }
    
    private var ascendingLettersHeight: [RectangleProtocol] {
        return letters.sorted { $0.frame.height <  $1.frame.height }
    }
    
    var lowerY: CGFloat {
        return ascendingLettersBottomY.first?.bottomY ?? 0
    }
    
    var standartBottomY: CGFloat {
        return ascendingLettersBottomY.last?.bottomY ?? 0
    }
    
    var maxLetterHeight: CGFloat {
        return ascendingLettersHeight.last?.frame.height ?? 0
    }
    
    var minLetterHeight: CGFloat {
        return ascendingLettersHeight.first?.frame.height ?? 0
    }
}

protocol ColumnProtocol: RectangleProtocol {
    var words: [WordRectangleProtocol] { get }
}

protocol BlockProtocol: RectangleProtocol {
    var blockWords: [WordRectangleProtocol] { get }
    init(blockWords: [WordRectangleProtocol], frame: CGRect)
}

//MARK: Rectangle
struct Column: ColumnProtocol {
    let frame: CGRect
    var pixelFrame: CGRect {
        return words.map { $0.pixelFrame }.compoundFrame
    }
    
    let words: [WordRectangleProtocol]
    init(words: [WordRectangleProtocol], frame: CGRect) {
        self.words = words
        self.frame = frame
    }
    
    static func from(_ words: [WordRectangleProtocol]) -> Column {
        let frame = words.map { $0.frame }.compoundFrame
        return Column(words: words, frame: frame)
    }
}

//protocol ColumnProtocol: RectangleProtocol {
//    var words: [WordRectangleProtocol] { get }
//    init(words: [WordRectangleProtocol], frame: CGRect)
//}
//extension ColumnProtocol {
//    static func from<T>(_ words: [WordRectangleProtocol]) -> T where T: BlockProtocol {
//        let frame = words.map { $0.frame }.compoundFrame
//        return T(words: words, frame: frame)
//    }
//}
//
struct Block: BlockProtocol {
    
    let frame: CGRect
    let blockWords: [WordRectangleProtocol]
    
    var pixelFrame: CGRect {
        return blockWords.map { $0.pixelFrame }.compoundFrame
    }
    init(blockWords words: [WordRectangleProtocol], frame: CGRect) {
        self.blockWords = words
        self.frame = frame
    }
    
    static func from(_ words: [WordRectangleProtocol]) -> Block {
        let frame = words.map { $0.frame }.compoundFrame
        return Block(blockWords: words, frame: frame)
    }
}


struct WordRectangle: WordRectangleProtocol {
    let frame: CGRect
    let pixelFrame: CGRect
    let letters: [RectangleProtocol]
    init(frame: CGRect, pixelFrame: CGRect, letters: [RectangleProtocol]) {
        self.frame = frame
        self.pixelFrame = pixelFrame
        self.letters = letters
    }
    
    static func from(_ letters: [RectangleProtocol]) -> WordRectangle {
        let frame = letters.map { $0.frame }.compoundFrame
        let pixelFrame = letters.map { $0.pixelFrame }.compoundFrame
        return WordRectangle(frame: frame, pixelFrame: pixelFrame, letters: letters)
    }
}

struct LetterRectangle: RectangleProtocol {
    let frame: CGRect
    let pixelFrame: CGRect
}


// MARK: Proto
struct WordRectangleWithType: RectangleProtocol {
    let frame: CGRect
    let pixelFrame: CGRect
    let type: WordType
    let letters: [LetterRectangleWithType]
    
    init(rectangle: RectangleProtocol, type: WordType, letters: [LetterRectangleWithType]) {
        self.frame = rectangle.frame
        self.pixelFrame = rectangle.pixelFrame
        self.type = type
        self.letters = letters
    }
}

struct LetterRectangleWithType: RectangleProtocol {
    let pixelFrame: CGRect
    let frame: CGRect
    let type: LetterType
    
    init(rectangle: RectangleProtocol, type: LetterType) {
        self.frame = rectangle.frame
        self.pixelFrame = rectangle.pixelFrame
        self.type = type
    }
}

//MARK: Final
protocol ValueProtocol {
    var value: String { get }
}

struct Word: RectangleProtocol, ValueProtocol {
    var frame: CGRect { return wordRectangle.frame }
    var pixelFrame: CGRect { return wordRectangle.pixelFrame }
    var value: String { return letters.map { $0.value }.joined() }
    let letters: [Letter]
    private let wordRectangle: WordRectangleProtocol
    init(wordRectangle:  WordRectangleProtocol, letters: [Letter]) {
        self.wordRectangle = wordRectangle
        self.letters = letters
    }
}

struct Letter: RectangleProtocol, ValueProtocol {
    let frame: CGRect
    let pixelFrame: CGRect
    let value: String
    
    init(rectangle: RectangleProtocol, value: String) {
        self.frame = rectangle.frame
        self.pixelFrame = rectangle.pixelFrame
        self.value = value
    }
}

