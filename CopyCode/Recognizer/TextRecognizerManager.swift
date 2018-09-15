//
//  TextRecognizerManager.swift
//  CopyCode
//
//  Created by Артем on 25/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

final class TextRecognizerManager {
    typealias TextCompletion = (_ bitmap: NSBitmapImageRep, _ blocks: [CompletedBlock], _ error: Error?) -> Void

    private let textDetection: TextDetection
    private let rectangleConverter: RectangleConverter
    
    init() {
        self.textDetection = TextDetection()
        self.rectangleConverter = RectangleConverter()
    }
    
    func performRequest(image: NSImage, completion: @escaping TextCompletion) {
        textDetection.performRequest(cgImage: image.toCGImage) {[weak self] (results, error) in
            Timer.stop(text: "VNTextObservation Finded")
            guard let sself = self else { return }
            
            let bitmap = sself.bitmap(from: image)
            PixelConverter.shared.setSize(size: bitmap.size, pixelSize: bitmap.pixelSize)
            let blockCreator = BlockCreator(in: bitmap)
            let typeConverter = TypeConverter(in: bitmap)
            let wordRecognizer = WordRecognizer(in: bitmap)
            
            Timer.stop(text: "Bitmap Created")
            
            let wordsRectangles = sself.rectangleConverter.convert(results, bitmap: bitmap)
            Timer.stop(text: "WordRectangles Converted")
            
            let blocks = blockCreator.create(from: wordsRectangles)
            Timer.stop(text: "BlockCreator created")
            
            let blocksWithTypes = blocks.map { typeConverter.convert($0) }
            Timer.stop(text: "TypeConverter Updated Type ")
            
            let completedBlocks = blocksWithTypes.map { wordRecognizer.recognize($0) }
            Timer.stop(text: "WordRecognizer Recognize")
            completion(bitmap, completedBlocks, error)
        }
    }
    
    private func bitmap(from image: NSImage) -> NSBitmapImageRep {
        image.lockFocus()
        let bitmap = NSBitmapImageRep(data: image.tiffRepresentation!)!
        image.unlockFocus()
        return bitmap
    }
}
