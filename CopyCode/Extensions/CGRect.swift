//
//  CGRect.swift
//  CopyCode
//
//  Created by Артем on 18/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

extension CGRect {
    var tL: CGPoint { return CGPoint(x: minX, y: topY) }
    var tR: CGPoint { return CGPoint(x: maxX, y: topY) }
    var tC: CGPoint { return CGPoint(x: midX, y: topY) }
    var bL: CGPoint { return CGPoint(x: minX, y: bottomY) }
    var bR: CGPoint { return CGPoint(x: maxX, y: bottomY) }
    var bC: CGPoint { return CGPoint(x: midX, y: bottomY) }
    var lC: CGPoint { return CGPoint(x: minX, y: midY) }
    var rC: CGPoint { return CGPoint(x: maxX, y: midY) }
    var c:  CGPoint { return CGPoint(x: midX, y: midY) }
    ///minY
    var bottomY: CGFloat { return minY }
    var topY: CGFloat { return maxY }
    var leftX: CGFloat { return minX }
    var rightX: CGFloat { return maxX }
    ///height/width
    var ratio: CGFloat { return height/width  }
    
    /// Принимает значение от 0 до 1 и на основе него ищет точку у frame
    func yAs(part: Int, of number: Int) -> CGFloat {
        let innerHeight = height / CGFloat(number) * CGFloat(part)
        let positionY = maxY - innerHeight
        return positionY
    }
    /// Принимает значение от 0 до 1 и на основе него ищет точку у frame
    func xAs(part: Int, of number: Int) -> CGFloat {
        let innerWidth = width / CGFloat(number) * CGFloat(part)
        let positionX = minX + innerWidth
        return positionX
    }
    /// Принимает значение от 0 до 1 и на основе него ищет точку у frame
    func yAs(rate: CGFloat) -> CGFloat {
        let innerHeight = height * rate
        let positionY = maxY - innerHeight
        return positionY
    }
    /// Принимает значение от 0 до 1 и на основе него ищет точку у frame
    func xAs(rate: CGFloat) -> CGFloat {
        let innerWidth = width * rate
        let positionX = minX + innerWidth
        return positionX
    }
}

extension CGRect {
    ///  0 == same, 1 == size of frame
    func expand(addingOfRatio value: CGFloat, in dimension: Direction) -> CGRect {
        switch dimension {
            
        case .left:
            let newX = xAs(rate: -value)
            let addedWidth = abs(leftX - newX)
            return CGRect(x: newX, y: origin.y, width: width + addedWidth, height: height)
            
        case .right:
            let newX = xAs(rate: 1 + value)
            let addedWidth = abs(leftX - newX)
            return CGRect(x: newX, y: origin.y, width: width + addedWidth, height: height)
            
        default: return .zero
        }
    }
    
    func update(plus value: UInt, in edgeDirection: EdgeDirection) -> CGRect {
        let direction: Direction
        let newValue: CGFloat
        switch edgeDirection {
        case .inset(let d):
            newValue = -CGFloat(value)
            direction = d
        case .offset(let d):
            newValue = CGFloat(value)
            direction = d
        }

        switch direction {
        case .bottom:
            let newMinY = bottomY - newValue
            return CGRect(x: origin.x, y: newMinY, width: width, height: height + newValue)
        case .top:
            return CGRect(x: origin.x, y: origin.y, width: width, height: height + newValue)
        case .left:
            let newMinX = leftX - newValue
            return CGRect(x: newMinX, y: origin.y, width: width + newValue, height: height)
        case .right:
            return CGRect(x: origin.x, y: origin.y, width: width + newValue, height: height)
        }
    }
    
    enum EdgeDirection {
        case inset(Direction)
        case offset(Direction)
    }
}

extension CGRect {
    ///Разделяет frame на маленькие
    func chunkToSmallRects(byWidth width: CGFloat) -> [CGRect] {
        var rects: [CGRect] = []
        var currentRect = self
        while true {
            let splitted = currentRect.divided(atDistance: width, from: .minXEdge)
            currentRect = splitted.remainder
            rects.append(splitted.slice)
            let isCompleteToDevide = currentRect.width / width < 1.5
            if isCompleteToDevide {
                rects.append(currentRect)
                break
            }
        }
        return rects
    }
}
