//
//  TextDetection.swift
//  CopyCode
//
//  Created by Артем on 18/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation
import Vision
import Cocoa

class TextDetectionManager {
    typealias TextCompletion = (_ bitmap: NSBitmapImageRep, _ results: [WordRectangleProtocol], _ error: Error?) -> Void
    typealias TextCompletionExtended1 = (_ bitmap: NSBitmapImageRep, _ results: [ProtoWord], _ error: Error?) -> Void
    

    
    private let textDetection: TextDetection
    private let textConverter: TextObservationConverter
    private let rectanglesConverter: WordRectanglesConverter
    
    init() {
        self.textDetection = TextDetection()
        self.textConverter = TextObservationConverter()
        self.rectanglesConverter = WordRectanglesConverter()
    }
    
    func performRequest(image: NSImage, completion: @escaping TextCompletion) {
        textDetection.performRequest(cgImage: image.toCGImage) { (results, error) in
            image.lockFocus()
            let bitmap = NSBitmapImageRep(data: image.tiffRepresentation!)!
            let wordsRectangles = self.textConverter.toWordsRectangles(from: results, bitmap: bitmap)
            completion(bitmap, wordsRectangles, error)
            image.unlockFocus()
        }
    }
    
    func performRequestExtended(image: NSImage, completion: @escaping TextCompletionExtended1) {
        textDetection.performRequest(cgImage: image.toCGImage) { (results, error) in
            image.lockFocus()
            let bitmap = NSBitmapImageRep(data: image.tiffRepresentation!)!
            let wordsRectangles = self.textConverter.toWordsRectangles(from: results, bitmap: bitmap)
            let protoWords = self.rectanglesConverter.toProtoWords(from: wordsRectangles)
            completion(bitmap, protoWords, error)
            image.unlockFocus()
        }
    }

}


typealias VNTextObservationsCompletionHandler = ([VNTextObservation], Error?) -> Void

class TextDetection {
    
    func performRequest(cgImage: CGImage, completionHandler: VNTextObservationsCompletionHandler? ) {
        let requests = createRequests(completionHandler: completionHandler)
        performImageRequest(cgImage: cgImage, requests: requests)
    }
    
    private func createRequests(completionHandler: VNTextObservationsCompletionHandler? ) -> [VNRequest]  {
        let textRequest =  VNDetectTextRectanglesRequest { request, error in
            let results = request.results?.compactMap { $0 as? VNTextObservation } ?? []
            completionHandler?(results, error)
        }
        
        textRequest.reportCharacterBoxes = true
        return [textRequest]
    }
    
    private func performImageRequest(cgImage: CGImage, requests: [VNRequest]) {
        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, orientation:.downMirrored, options: [:])
        do {
            try imageRequestHandler.perform(requests)
        } catch {
            print(error)
        }
    }
}

protocol OCRServiceDelegate: class {
    func ocrService(_ service: OCRService, didDetect text: String)
}

final class OCRService {
    //    private let tesseract = G8Tesseract(language: "eng")!
    //
    weak var delegate: OCRServiceDelegate?
    //
    //    init() {
    //        tesseract.engineMode = .tesseractCubeCombined
    //        tesseract.pageSegmentationMode = .singleBlock
    //    }
    //
    func handle(image: NSImage, with words: [VNTextObservation]) {
        image.lockFocus()
        let bitmap = NSBitmapImageRep(data: image.tiffRepresentation!)!
        for word in words {
            for letter in word.characterBoxes ?? [] {
                if letterExist(in: bitmap, at: letter.topLeft) {
                    
                }
            }
        }
        image.unlockFocus()
    }
    
    func letterExist(in bitmap: NSBitmapImageRep?, at point: CGPoint) -> Bool {
        return true
    }
    //
    private func handleWithTesseract(image: NSImage) {
        //        tesseract.image = image.g8_blackAndWhite()
        //        tesseract.recognize()
        //        let text = tesseract.recognizedText ?? ""
        //        delegate?.ocrService(self, didDetect: text)
    }
}
