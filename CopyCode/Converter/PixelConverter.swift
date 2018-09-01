//
//  PixelConverter.swift
//  CopyCode
//
//  Created by Артем on 23/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

class PixelConverter {
    
    static var shared = PixelConverter()
    
    private init () { }
    
    private (set) var ratio: CGFloat = 1
    
    func setRatio(size: NSSize, pixelSize: NSSize) {
        print("PixelConverter size: \(size), pixelSize: \(pixelSize)")
        ratio = pixelSize.width / size.width
    }
    
    func toPixel(from frame: CGRect) -> CGRect {
        return CGRect(x: frame.origin.x * ratio, y: frame.origin.y * ratio,
                      width: frame.width * ratio, height: frame.height * ratio)
    }
    
    func toPixel(from value: CGFloat) -> CGFloat {
        return value * ratio
    }
    
    func toFrame(from value: CGFloat) -> CGFloat {
        return value / ratio
    }
    
    func toPixel(from point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x * ratio, y: point.y * ratio)
    }
    
    func toFrame(from pixelFrame: CGRect) -> CGRect {
        return CGRect(x: pixelFrame.origin.x / ratio, y: pixelFrame.origin.y / ratio,
                      width: pixelFrame.width / ratio, height: pixelFrame.height / ratio)
    }
    
    func toFrame(from point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x * ratio, y: point.y * ratio)
    }
}
