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
            guard let sself = self else { return }
            image.lockFocus()
            let bitmap = NSBitmapImageRep(data: image.tiffRepresentation!)!
            image.unlockFocus()
            let wordsRectangles = sself.rectangleConverter.convert(results, bitmap: bitmap)
            completion(bitmap, wordsRectangles, error)
        }
    }
}
