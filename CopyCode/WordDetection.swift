//
//  WordDetection.swift
//  CopyCode
//
//  Created by Артем on 18/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit
import Foundation
import Vision

class WordDetection {
    
    private let bitmap: NSBitmapImageRep
    private let letterDetection: LetterDetection

    init(in bitmap: NSBitmapImageRep) {
        self.bitmap = bitmap
        self.letterDetection = LetterDetection(in: bitmap)
    }
    
    var testArray: [String] {
        let answer = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let array = Array(answer).map { String($0) }
        return array
    }
    
    func word(from text: VNTextObservation) -> String {
//        let word = convertToWord(from: text)
//        let stringWord = word.letters.compactMap { letterDetection.letter(from: $0.frame) }.joined()
//        return stringWord
        return ""
    }
}

class LetterDetection {
    
    private let bitmap: NSBitmapImageRep
    
    init(in bitmap: NSBitmapImageRep) {
        self.bitmap = bitmap
    }
   
    func letter(from rectangle: LetterRectangle, with type: LetterType) -> Letter {
        let value: String
        switch type {
        case .upper: value = upperTree.find(in: bitmap, with: rectangle.pixelFrame)!
        case .low: value = lowTree.find(in: bitmap, with: rectangle.pixelFrame)!
        case .lowWithTail: value = lowWithTailTree.find(in: bitmap, with: rectangle.pixelFrame)!
        default: value = "*"
        }

        return Letter(rectangle: rectangle, value: value)
    }
    
}
