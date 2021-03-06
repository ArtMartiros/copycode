//
//  Block.swift
//  CopyCode
//
//  Created by Артем on 02/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

final class Block<WordChild: Rectangle>: BlockProtocol, Gapable {
    func updated(by rate: Int) -> Block<WordChild> {
        let frame = updatedFrame(by: rate)
        let newLines = lines.map { $0.updated(by: rate) }
        let newColumn = column.updated(by: rate)
        let typography = self.typography.updated(by: rate)
        return Block(lines: newLines, frame: frame, column: newColumn, typography: typography)
    }

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

    /// исключая аномальный результат буквы, место где ты печатаешь там палочка,
    /// она считается тоже буквой и дает аномальную высоту, ее надо исключить из поиска
    /// если будет хуево работать можно просто сделать новую линию убрав эту буквы и потом еще раз поискать
    ///пока итак норм
    func maxLineHeight() -> CGFloat {
        return lineWithMaxHeight().frame.height
    }

    ///можно очистить аномальную высоту и потом начать работать
    func simpleMaxLineHeight() -> CGFloat {
        return simpleMaxLine().frame.height
    }

    func simpleMaxLine() -> Line<WordChild> {
        let sortedLines = lines.sorted { $0.frame.height > $1.frame.height }
        return sortedLines[0]
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

    func update(_ typography: Typography) {
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

///Нахождение и ужаление запрещенных символов
extension Block {
    func withOutAnomaly() -> Block<WordChild> {
        guard let forbidden = findAnomalyLetter() else {
            return self
        }

        return removeLetter(at: forbidden)
    }

    func findAnomalyLetter() -> LetterInBlockPosition? {
        let sortedLines = lines
            .enumerated().notReversed()
            .sorted { $0.element.frame.height > $1.element.frame.height }

        let highestLine = sortedLines[0]
        guard let forbidden = highestLine.element.anomalyElementIndex
            else { return nil }
        return  LetterInBlockPosition(inLine: forbidden, line: highestLine.offset)
    }

    func removeLetter(at position: LetterInBlockPositionProtocol) -> Block<WordChild> {
        var newLines: [Line<WordChild>] = []
        for (index, line) in lines.enumerated() {
            if position.lineIndex == index {
                let updatedLine = line.removeLetter(at: position)
                newLines.append(updatedLine)
            } else {
                newLines.append(line)
            }
        }
        return Block(lines: newLines, frame: frame, column: column, typography: typography)
    }
}
