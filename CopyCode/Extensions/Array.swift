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
}
extension Array where Element == CGRect {
    var compoundFrame: CGRect {
        guard !isEmpty else { return .zero }
        let minX = map { $0.minX }.sorted(by: < )[0]
        let maxX = map { $0.maxX }.sorted(by: > )[0]
        let minY = map { $0.minY }.sorted(by: < )[0]
        let maxY = map { $0.maxY }.sorted(by: > )[0]
        let width = maxX - minX
        let height = maxY - minY
        return CGRect(x: minX, y: minY, width: width, height: height)
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
}

extension Array where Element: StandartRectangle {
    var sortedFromTopToBottom: [Element] {
        return sorted { $0.frame.bottomY >  $1.frame.bottomY }
    }
    
    var sortedFromBottomToTop: [Element] {
        return sorted { $0.frame.bottomY <  $1.frame.bottomY }
    }
    var sortedFromLeftToRight: [Element] {
        return sorted { $0.frame.leftX <  $1.frame.leftX }
    }
    
    var sortedFromRightToLeft: [Element] {
        return sorted { $0.frame.leftX >  $1.frame.leftX }
    }
}
