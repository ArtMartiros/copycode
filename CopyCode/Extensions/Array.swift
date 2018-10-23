//
//  Array.swift
//  CopyCode
//
//  Created by Артем on 18/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

extension Array where Element: NSColor {
    var averageColor: NSColor {
        var averages = [CGFloat]()
        for i in 0..<4 {
            let total = self.map { ($0 as NSColor).cgColor.components![i] } .reduce(0, +)
            let avg = total / CGFloat(count)
            averages.append(avg)
        }
        return NSColor(red: averages[0], green: averages[1], blue: averages[2], alpha: averages[3])
    }
}

extension Array where Element == Word<LetterRectangle> {
    var firstMixedWord: Word<LetterRectangle>? {
        let classification = WordTypeIdentifier()
        return self.first { classification.isMix(word: $0) }
    }

    var allWordsMixed: Bool {
        let classification = WordTypeIdentifier()
        return first { !classification.isMix(word: $0) } == nil
    }
    var allWordsSame: Bool {
        return !allWordsMixed
    }
}
extension Array where Element == CGRect {
    var compoundFrame: CGRect {
        guard !isEmpty else { return .zero }
        let minX = map { $0.minX }.sorted(by: < )[0]
        let maxX = map { $0.maxX }.sorted(by: > )[0]
        let minY = map { $0.minY }.sorted(by: < )[0]
        let maxY = map { $0.maxY }.sorted(by: > )[0]
        return CGRect(left: minX, right: maxX, top: maxY, bottom: minY)
    }
}

extension Array where Element: Layerable {
    func layers(_ color: NSColor, width: CGFloat = 1) -> [CALayer] {
        return map { $0.layer(color, width: width) }
    }
}

extension Array {

    func forEachPairWithIndex(_ elements: (_ current: Element, _ next: Element, _ index: Int) -> Void ) {
        for (index, item) in self.enumerated() {
            let nextIndex = index + 1
            guard nextIndex < count else { break }
            elements(item, self[nextIndex], index)
        }
    }

    ///Два элемента сразу дает, текущий и след
    func forEachPair(_ elements: (_ current: Element, _ next: Element) -> Void ) {
        for (index, item) in self.enumerated() {
            let nextIndex = index + 1
            guard nextIndex < count else { break }
            elements(item, self[nextIndex])
        }
    }

    func enumeratedMap<T>(_ transform: (_ current: Element, _ index: Int) throws -> T) rethrows -> [T] {
        var newArray: [T] = []
        for (index, item) in self.enumerated() {
            let nextIndex = index + 1
            guard nextIndex < count else { break }
            let element = try transform(item, index)
            newArray.append(element)
        }
        return newArray
    }

    func mapPair<T>(_ transform: (_ current: Element, _ next: Element) throws -> T) rethrows -> [T] {
        var newArray: [T] = []
        for (index, item) in self.enumerated() {
            let nextIndex = index + 1
            guard nextIndex < count else { break }
            let element = try transform(item, self[nextIndex])
            newArray.append(element)
        }
        return newArray
    }

    func enumeratedMapPair<T>(_ transform: (_ current: Element, _ next: Element, _ index: Int) throws -> T) rethrows -> [T] {
        var newArray: [T] = []
        for (index, item) in self.enumerated() {
            let nextIndex = index + 1
            guard nextIndex < count else { break }
            let element = try transform(item, self[nextIndex], index)
            newArray.append(element)
        }
        return newArray
    }

    typealias PastCurrentFuture = (past: Element?, present: Element, future: Element?)

    func pastCurrentFuture() -> [PastCurrentFuture] {
        var array: [PastCurrentFuture] = []
        for (index, item) in self.enumerated() {
            let past = index == 0 ? nil : self[index - 1]
            let element: PastCurrentFuture = (past, item, self.optional(atIndex: index + 1))
            array.append(element)
        }

        return array
    }

    func optional(atIndex index: Int) -> Element? {
        guard index >= 0 && index < count else { return nil }
        return self[index]
    }
}

extension Array where Element: Rectangle {
    func sortedFromTopToBottom() -> [Element] {
        return sorted { $0.frame.bottomY >  $1.frame.bottomY }
    }

    func sortedFromBottomToTop() -> [Element] {
        return sorted { $0.frame.bottomY <  $1.frame.bottomY }
    }
    func sortedFromLeftToRight() -> [Element] {
        return sorted { $0.frame.leftX <  $1.frame.leftX }
    }

    func sortedFromRightToLeft() -> [Element] {
        return sorted { $0.frame.leftX >  $1.frame.leftX }
    }
}
