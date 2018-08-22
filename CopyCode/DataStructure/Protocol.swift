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

protocol PixelRectangle {
    var pixelFrame: CGRect { get }
}

protocol StandartRectangle {
    var frame: CGRect { get }
    func intersectByX(with rectangle: StandartRectangle) -> Bool
    func intersectByY(with rectangle: StandartRectangle) -> Bool
}

extension StandartRectangle {
    func intersectByX(with rectangle: StandartRectangle) -> Bool {
        return intersectValue(with: rectangle) { ($0.frame.leftX.rounded(), $0.frame.rightX.rounded()) }
    }
    
    func intersectByY(with rectangle: StandartRectangle) -> Bool {
        return intersectValue(with: rectangle) { ($0.frame.topY.rounded(), $0.frame.bottomY.rounded()) }
    }
    
    private func intersectValue(with rectangle: StandartRectangle, op: (StandartRectangle) -> (CGFloat, CGFloat)) -> Bool {
        let (one, two) = op(self)
        let (newOne, newTwo) = op(rectangle)
        return rangeOf(one: one, two: two).overlaps(rangeOf(one: newOne, two: newTwo))
    }
}

protocol Rectangle: PixelRectangle, StandartRectangle, Layerable {
    var frame: CGRect { get }
    var pixelFrame: CGRect { get }
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
    
    var lettersAscendingByHeight: [Rectangle] {
        return letters.sorted { $0.frame.height <  $1.frame.height }
    }

    var letterWithMaxHeight: Rectangle? {
       return lettersAscendingByHeight.last
    }
    
    var letterWithMinHeight: Rectangle? {
        return lettersAscendingByHeight.first
    }
    
    var letterLowerY: Rectangle? {
        return ascendingLettersBottomY.first
    }
    
    var letterHigherY: Rectangle? {
        return ascendingLettersBottomY.last
    }
    
    
    var maxLetterHeight: CGFloat {
        return lettersAscendingByHeight.last?.frame.height ?? 0
    }
    
    var minLetterHeight: CGFloat {
        return lettersAscendingByHeight.first?.frame.height ?? 0
    }
    
    var lowerY: CGFloat {
        return ascendingLettersBottomY.first?.frame.bottomY ?? 0
    }

    
}



protocol BlockProtocol: StandartRectangle, Layerable {
    associatedtype WordChild: Rectangle
    var lines: [Line<WordChild>] { get }
}

protocol ValueProtocol {
    var value: String { get }
}
