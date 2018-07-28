//
//  TextDetection.swift
//  CopyCode
//
//  Created by Артем on 18/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Vision
import AppKit

typealias VNTextObservationsCompletionHandler = ([VNTextObservation], Error?) -> Void

final class TextDetection {
    
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

//protocol OCRServiceDelegate: class {
//    func ocrService(_ service: OCRService, didDetect text: String)
//}
//
//final class OCRService {
//    //    private let tesseract = G8Tesseract(language: "eng")!
//    //
//    weak var delegate: OCRServiceDelegate?
//    //
//    //    init() {
//    //        tesseract.engineMode = .tesseractCubeCombined
//    //        tesseract.pageSegmentationMode = .singleBlock
//    //    }
//    //
//    func handle(image: NSImage, with words: [VNTextObservation]) {
//        image.lockFocus()
//        let bitmap = NSBitmapImageRep(data: image.tiffRepresentation!)!
//        for word in words {
//            for letter in word.characterBoxes ?? [] {
//                if letterExist(in: bitmap, at: letter.topLeft) {
//
//                }
//            }
//        }
//        image.unlockFocus()
//    }
//
//    func letterExist(in bitmap: NSBitmapImageRep?, at point: CGPoint) -> Bool {
//        return true
//    }
//    //
//    private func handleWithTesseract(image: NSImage) {
//        //        tesseract.image = image.g8_blackAndWhite()
//        //        tesseract.recognize()
//        //        let text = tesseract.recognizedText ?? ""
//        //        delegate?.ocrService(self, didDetect: text)
//    }
//}
