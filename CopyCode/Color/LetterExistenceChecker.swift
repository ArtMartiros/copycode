//
//  LetterColorChecker.swift
//  CopyCode
//
//  Created by Артем on 28/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

/// Отвечает за то, что проверяет относится ли конкретный пиксель к букве или к фону
final class LetterExistenceChecker {

    private let bitmap: NSBitmapImageRep
    private let pixelExistence: LetterPixelExistenceProtocol
    
    init(_ bitmap: NSBitmapImageRep, pixelChecker: LetterPixelExistenceProtocol) {
        self.bitmap = bitmap
        self.pixelExistence = pixelChecker
    }
    
    func exist(at point: CGPoint) -> Bool {
        let colorPicker = ColorPicker(bitmap)
        let color = colorPicker.pickWhite(at: point)
        let exist = pixelExistence.exist(currentValue: color)
        print(exist ? "✅\n" : "⭕️\n")
        return exist
    }
    
    func exist(x: CGFloat, y: CGFloat, in frame: CGRect) -> Bool {
        let point = CGPoint(x: frame.xAs(rate: x), y: frame.yAs(rate: y))
        return exist(at: point)
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
        case .or: return pointPairs.first { exist(at: $0.0) == exist(at: $0.1) } != nil
        case .and: return pointPairs.first { exist(at: $0.0) != exist(at: $0.1) } == nil
        case .allFalse: return pointPairs.first { exist(at: $0.0) == exist(at: $0.1) } == nil
        case .someFalse: return pointPairs.first { !exist(at: $0.0) == !exist(at: $0.1) } != nil
        }
    }
    
    func sameWithMirrorX(frame: CGRect, part: Int, of number: Int, withY y: CGFloat)  -> Bool{
        let x = frame.xAs(part: part, of: number)
        let mirrorX = frame.xAs(part: number - part, of: number)
        let point = CGPoint(x: x, y: y)
        let mirrorPoint = CGPoint(x: mirrorX, y: y)
        return exist(at: point) == exist(at: mirrorPoint)
    }
    
    private func exist(_ points: [CGPoint],
                       op: LogicalOperator,
                       with frame: CGRect) -> Bool {
        switch op {
        case .or:  return points.first { exist(at: $0) } != nil
        case .and: return points.first { !exist(at: $0) } == nil
        case .allFalse: return points.first { exist(at: $0) } == nil
        case .someFalse: return points.first { !exist(at: $0) } != nil
            
        }
    }
}
