//
//  LetterColorChecker.swift
//  CopyCode
//
//  Created by Артем on 28/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

// swiftlint:disable identifier_name
/// Отвечает за то, что проверяет относится ли конкретный пиксель к букве или к фону
final class LetterExistenceChecker {

    private let bitmap: NSBitmapImageRep
    private let pixelExistence: LetterPixelExistenceProtocol

    init(_ bitmap: NSBitmapImageRep, pixelChecker: LetterPixelExistenceProtocol) {
        self.bitmap = bitmap
        self.pixelExistence = pixelChecker
    }

    private static let defaultValue: CGFloat = 100

    func exist(at point: CGPoint, accuracyPercenRate: CGFloat = defaultValue) -> Bool {
        let colorPicker = ColorPicker(bitmap)
        let color = colorPicker.pickWhite(at: point)
        let exist = pixelExistence.exist(currentValue: color, accuracyPercenRate: accuracyPercenRate)
        print(exist ? "✅\n" : "⭕️\n")
        return exist
    }

    func exist(x: CGFloat, y: CGFloat, in frame: CGRect, percent: CGFloat = defaultValue) -> Bool {
        let point = CGPoint(x: frame.xAs(rate: x), y: frame.yAs(rate: y))
        return exist(at: point, accuracyPercenRate: percent)
    }

    func exist(xRange: ClosedRange<Int>, of unit: Int, y: CGFloat, with frame: CGRect,
               op: LogicalOperator, percent: CGFloat = defaultValue) -> Bool {
        return exist(xArray: Array(xRange), of: unit, y: y, with: frame, op: op, percent: percent)
    }

    func exist(xArray: [Int], of unit: Int, y: CGFloat, with frame: CGRect, op: LogicalOperator,
               percent: CGFloat = defaultValue) -> Bool {
        let points: [CGPoint] = xArray.map { CGPoint(x: frame.xAs(part: $0, of: unit), y: frame.yAs(rate: y)) }
        return exist(points, op: op, with: frame, percent: percent)
    }

    func exist(yRange: ClosedRange<Int>, of unit: Int, x: CGFloat, with frame: CGRect,
               op: LogicalOperator, percent: CGFloat = defaultValue) -> Bool {
        return exist(yArray: Array(yRange), of: unit, x: x, with: frame, op: op, percent: percent)
    }

    func exist(yArray: [Int], of unit: Int, x: CGFloat, with frame: CGRect,
               op: LogicalOperator, percent: CGFloat = defaultValue) -> Bool {
        let points: [CGPoint] = yArray.map { CGPoint(x: frame.xAs(rate: x), y: frame.yAs(part: $0, of: unit)) }
        return exist(points, op: op, with: frame, percent: percent)
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

    func sameWithMirrorX(frame: CGRect, part: Int, of number: Int, withY y: CGFloat) -> Bool {
        let x = frame.xAs(part: part, of: number)
        let mirrorX = frame.xAs(part: number - part, of: number)
        let point = CGPoint(x: x, y: y)
        let mirrorPoint = CGPoint(x: mirrorX, y: y)
        return exist(at: point) == exist(at: mirrorPoint)
    }

    private func exist(_ points: [CGPoint], op: LogicalOperator, with frame: CGRect,
                       percent: CGFloat = defaultValue) -> Bool {
        switch op {
        case .or:  return points.first { exist(at: $0, accuracyPercenRate: percent) } != nil
        case .and: return points.first { !exist(at: $0, accuracyPercenRate: percent) } == nil
        case .allFalse: return points.first { exist(at: $0, accuracyPercenRate: percent) } == nil
        case .someFalse: return points.first { !exist(at: $0, accuracyPercenRate: percent) } != nil

        }
    }
}

///продвинутые функции
extension LetterExistenceChecker {

    func exist(hLine: ClosedRange<Int>, yRange: ClosedRange<Int>, with frame: CGRect,
               op: LogicalOperator, mainOp: LogicalOperator, percent: CGFloat = defaultValue) -> Bool {

        let arrayOfPoints = yRange.map { y in
            hLine.map { CGPoint(x: frame.xAs(part: $0, of: 10), y: frame.yAs(part: y, of: 10)) }
        }

        return exist(arrayOfPoints, lineOp: op, mainOp: mainOp, with: frame, percent: percent)
    }

    func exist(vLine: ClosedRange<Int>, xRange: ClosedRange<Int>, with frame: CGRect,
               op: LogicalOperator, mainOp: LogicalOperator, percent: CGFloat = defaultValue) -> Bool {

       let arrayOfPoints = xRange.map { x in
            vLine.map { CGPoint(x: frame.xAs(part: x, of: 10), y: frame.yAs(part: $0, of: 10)) }
        }

       return exist(arrayOfPoints, lineOp: op, mainOp: mainOp, with: frame, percent: percent)
    }

    private func exist(_ arrayOfPoints: [[CGPoint]], lineOp: LogicalOperator, mainOp: LogicalOperator,
                       with frame: CGRect, percent: CGFloat = defaultValue) -> Bool {
        switch mainOp {
        case .or: return arrayOfPoints.first { exist($0, op: lineOp, with: frame, percent: percent) } != nil
        case .and: return arrayOfPoints.first { !exist($0, op: lineOp, with: frame, percent: percent) } == nil
        case .allFalse: return arrayOfPoints.first { exist($0, op: lineOp, with: frame, percent: percent) } == nil
        case .someFalse: return arrayOfPoints.first { !exist($0, op: lineOp, with: frame, percent: percent) } != nil
        }
    }
}
