//
//  NSColor.swift
//  CopyCode
//
//  Created by Артем on 18/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

extension NSColor {
    ///white == 1, black == 0
    var grayScale: CGFloat {
        let grayScaleColor = usingColorSpace(NSColorSpace.deviceGray)
        var grayscale: CGFloat = 0
        var alpha: CGFloat = 0
        grayScaleColor?.getWhite(&grayscale, alpha: &alpha)
        return grayscale
    }
}

extension NSColor {
    static var textViewStrokeColor: NSColor {
        return NSColor.blue
        //NSColor(deviceRed: 0, green: 122, blue: 255, alpha: 1)
    }
    
    static var textViewBackgroundColor: NSColor {
        return Settings.showText ? NSColor.white : .clear
    }
    
    static var textViewFillColor: NSColor {
        return NSColor.clear
    }
    
    static var textColor: NSColor {
        return Settings.showText ? .black : .clear
    }
}
