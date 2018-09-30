//
//  NSColor.swift
//  CopyCode
//
//  Created by Артем on 18/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

extension NSColor {
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
        return NSColor.red
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
