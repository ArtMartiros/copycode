//
//  NSBitmapImageRep.swift
//  CopyCode
//
//  Created by Артем on 18/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

extension NSBitmapImageRep {
    var pixelSize: CGSize {
        return CGSize(width: pixelsWide, height: pixelsHigh)
    }

    func convertToPixelCoordinate(point: CGPoint) -> (x: Int, y: Int) {
        let newPoint = point.rounded
        let x = Int(newPoint.x)
        let y = pixelsHigh - Int(newPoint.y)
        return (x, y)
    }
}
