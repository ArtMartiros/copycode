//
//  TextRecognizerManager.swift
//  CopyCode
//
//  Created by Артем on 25/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

final class TextRecognizerManager {
    typealias TextCompletion = (_ bitmap: NSBitmapImageRep, _ results: [WordRectangleProtocol], _ error: Error?) -> Void
    typealias TextCompletionExtended = (_ bitmap: NSBitmapImageRep, _ results: [WordRectangleWithType], _ error: Error?) -> Void
    
    typealias TextCompletionExtended1 = (_ bitmap: NSBitmapImageRep, _ results: [Line], _ error: Error?) -> Void
    
    
    private let textDetection: TextDetection
    private let rectangleConverter: RectangleConverter
    private let rectanglesConverter: WordRectangleWithTypeConverter
    
    init() {
        self.textDetection = TextDetection()
        self.rectangleConverter = RectangleConverter()
        self.rectanglesConverter = WordRectangleWithTypeConverter()
    }
    
    func performRequest(image: NSImage, completion: @escaping TextCompletion) {
        textDetection.performRequest(cgImage: image.toCGImage) { (results, error) in
            Timer.stop(text: "textDetection.performRequest")
            image.lockFocus()
            let bitmap = NSBitmapImageRep(data: image.tiffRepresentation!)!
            let wordsRectangles = self.rectangleConverter.convert(results, bitmap: bitmap)
            Timer.stop(text: "wordsRectangles")
            BlockCreator(rectangles: wordsRectangles, in: bitmap).test()
            Timer.stop(text: "BlockCreator")
            completion(bitmap, wordsRectangles, error)
            image.unlockFocus()
        }
    }
    
    func performRequestExtended(image: NSImage, completion: @escaping TextCompletionExtended) {
        textDetection.performRequest(cgImage: image.toCGImage) { (results, error) in
            image.lockFocus()
            let bitmap = NSBitmapImageRep(data: image.tiffRepresentation!)!
            let wordsRectangles = self.rectangleConverter.convert(results, bitmap: bitmap)
            let protoWords = self.rectanglesConverter.convert(wordsRectangles)
            completion(bitmap, protoWords, error)
            image.unlockFocus()
        }
    }
    
    func performRequestExtended1(image: NSImage, completion: @escaping TextCompletionExtended1) {
        textDetection.performRequest(cgImage: image.toCGImage) { (results, error) in
            image.lockFocus()
            let bitmap = NSBitmapImageRep(data: image.tiffRepresentation!)!
            Timer.stop(text: "before")
            let wordsRectangles = self.rectangleConverter.convert(results, bitmap: bitmap)
            Timer.stop(text: "wordsRectangles")
            self.rectanglesConverter.convert(wordsRectangles)
            let lines = LineCreator(rectangles: wordsRectangles).create()
            completion(bitmap, lines, error)
            image.unlockFocus()
        }
    }
    
}
