//
//  TextRecognizerManager.swift
//  CopyCode
//
//  Created by Артем on 25/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

final class TextRecognizerManager {
    typealias TextCompletion = (_ bitmap: NSBitmapImageRep, _ results: [Word<LetterRectangle>], _ error: Error?) -> Void

    private let textDetection: TextDetection
    private let rectangleConverter: RectangleConverter
    private let typeIdentifier: TypeConverter
    
    init() {
        self.textDetection = TextDetection()
        self.rectangleConverter = RectangleConverter()
        self.typeIdentifier = TypeConverter()
    }
    
    func performRequest(image: NSImage, completion: @escaping TextCompletion) {
        textDetection.performRequest(cgImage: image.toCGImage) {[weak self] (results, error) in
            Timer.stop(text: "VNTextObservation Finded")
            guard let sself = self else { return }
            
            let bitmap = sself.bitmap(from: image)
            Timer.stop(text: "Bitmap Created")
            PixelConverter.shared.setSize(size: bitmap.size, pixelSize: bitmap.pixelSize)
            let wordsRectangles = sself.rectangleConverter.convert(results, bitmap: bitmap)
            Timer.stop(text: "WordRectangles Converted")
            let blockCreator = BlockCreator(bitmap: bitmap)
            let blocks = blockCreator.create(from: wordsRectangles)
            
            completion(bitmap, wordsRectangles, error)
        }
    }
    private func bitmap(from image: NSImage) -> NSBitmapImageRep {
        image.lockFocus()
        let bitmap = NSBitmapImageRep(data: image.tiffRepresentation!)!
        image.unlockFocus()
        return bitmap
    }
}
