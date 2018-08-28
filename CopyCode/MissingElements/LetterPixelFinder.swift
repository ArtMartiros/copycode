//
//  LetterPixelFinder.swift
//  CopyCode
//
//  Created by Артем on 27/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

class LetterPixelFinder {
    private let checker: LetterExistenceChecker
    
    init(checker: LetterExistenceChecker) {
        self.checker = checker
    }
    
    func find(in frame: CGRect, with edge: CGRectEdge) -> CGPoint? {
        // можно будет удалить пока оставил чтобы было просто а то вдруг понадобится
//        for x in 50...55 {
//            for y in 15...25 {
//                let point = CGPoint(x: x, y: y)
//                if checker.exist(at: point) {
//                    print("Zeus \(point)")
//                    
//                    
//                }
//            }
//        }

        //.,'
        let dotPoints = pointsFrom(xArray: [0.3, 0.4, 0.5], yArray: [0.2, 0.7, 0.8], in: frame, edge: edge)
        //-=_ и остальные
        let otherPoints = pointsFrom(xArray: [0.5], yArray: [0.4, 0.5, 0.6, 0.9, 1], in: frame, edge: edge)
        let points = dotPoints + otherPoints

        for point in points {
            if checker.exist(at: point) { return point.rounded }
        }
        return nil
    }
    
    private func pointsFrom(xArray: [CGFloat], yArray: [CGFloat], in frame: CGRect, edge: CGRectEdge) -> [CGPoint] {
        let value = CGFloat(edge.rawValue)
        let array = xArray.map { abs(value - $0) }
        var points: [CGPoint] = []
        for x in array {
            for y in yArray {
                let point = CGPoint(x: frame.xAs(rate: x), y: frame.yAs(rate: y))
                print(point)
                points.append(point)
            }
        }
        return points
    }
}


