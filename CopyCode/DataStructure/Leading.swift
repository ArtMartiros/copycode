//
//  LineData.swift
//  CopyCode
//
//  Created by Артем on 13/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation
///Структура состоит из высоты линии, междустрочный интервал и стартовой позиции
struct Leading: Codable {
    let fontSize: CGFloat
    let lineSpacing: CGFloat
    let startPointTop: CGFloat

    init(fontSize: CGFloat, lineSpacing: CGFloat, startPointTop: CGFloat) {
        self.fontSize = fontSize
        self.lineSpacing = lineSpacing
        self.startPointTop = startPointTop
    }
}

extension Leading {
    ///sum of **fontSize** and **lineSpacing**
    var leading: CGFloat {
        return fontSize + lineSpacing
    }

    typealias Rate = (errorRate: CGFloat, preciseRate: CGFloat)

    func checkIsFrameInsideLinePosition(frame: CGRect) -> SimpleSuccess<Rate> {
        let point = findNearestPointTop(to: frame)
        let errorPercent: CGFloat = 10
        let lowerPoint = point - fontSize
        let topDiffOrError = abs(frame.topY - point)
        let botDiffOrError = abs(frame.bottomY - lowerPoint)
        let checker = Checker()
        if point >= frame.topY {
            if lowerPoint <= frame.bottomY {
                return .success((0, topDiffOrError + botDiffOrError))
            } else {
                guard checker.isSame(lowerPoint, with: frame.bottomY, relativelyTo: fontSize, accuracy: errorPercent)
                    else { return .failure }

                return .success((botDiffOrError, topDiffOrError))
            }
        } else {
            guard checker.isSame(point, with: frame.topY, relativelyTo: fontSize, accuracy: errorPercent)
                else { return .failure }

            if lowerPoint <= frame.bottomY {
                return .success((topDiffOrError, botDiffOrError))
            } else {
                guard checker.isSame(lowerPoint, with: frame.bottomY, relativelyTo: fontSize, accuracy: errorPercent)
                    else { return .failure }
                return .success((botDiffOrError + topDiffOrError, 0))
            }
        }
    }

    ///делает фрейм возможного размера учитывая лидинг, поэтому может быть обрезан
    func missingLinesFrame(in frame: CGRect) -> [CGRect] {
        guard frame.height > leading else { return [] }
        let startPoint = findStartPoint(inside: frame)
        let difference = frame.topY - startPoint
        let height = startPoint - frame.bottomY
        let lineCount = ((height - fontSize - difference) / leading).rounded()

        var currentFrame = frame
        var frames: [CGRect] = []

        for i in 0...Int(lineCount) {
            let afterDistance = i == 0 ? difference : lineSpacing
            let divided = currentFrame.divided(atDistance: fontSize,
                                        afterDistance: afterDistance, from: .maxYEdge)
            frames.append(divided.slice)
            currentFrame = divided.remainder
        }
        return frames
    }

    ///делает фрем сандартного размера с помощью лидинга
    func missingLinesWithStandartFrame(in frame: CGRect) -> [CGRect] {
        let startPoint = findStartPoint(inside: frame)
        let difference = frame.topY - startPoint
        let height = startPoint - frame.bottomY
        let lineCount = ((height - fontSize - difference) / leading).rounded()

        var currentFrame = frame
        var frames: [CGRect] = []

        for i in 0...Int(lineCount) {
            let afterDistance = i == 0 ? difference : lineSpacing
            let divided = currentFrame.divided(atDistance: fontSize,
                                               afterDistance: afterDistance, from: .maxYEdge)

            let temporaryFrame = divided.slice
            //проблема с течм что крайние обрезаются
            if temporaryFrame.height < fontSize {
                let diff = fontSize - temporaryFrame.height
                let newFrame = temporaryFrame.update(byValue: diff, in: .offset(i == 0 ? .top : .bottom))
                frames.append(newFrame)
            } else {
                frames.append(temporaryFrame)
            }

            currentFrame = divided.remainder

        }
        return frames
    }

    private func findNearestPointTop(to frame: CGRect) -> CGFloat {
        let distance = abs(frame.topY - startPointTop)
        let value = (distance / leading).rounded()
        if frame.topY < startPointTop {
            let point = startPointTop - value * leading
            return point
        } else {
            let point = startPointTop + value * leading
            return point
        }
    }

    ///topY
    func findStartPoint(inside frame: CGRect) -> CGFloat {
        let point = findNearestPointTop(to: frame)
        let checker = Checker()

        var startPoint = point
        if point > frame.topY, !checker.isSame(point, with: frame.topY, relativelyTo: fontSize, accuracy: 40) {
            startPoint -= leading
        }
        return startPoint
    }

    func createVirtualFrame(from frame: CGRect) -> CGRect {
        let startPoint = findStartPoint(inside: frame) - fontSize
        let frame = CGRect(x: frame.origin.x, y: startPoint, width: frame.width, height: fontSize)
        return frame
    }

}

enum Position {
    case top
    case mid
    case bottom
}

protocol TypeChecker {
    func maxHeightRatio(with frame: CGRect) -> CGFloat
    func lowWithTail(with frame: CGRect) -> Bool
    func quotesOrColumn(with frame: CGRect) -> Bool
    func exist(in position: Position, with frame: CGRect) -> Bool
}
