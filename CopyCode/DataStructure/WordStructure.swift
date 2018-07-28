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

protocol WordRectangleProtocol: RectangleProtocol {
    var letters: [RectangleProtocol] { get }
}

extension WordRectangleProtocol {
    private var ascendingLettersBottomY: [RectangleProtocol] {
       return letters.sorted { $0.frame.bottomY < $1.frame.bottomY }
    }
    
    private var ascendingLettersHeight: [RectangleProtocol] {
        return letters.sorted { $0.frame.height <  $1.frame.height }
    }
    
    var lowerY: CGFloat {
        return ascendingLettersBottomY.first?.frame.bottomY ?? 0
    }
    
    var standartBottomY: CGFloat {
        return ascendingLettersBottomY.last?.frame.bottomY ?? 0
    }
    
    var maxLetterHeight: CGFloat {
        return ascendingLettersHeight.last?.frame.height ?? 0
    }
    
    var minLetterHeight: CGFloat {
        return ascendingLettersHeight.first?.frame.height ?? 0
    }
}

//MARK: Rectangle
struct WordRectangle: WordRectangleProtocol {
    let frame: CGRect
    let pixelFrame: CGRect
    var letters: [RectangleProtocol]
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

