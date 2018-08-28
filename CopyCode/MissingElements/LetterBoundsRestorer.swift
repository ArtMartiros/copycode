//
//  LetterBoundsRestorer.swift
//  CopyCode
//
//  Created by Артем on 27/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation


///Восстанавливает frame по одному единственному поинту
protocol PixelBoundsRestorable {
    func restore(atPoint point: CGPoint) -> CGRect
}

///Восстанавливает frame буквы по одному единственному поинту
class LetterBoundsRestorer: PixelBoundsRestorable {
    private let checker: LetterExistenceChecker
    
    init(checker: LetterExistenceChecker) {
        self.checker = checker
    }
    
    ///Восстанавливает границы буквы.
    ///Все происходит в pixelFrame
    func restore(atPoint point: CGPoint) -> CGRect {
        
        return .zero
    }
    
    func restore(atPoint point: CGPoint, in frame: CGRect) -> CGRect {
        
        return .zero
    }
}

//func find(in frame: CGRect, with edge: CGRectEdge) -> CGPoint? {
//    let value = CGFloat(1 - edge.rawValue)
//    let array: [CGFloat] = [0.1, 0.5, 0.9].map { abs(value - $0) }
//    for x in array {
//        for y in array {
//            let point = CGPoint(x: frame.xAs(rate: x), y: frame.yAs(rate: y))
//            if checker.exist(at: point) { return point }
//        }
//    }
//    return nil
//}
