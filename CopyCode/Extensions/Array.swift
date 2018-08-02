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

extension Array where Element == WordRectangle_ {
    var firstMixedWord: WordRectangle_? {
        let classification = WordTypeClassification()
        return self.first { classification.isMix(word: $0) }
    }
    
    var allWordsMixed: Bool {
        let classification = WordTypeClassification()
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
    func chunkForSorted(_ action: (Element, Element) -> Bool ) -> [[Element]] {
        var chunk: [Element] = []
        var chunks: [[Element]] = []
        
        for (index, item) in self.enumerated() {
            if index == 0 {
                chunk.append(item)
                continue
            }
            
            let previousItem = self[index - 1]
            if action(item, previousItem) {
                chunk.append(item)
            } else {
                chunks.append(chunk)
                chunk = [item]
            }
        }
        if !chunk.isEmpty {
            chunks.append(chunk)
        }
        return chunks
    }
}
