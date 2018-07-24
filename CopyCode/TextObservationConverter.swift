//
//  TextObservationConverter.swift
//  CopyCode
//
//  Created by Артем on 20/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit
import Vision

class TextObservationConverter {
    func toWordsRectangles(from results: [VNTextObservation], bitmap: NSBitmapImageRep) -> [WordRectangle] {
        let words: [WordRectangle] = results.map {
            let letters = toLettersRectangles(from: $0, in: bitmap)
            let frame = $0.frame(in: bitmap.size)
            let pixelFrame = getPixelFrame(from: $0, in: bitmap)
            return WordRectangle(frame: frame, pixelFrame: pixelFrame, letters: letters)
        }
        return words
        
    }
    
    private func toLettersRectangles(from result: VNTextObservation, in bitmap: NSBitmapImageRep) -> [LetterRectangle] {
        return result.characterBoxes?.map {
            let frame = $0.frame(in: bitmap.size)
            let pixelFrame = getPixelFrame(from: $0, in: bitmap)
            return LetterRectangle(frame: frame, pixelFrame: pixelFrame)} ?? []
    }
    
    private func getPixelFrame(from rectangle: VNRectangleObservation, in bitmap: NSBitmapImageRep) -> CGRect {
        
        let frame = rectangle.frame(in: bitmap.pixelSize)
        let wordFactor = WordFactor(frame: frame, in: bitmap)
        return wordFactor.frameCropExtended()
    }
}
