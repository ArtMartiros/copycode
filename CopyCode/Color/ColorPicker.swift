//
//  ColorPicker.swift
//  CopyCode
//
//  Created by Артем on 28/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

struct ColorPicker {
    private let bitmap: NSBitmapImageRep
    init(_ bitmap: NSBitmapImageRep) {
        self.bitmap = bitmap
    }

    func pickWhite(at point: CGPoint) -> CGFloat {
        // swiftlint:disable identifier_name
        let (x, y) = bitmap.convertToPixelCoordinate(point: point)
        let white = bitmap.colorAt(x: x, y: y)?.grayScale.rounded(toPlaces: 4) ?? 0
        print("Point: \(point)")
        print("x: \(x), y: \(y)")
        print("White: \(white)")
        return white
    }
}

protocol BackgroundWhiteColorProtocol {
    /// Нужен для того, чтобы определить какого цвета background
    /// Необходим, чтобы знать от какого цвета отталкиваться при поиске цвета буквы
    func findBackgroundColor<T: Rectangle> (_ wordRectangle: Word<T>) -> CGFloat
}

protocol LetterWhiteColorProtocol {
    /// Цвета букв могут быть разные, поэтому нужно знать какой цвет у фона и какой у буквы
    /// находит самый контрастный цвет относительно фона и считает его цветом буквы
    func findedLetterColor(_ frame: CGRect, with backgroundColor: CGFloat) -> CGFloat
}

struct UniversalWhiteColorFinder: BackgroundWhiteColorProtocol, LetterWhiteColorProtocol {
    private let picker: ColorPicker
    init(picker: ColorPicker) {
        self.picker = picker
    }

    ///если есть гапы, то ищем значение фона внутри них
    ///в противном слуучае в левом верзнем углу
    func findBackgroundColor<T: Rectangle> (_ word: Word<T>) -> CGFloat {
        let points = getPoints(from: word)
        if points.isEmpty {
            let frame = word.pixelFrame
            let newPoint = CGPoint(x: frame.xAs(rate: 0) - 2, y: frame.yAs(rate: 0) + 2)
            return picker.pickWhite(at: newPoint)
        } else {
            let whiteColors = points.map { picker.pickWhite(at: $0) }
            let sortedWhites = whiteColors.sorted { $0 < $1 }
            let zeroColors = whiteColors.map { abs(0 - $0) }.reduce(0, +)
            let oneColors = whiteColors.map { abs(1 - $0) }.reduce(0, +)
            if zeroColors < oneColors {
                return sortedWhites.first!
            } else {
                return sortedWhites.last!
            }
        }
    }

    private func getPoints<T: Rectangle>(from word: Word<T>) -> [CGPoint] {
        let requiredNumber = 3
        let gaps = word.pixelGaps.filter { $0.frame.width > 1 }.sorted { $0.frame.width > $1.frame.width }
        let prefix = gaps.count < requiredNumber ? gaps.count : requiredNumber
        let filteredGaps = gaps[0..<prefix]
        let newPoints = filteredGaps.map { CGPoint(x: $0.frame.xAs(rate: 0.5), y: $0.frame.yAs(rate: 0.5)) }
        return newPoints
    }

    private let defaultLetterColorDifference: CGFloat = 0.6

    func findedLetterColor(_ frame: CGRect, with backgroundColor: CGFloat) -> CGFloat {
        // swiftlint:disable identifier_name
        let y = frame.yAs(rate: 0.1)
        let xPoints = Array(0...7).map { CGPoint(x: frame.xAs(part: $0, of: 7), y: y) }
        let colors = xPoints.map { picker.pickWhite(at: $0) }
        let letterColor = colors.sorted { abs(backgroundColor - $0) > abs(backgroundColor - $1) }[0]
        if abs(letterColor - backgroundColor) < 0.15 {
            return abs(backgroundColor - defaultLetterColorDifference)
        }
        return letterColor
    }
}
