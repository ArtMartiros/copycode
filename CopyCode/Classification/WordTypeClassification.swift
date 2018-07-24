//
//  WordTypeClassification.swift
//  CopyCode
//
//  Created by Артем on 20/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation
let magnitude: CGFloat = 0.06
protocol WordTypeClassificationProtocol {
    func isMix(word: WordRectangleProtocol) -> Bool
}

class WordTypeClassification: WordTypeClassificationProtocol {
    func isMix(word: WordRectangleProtocol) -> Bool {
        
        let maxLetterHeight = word.maxLetterHeight
        let checker = Checker(height: maxLetterHeight)
        let lowerY = word.lowerY
        let isMixed = word.letters.first {
            !checker.isSame(first: maxLetterHeight, with: $0.frame.height)
//                || checker.differentBottomY(maxHeight: maxLetterHeight, wordLowerY: lowerY, letterY: $0.frame.bottomY)
            } != nil
        return isMixed
    }
    
}

class Checker {
    private let height: CGFloat
    
    init(height: CGFloat) {
        self.height = height
    }
    
    func isSame(first: CGFloat, with second: CGFloat) -> Bool {
        let diff = abs(first - second)
        let different = (diff / height) > magnitude
        return !different
    }
}
