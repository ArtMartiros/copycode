//
//  LetterTypeClassification.swift
//  CopyCode
//
//  Created by Артем on 20/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

class LetterTypeClassification {
    private let wordLowerY: CGFloat
    private let wordMaxLetterHeight: CGFloat
    private let wordMinLetterHeight: CGFloat
    private let letterFrame: CGRect
    private let checker: Checker
    init(wordLowerY: CGFloat, wordMaxLetterHeight: CGFloat, wordMinLetterHeight: CGFloat, letterFrame: CGRect) {
        self.checker = Checker(height: wordMaxLetterHeight)
        self.wordMaxLetterHeight = wordMaxLetterHeight
        self.wordMinLetterHeight = wordMinLetterHeight
        self.wordLowerY = wordLowerY
        self.letterFrame = letterFrame
    }
    
    var type: LetterType {
        //Высота должна быть самая маленькая, тогда значит, что это будет прописная буква
        //если есть хвостик, то автоматически высота будет отличаться
        return isLow ? .low : (withTail ? .lowWithTail : .upper)
    }
    
   private var isLow: Bool {
        return checker.isSame(first: wordMinLetterHeight, with: letterFrame.height)
    }
    
   private var withTail: Bool {
        return checker.isSame(first: wordLowerY, with: letterFrame.bottomY)
    }
    
    
}
