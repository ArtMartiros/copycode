//
//  TypeHelper.swift
//  CopyCodeTests
//
//  Created by Артем on 28/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

class TypeHelper {
    static func message(_ position: SimpleLetterPosition) -> String {
        return "L: \(position.l), index: \(position.lineCharCount), ❌: \(position.letter.type)"
    }

    static func execute(_ object: AnyObject, scene: Scene, exluded: Set<Int>, isLow: Bool,
                        completion: @escaping (LetterType, SimpleLetterPosition) -> Void) {

        let block = scene.getRestoredBlock(object, low: isLow)
        let bitmap = scene.getImage(isLow: isLow).bitmap

        guard case .grid(let grid) = block.typography else { return }
        let typeConverter = TypeConverter(in: bitmap, grid: grid, type: .all)
        for (lineIndex, line) in block.lines.enumerated() {
            guard !exluded.contains(lineIndex) else { continue }

            let newLine = typeConverter.convert(line)
            let letters = newLine.words.map { $0.letters.map { $0 } }.reduce([], +)
            print("Bukaki\(lineIndex) \(letters.count)")
            let rightLetterTypes = scene.getLetterTypes(for: lineIndex, isLow: isLow)
            for (letterIndex, letter) in letters.enumerated() {
                let answer = rightLetterTypes[letterIndex]
                let position = LetterWithPosition(l: lineIndex, w: 0, c: 0, lineCharCount: letterIndex, letter: letter)
                completion(answer, position)
            }
        }
    }
}
