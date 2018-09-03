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
    
    var ratio: CGFloat { return pixelSize.width / size.width }
    private (set) var size = CGSize(width: 1, height: 1)
    private (set) var pixelSize = CGSize(width: 1, height: 1)
    func setSize(size: NSSize, pixelSize: NSSize) {
        print("PixelConverter size: \(size), pixelSize: \(pixelSize)")
        self.size = size
        self.pixelSize = pixelSize
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
