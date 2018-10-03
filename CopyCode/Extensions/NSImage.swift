//
//  NSImage.swift
//  CopyCode
//
//  Created by Артем on 18/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation
import AppKit

extension NSImage {
    var ciimage: CIImage? {
        guard let tiffData = self.tiffRepresentation,
            let ciiImage = CIImage(data: tiffData) else { return nil }
        return ciiImage
    }
    
    var bitmap: NSBitmapImageRep {
        self.lockFocus()
        let bitmap = NSBitmapImageRep(data: self.tiffRepresentation!)!
        self.unlockFocus()
        return bitmap
    }
    
    var adjustColors: NSImage {
        let newImage = NSImage(size: size)
        let currentFilter = CIFilter(name: "CIColorControls")!
        currentFilter.setValue(self.ciimage!, forKey: kCIInputImageKey)
        currentFilter.setValue(0, forKey: kCIInputSaturationKey)
        currentFilter.setValue(1.45, forKey: kCIInputContrastKey)
        newImage.lockFocus()
        //Нужна хуйня чтоб конвертация пикселей проходила норм, иначе при конвертации только часть изображения остается
        let trans = NSAffineTransform()
        trans.set()
        //разрешение меняется, поэтому надо использовать разрешение изображения на выходе
        let outputImageFrame = currentFilter.outputImage?.extent
        currentFilter.outputImage!.draw(at: .zero, from: outputImageFrame!, operation: .copy, fraction: 1)
        newImage.unlockFocus()
        return newImage
    }
    
    func resize(targetSize: CGSize) -> NSImage {
        let targetRect = CGRect(origin: .zero, size: targetSize)
        let imageRect = CGRect(origin: .zero, size: size)
        let newImage = NSImage(size: targetSize)
        newImage.lockFocus()
        draw(in: targetRect, from: imageRect, operation: .sourceOver, fraction: 1)
        newImage.unlockFocus()
        return newImage
    }
    
    var grayscale: NSImage {
        let newImage = NSImage(size: size)
        let currentFilter = CIFilter(name: "CIPhotoEffectNoir")!
        currentFilter.setValue(self.ciimage!, forKey: kCIInputImageKey)
        newImage.lockFocus()
        //Нужна хуйня чтоб конвертация пикселей проходила норм, иначе при конвертации только часть изображения остается
        let trans = NSAffineTransform()
        trans.set()
        //разрешение меняется, поэтому надо использовать разрешение изображения на выходе
        let outputImageFrame = currentFilter.outputImage?.extent
        currentFilter.outputImage!.draw(at: .zero, from: outputImageFrame!, operation: .copy, fraction: 1)
        newImage.unlockFocus()
        return newImage
    }
    
    func crop(to targetFrame: CGRect) -> NSImage {
        
        let newFrame = CGRect(origin: .zero, size: targetFrame.size)
        let newImage = NSImage(size: targetFrame.size)
        newImage.lockFocus()
        draw(in: newFrame, from: targetFrame, operation: .sourceOver, fraction: 1)
        newImage.unlockFocus()
        
        return newImage
    }
    
    var toCGImage: CGImage {
        return self.cgImage(forProposedRect: nil, context: nil, hints: nil)!
    }
    
    private func getPixelColor(at point: CGPoint) -> NSColor {
        lockFocus()
        let bitMap = NSBitmapImageRep(data: tiffRepresentation!)
        let color = bitMap?.colorAt(x: Int(point.x), y: Int(point.y))
        unlockFocus()
        return color!
    }
    
    
//    func insertInsets(insetWidthDimension: CGFloat, insetHeightDimension: CGFloat)
//        -> NSImage {
//
//            let color = [topLeft.color, topRight.color,
//                         bottomLeft.color, bottomRight.color].averageColor
//            let insets = NSEdgeInsets(top: insetHeightDimension,
//                                      left: insetWidthDimension,
//                                      bottom: insetHeightDimension,
//                                      right: insetWidthDimension)
//            let newSize = NSSize(width: size.width + insets.left + insets.right,
//                                 height: size.height + insets.top + insets.bottom)
//
//            let initialPoint = CGPoint(x: insets.left, y: insets.bottom)
//            let targetFrame = NSRect(origin: .zero, size: size)
//            let newImage = NSImage(size: newSize)
//            newImage.lockFocus()
//            draw(at: initialPoint, from: targetFrame, operation: .sourceOver, fraction: 1)
//            newImage.unlockFocus()
//
//            return newImage.tint(color: color)
//    }
    
    func tint(color: NSColor) -> NSImage {
        guard !self.isTemplate else { return self }
        
        let image = self.copy() as! NSImage
        image.lockFocus()
        
        color.set()
        
        let imageRect = NSRect(origin: NSZeroPoint, size: image.size)
        imageRect.fill(using: .destinationAtop)
        
        image.unlockFocus()
        image.isTemplate = false
        
        return image
    }
    
    var tL: CGPoint {
        return CGPoint(x: 0, y: size.height - 1)
    }
    
    var tR: CGPoint {
        return CGPoint(x: size.width - 1, y: size.height - 1)
    }
    var bL: CGPoint {
        return .zero
    }
    var bR: CGPoint {
        return CGPoint(x: size.width - 1, y: 0)
    }
    
//    var topLeft: Corner {
//        let point = CGPoint(x: 0, y: size.height - 1)
//        return Corner(point: point, color: getPixelColor(at: point))
//    }
//
//    var topRight: Corner {
//        let point = CGPoint(x: size.width - 1, y: size.height - 1)
//        return Corner(point: point, color: getPixelColor(at: point))
//    }
//
//    var bottomLeft: Corner {
//        return Corner(point: .zero, color: getPixelColor(at: .zero))
//    }
//
//    var bottomRight: Corner {
//        let point = CGPoint(x: size.width - 1, y: 0)
//        return Corner(point: point, color: getPixelColor(at: point))
//    }
    
    struct Corner {
        let point: CGPoint
        let color: NSColor
    }
    

    var preparedImage: NSImage {
        lockFocus()
        let bitMap = NSBitmapImageRep(data: tiffRepresentation!)
        let testSize = bitMap!.size
        draw(in: CGRect(origin: .zero, size: testSize))
        unlockFocus()
        return adjustColors.grayscale
    }

}


/*
 destinationAtop новый слой закрашивает пустоту
 sourceAtop закрашивает старый слой, кроме пустоты
 sourceOver закрашивает весь старый слой
 */
