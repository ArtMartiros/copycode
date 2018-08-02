//
//  Letter.swift
//  CopyCode
//
//  Created by Артем on 02/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct LetterRectangle: Rectangle {
    let frame: CGRect
    let pixelFrame: CGRect
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
