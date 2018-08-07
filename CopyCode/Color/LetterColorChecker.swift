//
//  LetterColorChecker.swift
//  CopyCode
//
//  Created by Артем on 28/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

/// Отвечает за то, что проверяет относится ли конкретный пиксель к букве или к пустоте
final class LetterColorChecker {
    /// Cases: or, and, allFalse
    enum LogicalOperator {
        case or
        case and
        case allFalse
        case someFalse
    }
    
    private let bitmap: NSBitmapImageRep
    private let pixelChecker: LetterPixelChecker
    private let letterDefaultWhiteColor: CGFloat
    init(_ bitmap: NSBitmapImageRep, pixelChecker: LetterPixelChecker, letterDefaultWhite: CGFloat) {
        self.bitmap = bitmap
        self.pixelChecker = pixelChecker
        self.letterDefaultWhiteColor = letterDefaultWhite
    }
    
    func exist(at point: CGPoint, in frame: CGRect) -> Bool {
        let colorPicker = ColorPicker(bitmap)
        let color = colorPicker.pickWhite(at: point)
        let exist = pixelChecker.exist(currentValue: color, withLetterDefaultWhite: letterDefaultWhiteColor)
        print(exist ? "✅\n" : "⭕️\n")
        return exist
    }
    
    func exist(x: CGFloat, y: CGFloat, in frame: CGRect) -> Bool {
        let point = CGPoint(x: frame.xAs(rate: x), y: frame.yAs(rate: y))
        return exist(at: point, in: frame)
    }
    
    func exist(xRange: ClosedRange<Int>, of unit: Int, y: CGFloat, with frame: CGRect, op: LogicalOperator) -> Bool {
        return exist(xArray:Array(xRange), of: unit, y: y, with: frame, op: op)
    }
    
    func exist(xArray: [Int], of unit: Int, y: CGFloat, with frame: CGRect, op: LogicalOperator) -> Bool {
        let points: [CGPoint] = xArray.map { CGPoint(x: frame.xAs(part: $0, of: unit), y: frame.yAs(rate: y)) }
        return exist(points, op: op, with: frame)
    }
    
    func exist(yRange: ClosedRange<Int>, of unit: Int, x: CGFloat, with frame: CGRect, op: LogicalOperator) -> Bool {
        return exist(yArray: Array(yRange), of: unit, x: x, with: frame, op: op)
    }
    
    func exist(yArray: [Int], of unit: Int, x: CGFloat, with frame: CGRect, op: LogicalOperator) -> Bool {
        let points: [CGPoint] = yArray.map { CGPoint(x: frame.xAs(rate: x), y: frame.yAs(part: $0, of: unit)) }
        return exist(points, op: op, with: frame)
    }
    
    func sameMirrored(xArray: [Int], of unit: Int, y: CGFloat, with frame: CGRect, op: LogicalOperator) -> Bool {
        let pointPairs: [(CGPoint, CGPoint)] = xArray.map {
            let y = frame.yAs(rate: y)
            let x = frame.xAs(part: $0, of: unit)
            let mirrorX = frame.xAs(part: unit - $0, of: unit)
            return (CGPoint(x: x, y: y), CGPoint(x: mirrorX, y: y))
        }
  
        switch op {
        case .or: return pointPairs.first { exist(at: $0.0, in: frame) == exist(at: $0.1, in: frame) } != nil
        case .and: return pointPairs.first { exist(at: $0.0, in: frame) != exist(at: $0.1, in: frame) } == nil
        case .allFalse: return pointPairs.first { exist(at: $0.0, in: frame) == exist(at: $0.1, in: frame) } == nil
        case .someFalse: return pointPairs.first { !exist(at: $0.0, in: frame) == !exist(at: $0.1, in: frame) } != nil
        }
    }
    
    func sameWithMirrorX(frame: CGRect, part: Int, of number: Int, withY y: CGFloat)  -> Bool{
        let x = frame.xAs(part: part, of: number)
        let mirrorX = frame.xAs(part: number - part, of: number)
        let point = CGPoint(x: x, y: y)
        let mirrorPoint = CGPoint(x: mirrorX, y: y)
        return exist(at: point, in: frame) == exist(at: mirrorPoint, in: frame)
    }
    
    private func exist(_ points: [CGPoint],
                       op: LogicalOperator,
                       with frame: CGRect) -> Bool {
        switch op {
        case .or:  return points.first { exist(at: $0, in: frame) } != nil
        case .and: return points.first { !exist(at: $0, in: frame) } == nil
        case .allFalse: return points.first { exist(at: $0, in: frame) } == nil
        case .someFalse: return points.first { !exist(at: $0, in: frame) } != nil
            
        }
    }
}
