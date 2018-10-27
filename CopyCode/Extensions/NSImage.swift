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
    convenience init(_ name: String) {
        self.init(named: .init(name))!
    }

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
//        currentFilter.setValue(0, forKey: kCIInputSaturationKey)
        currentFilter.setValue(1.8, forKey: kCIInputContrastKey)
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
