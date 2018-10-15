//
//  Block.swift
//  CopyCode
//
//  Created by Артем on 02/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

struct Block<WordChild: Rectangle>: BlockProtocol, Gapable {
    
    let frame: CGRect
    let lines: [Line<WordChild>]
    let column: ColumnType
    var typography: Typography
    
    var gaps: [Gap] {
        var gaps: [Gap] = []
        lines.forEachPair {
            let gapFrame = CGRect(left: frame.leftX, right: frame.rightX,
                                  top: $0.frame.bottomY, bottom: $1.frame.topY)
            gaps.append(Gap(frame: gapFrame))
        }
        return gaps
    }
    
    var averageLineHeight: CGFloat {
        let sum = lines.map { $0.frame.height }.reduce(0, +)
        return (sum / CGFloat(lines.count)).rounded()
    }
    
    ///старый вариант пока не использую
   private func maxLineHeight2() -> CGFloat {
        let heights = lines.map { $0.frame.height }.sorted { $0 > $1 }
        return heights[0]
    }
    
    /// исключая аномальный результат буквы, место где ты печатаешь там палочка,
    /// она считается тоже буквой и дает аномальную высоту, ее надо исключить из поиска
    /// если будет хуево работать можно просто сделать новую линию убрав эту буквы и потом еще раз поискать
    ///пока итак норм
    func maxLineHeight() -> CGFloat {
        return lineWithMaxHeight().frame.height
    }
    
    func lineWithMaxHeight() -> Line<WordChild> {
        let sortedLines = lines.sorted { $0.frame.height > $1.frame.height }
        lineLoop: for line in sortedLines {
            let lineHeight = line.frame.height
            let words = line.words.sorted { $0.frame.height > $1.frame.height }
            for word in words {
                let filteredLetters = word.letters.filter { lineHeight == $0.frame.height }
                if filteredLetters.count == 1 {
                    let letter = filteredLetters[0]
                    if letter.frame.ratio > 7 {
                        continue lineLoop
                    } else {
                        return line
                    }
                } else {
                    return line
                }
            }
        }
        return sortedLines[0]
    }
    
    init(lines: [Line<WordChild>], frame: CGRect, column: ColumnType, typography: Typography) {
        self.lines = lines
        self.frame = frame
        self.column = column
        self.typography = typography
    }
    
    mutating func update(_ typography: Typography) {
        self.typography = typography
    }
    
    static func from(_ lines: [Line<WordChild>], column: ColumnType, typography: Typography) -> Block {
        let frame = lines.map { $0.frame }.compoundFrame
        return Block(lines: lines, frame: frame, column: column, typography: typography)
    }
    
    static func updateTypography(_ block: Block, with leading: Leading?) -> Block {
        guard case .tracking(let data) = block.typography, let leading = leading
            else { return  block }
        let grid = Typography.grid(TypographicalGrid(data: data, leading: leading))
        let newBlock = Block(lines: block.lines, frame: block.frame, column: block.column, typography: grid)
        return newBlock
    }
}

