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

protocol Rectangle: RatioUpdatable, Layerable, Codable {
    var frame: CGRect { get }
    func intersectByX(with rectangle: Rectangle) -> Bool
    func intersectByY(with rectangle: Rectangle) -> Bool
    func inside(in rectangle: Rectangle) -> Bool
}

protocol RatioUpdatable {
   func updated(by rate: Int) -> Self
}
extension Rectangle {
    func updatedFrame(by rate: Int) -> CGRect {
        let rate = CGFloat(rate)
        let x = frame.origin.x / rate
        let y = frame.origin.y / rate
        let width = frame.size.width / rate
        let height = frame.size.height / rate
        return CGRect(x: x, y: y, width: width, height: height)
    }

    func intersectByX(with rectangle: Rectangle) -> Bool {
        return intersectValue(with: rectangle) { ($0.frame.leftX.rounded(), $0.frame.rightX.rounded()) }
    }

    func intersectByY(with rectangle: Rectangle) -> Bool {
        return intersectValue(with: rectangle) { ($0.frame.topY.rounded(), $0.frame.bottomY.rounded()) }
    }

    func inside(in rectangle: Rectangle) -> Bool {
      return rectangle.frame.leftX < frame.leftX  &&  frame.rightX < rectangle.frame.rightX
    }

    private func intersectValue(with rectangle: Rectangle, op: (Rectangle) -> (CGFloat, CGFloat)) -> Bool {
        let (one, two) = op(self)
        let (newOne, newTwo) = op(rectangle)
        return rangeOf(one: one, two: two).overlaps(rangeOf(one: newOne, two: newTwo))
    }
}

protocol Container: Rectangle {
    associatedtype Content: Rectangle
    var letters: [Content] { get }
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

protocol BlockProtocol: Rectangle {
    associatedtype WordChild: Rectangle
    var lines: [Line<WordChild>] { get }
}

protocol ValueProtocol {
    var value: String { get }
}

protocol Gapable {
    var gaps: [Gap] { get }

}
