//
//  Letter.swift
//  CopyCode
//
//  Created by Артем on 02/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct LetterRectangle: Rectangle, Hashable {
    let frame: CGRect
    let pixelFrame: CGRect
    
    init(rect: Rectangle) {
        self.frame = rect.frame
        self.pixelFrame = rect.pixelFrame
    }
    
    init(frame: CGRect, pixelFrame: CGRect) {
        self.frame = frame
        self.pixelFrame = pixelFrame
    }
    
    public var hashValue: Int {
        return frame.width.hashValue ^ frame.height.hashValue ^ frame.origin.x.hashValue ^ frame.origin.y.hashValue
    }
    
    ///коэфициент с помощью которого, мы по высоте определяем приблизительную длину символов
    private static let kHeightWidthRatio: CGFloat = 1.72
    
    static func letterWidth(from height: CGFloat) -> CGFloat {
        return height / kHeightWidthRatio
    }
    
}



struct LetterRectangleWithType: Rectangle {
    let pixelFrame: CGRect
    let frame: CGRect
    let type: LetterType
    
    init(rectangle: Rectangle, type: LetterType) {
        self.frame = rectangle.frame
        self.pixelFrame = rectangle.pixelFrame
        self.type = type
    }
}

struct Letter: Rectangle, ValueProtocol {
    let frame: CGRect
    let pixelFrame: CGRect
    let value: String
    
    init(rectangle: Rectangle, value: String) {
        self.frame = rectangle.frame
        self.pixelFrame = rectangle.pixelFrame
        self.value = value
    }
}
