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
    typealias TextCompletionExtended = (_ bitmap: NSBitmapImageRep, _ results: [Word<LetterRectangleWithType>], _ error: Error?) -> Void
    
    typealias TextCompletionExtended1 = (_ bitmap: NSBitmapImageRep, _ results: [Line<LetterRectangle>], _ error: Error?) -> Void
    
    
    private let textDetection: TextDetection
    private let rectangleConverter: RectangleConverter
    private let typeIdentifier: WordRectangleWithTypeConverter
    
    init() {
        self.textDetection = TextDetection()
        self.rectangleConverter = RectangleConverter()
        self.typeIdentifier = WordRectangleWithTypeConverter()
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
    
    func performRequestExtended(image: NSImage, completion: @escaping TextCompletionExtended) {
        textDetection.performRequest(cgImage: image.toCGImage) { (results, error) in
            image.lockFocus()
            let bitmap = NSBitmapImageRep(data: image.tiffRepresentation!)!
            let wordsRectangles = self.rectangleConverter.convert(results, bitmap: bitmap)
            let protoWords = self.typeIdentifier.convert(wordsRectangles)
            completion(bitmap, protoWords, error)
            image.unlockFocus()
        }
    }
    
    func performRequestExtended1(image: NSImage, completion: @escaping TextCompletionExtended1) {
        textDetection.performRequest(cgImage: image.toCGImage) { (results, error) in
            image.lockFocus()
            let bitmap = NSBitmapImageRep(data: image.tiffRepresentation!)!
            let wordsRectangles = self.rectangleConverter.convert(results, bitmap: bitmap)
            self.typeIdentifier.convert(wordsRectangles)
//            let lines = LineCreator(rectangles: wordsRectangles).create()
            completion(bitmap, [], error)
            image.unlockFocus()
        }
    }
    
}
