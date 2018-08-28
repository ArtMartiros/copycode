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
    func chunkForSorted(_ compare: (Element, Element) -> Bool ) -> [[Element]] {
        var chunk: [Element] = []
        var chunks: [[Element]] = []
        var itemForCompare: Element!
        for (index, item) in self.enumerated() {
            //первоначальная установка
            if index == 0 {
                itemForCompare = item
                //                chunk.append(item)
                continue
            }
            
            //сама логика
            if compare(itemForCompare, item) {
                chunk.append(item)
            } else {
                chunks.append(chunk)
                itemForCompare = item
                chunk = [item]
            }
            
            //если последний элемент то надо записать все, что в буфере
            let isLastElement = index + 1 == self.count
            guard !isLastElement else  {
                chunks.append(chunk)
                continue
            }
            
        }
        return chunks
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
