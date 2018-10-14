//
//  CustomTypeTests.swift
//  CopyCodeTests
//
//  Created by Артем on 03/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

class CustomTypeTests: XCTestCase {
    
    //ошиька С не знаю как исправить
    func testSc1() {
        executeCheck(scene: .sc1, exluded: [0]) { (type, position) in
            XCTAssertEqual(position.letter.type, type,  "L: \(position.l), index: \(position.lineCharCount)")
        }
    }
    
    //    ошибка с p можно исправить улучшением соотношения
    func testSc2() {
        executeCheck(scene: .sc2, exluded: []) { (type, position) in
            XCTAssertEqual(position.letter.type, type,  "L: \(position.l), index: \(position.lineCharCount)")
        }
    }
    
    func testSc3_p1() {
        executeCheck(scene: .sc3_p1, exluded: []) { (type, position) in
            XCTAssertEqual(position.letter.type, type,  "L: \(position.l), index: \(position.lineCharCount)")
        }
    }
    
    func testSc3_p2() {
        executeCheck(scene: .sc3_p2, exluded: []) { (type, position) in
            XCTAssertEqual(position.letter.type, type,  "L: \(position.l), index: \(position.lineCharCount)")
        }
    }
    
    func testSc9() {
        executeCheck(scene: .sc9, exluded: []) { (type, position) in
            XCTAssertEqual(position.letter.type, type,  "L: \(position.l), index: \(position.lineCharCount)")
        }
    }
    
    func testSc11() {
        executeCheck(scene: .sc11, exluded: [9, 10, 11]) { (type, position) in
            XCTAssertEqual(position.letter.type, type,  "L: \(position.l), index: \(position.lineCharCount)")
        }
    }
    
    func executeCheck(scene: Scene, exluded: Set<Int>, completion: @escaping (LetterType, SimpleLetterPosition) -> Void ) {
        let bitmap = scene.image.bitmap
        let typeConverter = TypeConverter(in: bitmap)
        let block = scene.getGridBlock(self)
        
        for (lineIndex, line) in block.lines.enumerated() where !exluded.contains(lineIndex) {
            let newLine = typeConverter.convert(line, typography: block.typography)
            let letters = newLine.words.map { $0.letters.map { $0 } }.reduce([], +)
            print("Letters coun: \(letters.count)")
            let rightLetterTypes = scene.getLetterTypes(for: lineIndex)
            
            for (letterIndex, letter) in letters.enumerated() {
                let rightType = rightLetterTypes[letterIndex]
                let position = LetterWithPosition(l: lineIndex, w: 0, c: 0, lineCharCount: letterIndex, letter: letter)
                completion(rightType, position)
            }
        }
    }
}
