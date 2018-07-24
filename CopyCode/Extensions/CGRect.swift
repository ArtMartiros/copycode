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
    var ratio: CGFloat { return height/width  }
    
    func yPositionAs(part: Int, of number: Int) -> CGFloat {
        let innerHeight = height / CGFloat(number) * CGFloat(part)
        let positionY = maxY - innerHeight
        return positionY
    }
    
    func xPositionAs(part: Int, of number: Int) -> CGFloat {
        let innerWidth = width / CGFloat(number) * CGFloat(part)
        let positionX = minX + innerWidth
        return positionX
    }
    
    func yPositionAs(y: CGFloat) -> CGFloat {
        let innerHeight = height * y
        let positionY = maxY - innerHeight
        return positionY
    }
    
    func xPositionAs(x: CGFloat) -> CGFloat {
        let innerWidth = width * x
        let positionX = minX + innerWidth
        return positionX
    }
}
