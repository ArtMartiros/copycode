//
//  SceneTypeTests.swift
//  CopyCodeTests
//
//  Created by Артем on 03/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

class SceneTypeTests: XCTestCase {
    //1
    func testSc1() {
        executeCheck(scene: .sc1, exluded: [0]) { (type, position) in
            XCTAssertEqual(position.letter.type, type, "L: \(position.l), index: \(position.lineCharCount)")
        }
    }
    
    func testSc2() {
        executeCheck(scene: .sc2, exluded: []) { (type, position) in
            XCTAssertEqual(position.letter.type, type, "L: \(position.l), index: \(position.lineCharCount)")
        }
    }
    
    func testSc3_p1() {
        executeCheck(scene: .sc3_p1, exluded: []) { (type, position) in
            print(type)
            XCTAssertEqual(position.letter.type, type, "L: \(position.l), index: \(position.lineCharCount)")
        }
    }
    
    func testSc3_p2() {
        executeCheck(scene: .sc3_p2, exluded: []) { (type, position) in
            print(type)
            XCTAssertEqual(position.letter.type, type, "L: \(position.l), index: \(position.lineCharCount)")
        }
    }
    
    func testSc9() {
        executeCheck(scene: .sc9, exluded: []) { (type, position) in
            XCTAssertEqual(position.letter.type, type, "L: \(position.l), index: \(position.lineCharCount)")
        }
    }
    
    func testSc11() {
        executeCheck(scene: .sc11, exluded: []) { (type, position) in
            print(type)
            XCTAssertEqual(position.letter.type, type, "L: \(position.l), index: \(position.lineCharCount)")
        }
    }
    
    private func executeCheck(scene: Scene, exluded: Set<Int>,
                              completion: @escaping (LetterType, SimpleLetterPosition) -> Void) {
        
        let block = scene.getRestoredBlock(self)
        let bitmap = scene.image.bitmap

        guard case .grid(let grid) = block.typography else { return }
        let typeConverter = TypeConverter(in: bitmap, grid: grid, type: .all)
            for (lineIndex, line) in block.lines.enumerated() {
                guard !exluded.contains(lineIndex) else { continue }

                let newLine = typeConverter.convert(line)
                let letters = newLine.words.map { $0.letters.map { $0 } }.reduce([], +)
                print("Bukaki\(lineIndex) \(letters.count)")
                let rightLetterTypes = scene.getLetterTypes(for: lineIndex)
                for (letterIndex, letter) in letters.enumerated() {
                    let answer = rightLetterTypes[letterIndex]
                    let position = LetterWithPosition(l: lineIndex, w: 0, c: 0, lineCharCount: letterIndex, letter: letter)
                    completion(answer, position)
                }

            }
        }
}
