//
//  OCRHelper.swift
//  CopyCodeTests
//
//  Created by Артем on 28/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

final class OCRHelper {
    static func execute(_ object: AnyObject, scene: Scene, exlude: Set<Int>, isLow: Bool,
                        completion: @escaping (String, CompletedLetterPosition) -> Void) {
        let block = scene.getRestoredBlock(self, low: isLow)
        let bitmap = scene.getImage(isLow: isLow).bitmap

        for (lineIndex, line) in block.lines.enumerated() where !exlude.contains(lineIndex) {
            let rightLine = Array(scene.getLetters(for: lineIndex, isLow: isLow))

            for (wordIndex, word) in line.words.enumerated() {
                let recognizer = LetterRecognizer(bitmap, word: word)
                var startIndex = line.words[0..<wordIndex].map { $0.letters }.reduce([], +).count

                for (letterIndex, letter) in word.letters.enumerated() {
                    let value = recognizer.recognize(from: letter)
                    let answer = rightLine[startIndex]
                    let newLetter = Letter(rectangle: letter, value: value)
                    let position = LetterWithPosition(l: lineIndex, w: wordIndex, c: letterIndex,
                                                      lineCharCount: startIndex, letter: newLetter)

                    if letter.type != .custom {
                        print("T: \(letter.type)")
                        completion(answer, position)
                    }
                    startIndex += 1

                }
            }
        }

        let lettersCount = block.lines.map { $0.words.map { $0.letters } }.reduce([], +).reduce([], +).count
        print("letters count \(lettersCount)")
    }

    static func message(_ position: CompletedLetterPosition) -> String {
        return  "l: \(position.l), w: \(position.w) c: \(position.c), ❌ \(position.letter.value)"
    }
}
