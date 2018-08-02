//
//  RectangleConverter.swift
//  CopyCode
//
//  Created by Артем on 20/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit
import Vision

class RectangleConverter {
    typealias WordAlias = Word<LetterRectangle>
    func convert(_ results: [VNTextObservation], bitmap: NSBitmapImageRep) -> [WordAlias] {
        //        print("WORD -------")
        let words: [WordAlias] = results.map {
            let letters = convertToLetters(from: $0, in: bitmap)
            let frame = $0.frame(in: bitmap.size)
            let pixelFrame = getPixelFrame(from: $0, in: bitmap)
            //            print("x: \(pixelFrame.origin.x), y: \(pixelFrame.origin.y) | w: \(pixelFrame.size.width), h: \(pixelFrame.size.height) ")
            return Word(frame: frame, pixelFrame: pixelFrame, letters: letters)
        }
        //        print("\n\n")
        return words
        
    }
    
    private func convertToLetters(from result: VNTextObservation, in bitmap: NSBitmapImageRep) -> [LetterRectangle] {
        return result.characterBoxes?.map {
            let frame = $0.frame(in: bitmap.size)
            let pixelFrame = getPixelFrame(from: $0, in: bitmap)
            //            print(pixelFrame)
            return LetterRectangle(frame: frame, pixelFrame: pixelFrame)} ?? []
    }
    
    private func getPixelFrame(from rectangle: VNRectangleObservation, in bitmap: NSBitmapImageRep) -> CGRect {
        let frame = rectangle.frame(in: bitmap.pixelSize)
        let wordFactor = WordFactor(frame: frame)
        return wordFactor.frameCrop()
    }
}
