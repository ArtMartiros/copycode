//
//  LetterRecognizer.swift
//  CopyCode
//
//  Created by Артем on 18/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit
import Foundation
import Vision

class LetterRecognizer {
    
    private let bitmap: NSBitmapImageRep
    
    init(in bitmap: NSBitmapImageRep) {
        self.bitmap = bitmap
    }
   
    func recognize(from frame: CGRect, with type: LetterType) -> String {
        let value: String
        switch type {
        case .upper: return upperTree.find(in: bitmap, with: frame)!
        case .low: value = lowTree.find(in: bitmap, with: frame)!
        case .lowWithTail: value = lowWithTailTree.find(in: bitmap, with: frame)!
        default: value = "*"
        }
        return value
    }
    
    func recognize(from rectangle: LetterRectangle, with type: LetterType) -> Letter {
        let letterValue = recognize(from: rectangle.pixelFrame, with: type)
        return Letter(rectangle: rectangle, value: letterValue)
    }
}

