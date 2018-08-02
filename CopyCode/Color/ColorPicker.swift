//
//  ColorPicker.swift
//  CopyCode
//
//  Created by Артем on 28/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

final class ColorPicker {
    private let bitmap: NSBitmapImageRep
    init(_ bitmap: NSBitmapImageRep) {
        self.bitmap = bitmap
    }
    
    func pickWhite(at point: CGPoint) -> CGFloat {
        let (x, y) = bitmap.convertToPixelCoordinate(point: point)
        let white = bitmap.colorAt(x: x, y: y)?.grayScale.rounded(toPlaces: 4) ?? 0
        print("Point: \(point)")
        print("x: \(x), y: \(y)")
        print("White: \(white)")
        return white
    }
}

protocol ColorFinderProtocol {
    var findedColor: CGFloat { get }
}
protocol BackgroundWhiteColorProtocol {
    /// Нужен для того, чтобы определить какого цвета background
    /// Необходим, чтобы знать от какого цвета отталкиваться при поиске цвета буквы
    func findedBackgroundColor (_ wordRectangle: WordRectangle_) -> CGFloat
}

protocol LetterWhiteColorProtocol {
    /// Цвета букв могут быть разные, поэтому нужно знать какой цвет у фона и какой у буквы
    /// находит самый контрастный цвет относительно фона и считает его цветом буквы
    func findedLetterColor(_ frame: CGRect, with backgroundColor: CGFloat) -> CGFloat
}

final class UniversalWhiteColorFinder: BackgroundWhiteColorProtocol, LetterWhiteColorProtocol {
    private let picker: ColorPicker
    
    init(picker: ColorPicker) {
        self.picker = picker
    }
    
    func findedBackgroundColor (_ wordRectangle: WordRectangle_) -> CGFloat {
        let frame = wordRectangle.pixelFrame
        let point = CGPoint(x: frame.xAs(rate: 0), y: frame.yAs(rate: 0))
        let newPoint = CGPoint(x: point.x - 1, y: point.y + 1)
        return picker.pickWhite(at: newPoint)
    }
    
    func findedLetterColor(_ frame: CGRect, with backgroundColor: CGFloat) -> CGFloat {
        let y = frame.yAs(rate: 0.5)
        let y1 = frame.yAs(rate: 0.1)
        let xPoints = Array(0...7).map { CGPoint(x: frame.xAs(part: $0, of: 7), y: y1) }
//        var xPoints = [1,2,19,18].map { CGPoint(x: frame.xAs(part: $0, of: 20), y: y) }
//        let xPoints2 = [1,2,19,18].map { CGPoint(x: frame.xAs(part: $0, of: 20), y: y1) }
//        xPoints.append(contentsOf: xPoints)
        let colors = xPoints.map { picker.pickWhite(at: $0) }
        let letterColor = colors.sorted { abs(backgroundColor - $0) > abs(backgroundColor - $1) }[0]
        return letterColor
    }
}
