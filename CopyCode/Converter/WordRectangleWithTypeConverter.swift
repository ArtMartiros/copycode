//
//  ProtoWordConverter.swift
//  CopyCode
//
//  Created by Артем on 20/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

class WordRectangleWithTypeConverter {
    typealias WordAlias = Word<LetterRectangle>

    func convertNew(_ rectangles: [WordAlias], in bitmap: NSBitmapImageRep) -> [Word<LetterRectangleWithType>] {
        return rectangles.map {
            return getNewWord(from: $0, in: bitmap)
        }
    }
    
    private func getNewWord(from word: WordAlias, in bitmap: NSBitmapImageRep ) -> Word<LetterRectangleWithType> {
        let information = WordInformation(max: word.letterWithMaxHeight!,
                                          lowerY: word.letterLowerY!,
                                          word: word)
        let recognizer = LetterRecognizer(bitmap, rectangle: word)
        let classification = NewLetterTypeClassification(information: information, recognizer: recognizer)
        let letters = getNewLetters(from: word.letters, using: classification)
        return Word(rect: word, type: .mix, letters: letters)
    }
    
    private func getNewLetters(from letters: [LetterRectangle],
                               using classification: NewLetterTypeClassification) -> [LetterRectangleWithType] {
        let types = classification.detectType(for: letters)
        var letters: [LetterRectangleWithType] = []
        for (index, item) in letters.enumerated() {
            letters.append(LetterRectangleWithType(rectangle: item, type: types[index]))
        }
        return letters
    }
    
    private var mixedWordRectangle: Word<LetterRectangle>!
    private let wordClassification = WordTypeClassification()
    
    func convert(_ rectangles: [WordAlias]) -> [Word<LetterRectangleWithType>] {
        mixedWordRectangle = rectangles.firstMixedWord!
        return rectangles.map {
            return getWord(from: $0)
        }
    }
    
    
    private func maxLetterHeight(from protoWord: WordAlias) -> CGFloat {
        let mixedMaxHeight = mixedWordRectangle.maxLetterHeight
        let protoMaxHeight = protoWord.maxLetterHeight
        return max(mixedMaxHeight, protoMaxHeight)
    }
    
    private func minLetterHeight(from protoWord: WordAlias) -> CGFloat {
        let mixedMinHeight = mixedWordRectangle.minLetterHeight
        let protoMinHeight = protoWord.minLetterHeight
        return min(mixedMinHeight, protoMinHeight)
    }

    
    
    private func getWord(from protoWord: WordAlias) -> Word<LetterRectangleWithType> {
        if wordClassification.isMix(word: protoWord) {
            let chars = getLetters(from: protoWord.letters, wordLowerY: protoWord.lowerY, wordMaxHeight: protoWord.maxLetterHeight, wordMinHeight: protoWord.minLetterHeight)
            return Word(rect: protoWord, type: .mix, letters: chars)
        } else {
            let maxHeight = maxLetterHeight(from: protoWord)
            let minHeight = minLetterHeight(from: protoWord)
            let chars = getLetters(from: protoWord.letters, wordLowerY: protoWord.lowerY, wordMaxHeight: maxHeight, wordMinHeight: minHeight)
            let charType = chars.first?.type ?? .undefined
            let type = WordType.SameType(charType)
            return Word(rect: protoWord, type: .same(type: type), letters: chars)
        }
    }
    
    private func getLetters(from letters: [Rectangle], wordLowerY: CGFloat, wordMaxHeight: CGFloat, wordMinHeight: CGFloat) -> [LetterRectangleWithType] {
        
        return letters.map {
            let classification = LetterTypeClassification(wordLowerY: wordLowerY, wordMaxLetterHeight: wordMaxHeight, wordMinLetterHeight: wordMinHeight, letterFrame: $0.frame)
            return LetterRectangleWithType(rectangle: $0, type: classification.type)
        }
    }
}
