//
//  WordTypeIdentifier.swift
//  CopyCode
//
//  Created by Артем on 20/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

protocol WordTypeClassificationProtocol {
    func isMix(word: Word<LetterRectangle>) -> Bool
}

class WordTypeIdentifier: WordTypeClassificationProtocol {
    private let kWordTypeIdentifierAccuracy: CGFloat = 1.24
    //Этот вариант лучше но надо будет его прописать
    func isMix(wordMaxHeight: CGFloat, wordMinHeight: CGFloat) -> Bool {
        return true
    }
    func isMix(word: Word<LetterRectangle>) -> Bool {
        let maxLetterHeight = word.maxLetterHeight
        let checker = Checker(height: maxLetterHeight)
//        print("WordTypeIdentifier isMix start")
        let isMixed = word.letters.first { !checker.isSameHeight(first: maxLetterHeight,
                                                           with: $0.frame.height,
                                                           accuracy: kWordTypeIdentifierAccuracy)
            } != nil
//        print("WordTypeIdentifier isMix stop \(isMixed)")
        return isMixed
    }
}
