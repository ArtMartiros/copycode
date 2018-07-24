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

extension Array where Element == WordRectangleProtocol {
    var firstMixedWord: WordRectangleProtocol? {
        let classification = WordTypeClassification()
        return self.first { classification.isMix(word: $0) }
    }
}

//extension Array where Element == RectangleProtocol {
//    var frame: CGRect {
//        return map { $0.frame }.compoundFrame
//    }
//    var pixelFrame: CGRect {
//        return map { $0.pixelFrame }.compoundFrame
//    }
////    var frame: CGRect {
////        guard let frame = first?.frame else { return .zero }
////        let wigth = last!.frame.maxX - frame.bL.x
////        let height = frame.topY - frame.bottomY
////        let size = CGSize(width: wigth, height: height)
////        return CGRect(origin: frame.bL, size: size)
////    }
//}

extension Array where Element == CGRect {
    var compoundFrame: CGRect {
        guard !isEmpty else { return .zero }
        let minX = map { $0.minX }.sorted(by: < )[0]
        let maxX = map { $0.maxX }.sorted(by: > )[0]
        let minY = map { $0.minY }.sorted(by: < )[0]
        let maxY = map { $0.maxX }.sorted(by: > )[0]
        let width = maxX - minX
        let height = maxY - minY
        return CGRect(x: minX, y: minY, width: width, height: height)
    }
}
