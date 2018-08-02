//
//  ProtoWordConverter.swift
//  CopyCode
//
//  Created by Артем on 20/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

class WordRectangleWithTypeConverter {
    
    private var mixedWordRectangle: WordRectangle_!
    private let wordClassification = WordTypeClassification()
    
    func convert(_ rectangles: [WordRectangle_]) -> [WordRectangleWithType] {
        mixedWordRectangle = rectangles.firstMixedWord!
        return rectangles.map {
           return getWord(from: $0)
            
        }
    }

    private func wordLowerY(from protoWord: WordRectangle_) -> CGFloat {
        let mixedLowerY = mixedWordRectangle.lowerY
        let protoLowerY = protoWord.lowerY
        // так как минимальный y = 0
        return min(mixedLowerY, protoLowerY)
    }
    
    private func maxLetterHeight(from protoWord: WordRectangle_) -> CGFloat {
        let mixedMaxHeight = mixedWordRectangle.maxLetterHeight
        let protoMaxHeight = protoWord.maxLetterHeight
        return max(mixedMaxHeight, protoMaxHeight)
    }
    
    private func minLetterHeight(from protoWord: WordRectangle_) -> CGFloat {
        let mixedMinHeight = mixedWordRectangle.minLetterHeight
        let protoMinHeight = protoWord.minLetterHeight
        return min(mixedMinHeight, protoMinHeight)
    }
    
    private func getWord(from protoWord: WordRectangle_) -> WordRectangleWithType {
        if wordClassification.isMix(word: protoWord) {
            let chars = getLetters(from: protoWord.letters, wordLowerY: protoWord.lowerY, wordMaxHeight: protoWord.maxLetterHeight, wordMinHeight: protoWord.minLetterHeight)
            return WordRectangleWithType(rectangle: protoWord, type: .mix, letters: chars)
        } else {
            let lowerY = wordLowerY(from: protoWord)
            let maxHeight = maxLetterHeight(from: protoWord)
            let minHeight = minLetterHeight(from: protoWord)
            let chars = getLetters(from: protoWord.letters, wordLowerY: lowerY, wordMaxHeight: maxHeight, wordMinHeight: minHeight)
            let charType = chars.first?.type ?? .undefined
            let type = WordType.SameType(charType)
            return WordRectangleWithType(rectangle: protoWord, type: .same(type: type), letters: chars)
        }
    }
    
    private func getLetters(from letters: [Rectangle], wordLowerY: CGFloat, wordMaxHeight: CGFloat, wordMinHeight: CGFloat) -> [LetterRectangleWithType] {
        return letters.map {
            let classification = LetterTypeClassification(wordLowerY: wordLowerY, wordMaxLetterHeight: wordMaxHeight, wordMinLetterHeight: wordMinHeight, letterFrame: $0.frame)
            return LetterRectangleWithType(rectangle: $0, type: classification.type)
        }
    }
}
