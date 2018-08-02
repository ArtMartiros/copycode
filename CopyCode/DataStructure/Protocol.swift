//
//  Rectangle.swift
//  CopyCode
//
//  Created by Артем on 02/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

protocol Layerable {
    var frame: CGRect { get }
    func layer(_ color: NSColor, width: CGFloat) -> CALayer
}
extension Layerable {
    func layer(_ color: NSColor, width: CGFloat = 1) -> CALayer {
        let outline = CALayer()
        outline.frame = frame
        outline.borderWidth = width
        outline.borderColor = color.cgColor
        return outline
    }
}

protocol Rectangle: Layerable {
    var frame: CGRect { get }
    var pixelFrame: CGRect { get }
    func intersectByX(with rectangle: Rectangle) -> Bool
    func intersectByY(with rectangle: Rectangle) -> Bool
}

extension Rectangle {
    func intersectByX(with rectangle: Rectangle) -> Bool {
        return intersectValue(with: rectangle) { ($0.frame.leftX.rounded(), $0.frame.rightX.rounded()) }
    }
    
    func intersectByY(with rectangle: Rectangle) -> Bool {
        return intersectValue(with: rectangle) { ($0.frame.topY.rounded(), $0.frame.bottomY.rounded()) }
    }
    
    private func intersectValue(with rectangle: Rectangle, op: (Rectangle) -> (CGFloat, CGFloat)) -> Bool {
        let (one, two) = op(self)
        let (newOne, newTwo) = op(rectangle)
        return rangeOf(one: one, two: two).overlaps(rangeOf(one: newOne, two: newTwo))
    }
}

protocol WordRectangle_: Rectangle {
    var letters: [Rectangle] { get }
}

extension Container {
    var symbolsCount: SymbolsCount {
        return SymbolsCount.symbols(withRatio: frame.ratio)
    }
}

extension Container {
    private var ascendingLettersBottomY: [Rectangle] {
        return letters.sorted { $0.frame.bottomY < $1.frame.bottomY }
    }
    
    private var ascendingLettersHeight: [Rectangle] {
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

extension WordRectangle_ {
    var symbolsCount: SymbolsCount {
        return SymbolsCount.symbols(withRatio: frame.ratio)
    }
}

extension WordRectangle_ {
    private var ascendingLettersBottomY: [Rectangle] {
        return letters.sorted { $0.frame.bottomY < $1.frame.bottomY }
    }
    
    private var ascendingLettersHeight: [Rectangle] {
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

protocol ColumnProtocol: Rectangle {
    associatedtype Child: Rectangle
    var words: [Word<Child>] { get }
}

protocol BlockProtocol: Rectangle {
    associatedtype WordChild: Rectangle
    var lines: [Line<WordChild>] { get }
}

protocol ValueProtocol {
    var value: String { get }
}
