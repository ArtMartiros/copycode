//
//  LetterBoundsRestorer.swift
//  CopyCode
//
//  Created by Артем on 27/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

///Восстанавливает frame буквы в заданном frame
protocol PixelBoundsRestorable {
    func restore(at dictionary: PixelFinderDictionary, in frame: CGRect) -> CGRect
}

///Восстанавливает frame буквы в заданном frame
class LetterBoundsRestorer: PixelBoundsRestorable {
    private let checker: LetterExistenceChecker
    
    private let kEvenArray: [CGFloat] = [0.2, 0.4, 0.6, 0.8]
    private let kUnevenarray: [CGFloat] = [0.1, 0.3, 0.5, 0.7, 0.9, ]
    
    init(checker: LetterExistenceChecker) {
        self.checker = checker
    }
    
    ///восстанавливает frame
    func restore(at dictionary: PixelFinderDictionary, in frame: CGRect) -> CGRect {
        var newDictionary = dictionary
        let leftRates = getRates(frame, horizontal: true)
        let topRates = getRates(frame, horizontal: false)
        newDictionary = updatedDictionary(with: leftRates, using: newDictionary, in: frame)
        newDictionary = updatedDictionary(with: leftRates.reversed(), using: newDictionary, in: frame)
        newDictionary = updatedDictionary(with: leftRates, using: newDictionary, in: frame)
        newDictionary = updatedDictionary(with: topRates.reversed(), using: newDictionary, in: frame)
        var newFrame = getFrame(from: newDictionary)
        newFrame = getEmergencyFrame(from: newFrame, letterFrame: frame)
        return newFrame
    }
    
    ///бывает такое что после той проферки у фрейма нулевая ллина либо высота и нужен более топорный способ расширить
    ///использется для точек и всякоц шняги
    private func getEmergencyFrame(from newFrame: CGRect, letterFrame: CGRect) -> CGRect {
        var left: CGFloat = 0
        var right: CGFloat = 0
        var top: CGFloat = 0
        var bottom: CGFloat = 0
        
        if newFrame.width == 0 {
            left = extend(from: newFrame.origin, with: letterFrame, in: .left).x
            right = extend(from: newFrame.origin, with: letterFrame, in: .right).x
        } else {
            left = newFrame.origin.x
            right = newFrame.origin.x + newFrame.size.width
        }
        
        if newFrame.height == 0 {
            top = extend(from: newFrame.origin, with: letterFrame, in: .top).y
            bottom = extend(from: newFrame.origin, with: letterFrame, in: .bottom).y
        } else {
            top = newFrame.origin.y + newFrame.size.height
            bottom = newFrame.origin.y
        }
        
        return getFrame(left: left, right: right, top: top, bottom: bottom)
    }
    /// генерирует структуру FrameRate из которой потом создаются [CGPoint]
    /// нужен для создания точек поиска в зависимости от условий слева направо или сверху вниз
    /// сконструирован так чтобы эффективней найти крайнюю точку
    private func getRates(_ frame: CGRect, horizontal: Bool) -> [FrameRate] {
        var rates: [FrameRate] = []
        for i in 1...9 {
            let array = i % 2 == 0 ? kEvenArray : kUnevenarray
            let value = CGFloat(i) / 10
            let currentRates: [FrameRate]
            if horizontal {
                currentRates = FrameRate.ratesFrom(xArray: [value], yArray: array, in: frame, edge: .minXEdge)
            } else {
                currentRates = FrameRate.ratesFrom(xArray: array, yArray: [value], in: frame, edge: .minXEdge)
            }
            rates.append(contentsOf: currentRates)
        }
        return rates
    }
    
    ///находит первую точку буквы с нужной стороны и записывает в словарь вместе со всеми предыдущими результатами поиска
    private func updatedDictionary(with rates: [FrameRate],
                                   using dictionary: PixelFinderDictionary, in frame: CGRect) -> PixelFinderDictionary {
        var newDictionary = dictionary
        for rate in rates {
            if newDictionary[rate] != nil { continue }
            let point = CGPoint(x: frame.xAs(rate: rate.x), y: frame.yAs(rate: rate.y))
            if checker.exist(at: point) {
                newDictionary[rate] = .value(point.rounded)
                break
            } else {
                newDictionary[rate] = .empty
            }
        }
        
        return newDictionary
    }
    
    private func getFrame(from dictionary: PixelFinderDictionary) -> CGRect {
        let filteredDictionary = filter(dictionary)
        let sortedFromLeft = filteredDictionary.sorted { $0.key.x < $1.key.x }
        let sortedFromTop = filteredDictionary.sorted { $0.key.y < $1.key.y }
        guard let left = pointFrom(sortedFromLeft.first?.value),
            let right = pointFrom(sortedFromLeft.last?.value),
            let top = pointFrom(sortedFromTop.first?.value),
            let bottom = pointFrom(sortedFromTop.last?.value) else { return .zero }
        return getFrame(left: left.x, right: right.x, top: top.y, bottom: bottom.y)
    }
    
    private func getFrame(left: CGFloat, right: CGFloat, top: CGFloat, bottom: CGFloat) -> CGRect {
        let width = right - left
        let height = top - bottom
        let newFrame = CGRect(x: left, y: bottom, width: width, height: height)
        return newFrame
    }
    
///расширяет границу в нужном направлении до тех пор пока есть буква
/// расширение идет до границ придуманного фрейма
    private func extend(from point: CGPoint, with frame: CGRect, in direction: Direction) -> CGPoint {
        switch direction {
        case .left:
            return extend(from: point) {
                let current = CGPoint(x: $0.x - 1, y: $0.y)
                return current.x > frame.leftX && checker.exist(at: current) ? .value(current) : .empty
            }
        case .right:
            return extend(from: point) {
                let current = CGPoint(x: $0.x + 1, y: $0.y)
                return current.x < frame.rightX && checker.exist(at: current) ? .value(current) : .empty
            }
        case .top:
            return extend(from: point) {
                let current = CGPoint(x: $0.x, y: $0.y + 1)
                return current.y < frame.topY && checker.exist(at: current) ? .value(current) : .empty
            }
        case .bottom:
            return extend(from: point) {
                let current = CGPoint(x: $0.x, y: $0.y - 1)
                return current.y > frame.bottomY && checker.exist(at: current) ? .value(current) : .empty
            }
        }
    }

    private func extend(from point: CGPoint, closure: (CGPoint) -> SimpleResult<CGPoint>) -> CGPoint {
        var newPoint = point
        while true {
            if case .value(let updatedPoint) = closure(newPoint) {
                newPoint = updatedPoint
            } else {
                break
            }
        }
        return newPoint
    }
    
    
    private func filter(_ dictionary: PixelFinderDictionary) -> PixelFinderDictionary {
        let filteredDictionary = dictionary.filter {
            switch $0.value  {
            case .empty: return false
            default: return true
            }
        }
        return filteredDictionary
    }
    
    private func pointFrom(_ value: SimpleResult<CGPoint>?) -> CGPoint? {
        guard let value = value else { return nil }
        switch value {
        case .empty: return nil
        case .value(let result): return result
        }
    }
}


