//
//  LetterPixelFinderTests.swift
//  CopyCodeTests
//
//  Created by Артем on 27/08/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import XCTest

fileprivate struct Answer: Codable {
    var frame: CGRect { return CGRect(origin: origin, size: size) }
    var origin: CGPoint { return CGPoint(x: x, y: y) }
    var size: CGSize { return CGSize(width: width, height: height) }
    private let x: CGFloat
    private let y: CGFloat
    private let width: CGFloat
    private let height: CGFloat
}

class LetterPixelFinderTests: XCTestCase {

    func testDot() {
        let (bitmap, frames) = getBitmapWithFrames(from: .dot)
        let letterPixelFinder = getLetterPixelFinder(from: bitmap)
        for (index, frame) in frames.enumerated() {
            let result = letterPixelFinder.find(in: frame, with: .minXEdge)
            XCTAssertTrue(result, "dot not find at index: \(index)")
        }
    }

    func testDash() {
        let (bitmap, frames) = getBitmapWithFrames(from: .dash)
        let letterPixelFinder = getLetterPixelFinder(from: bitmap)
        for (index, frame) in frames.enumerated() {
            let result = letterPixelFinder.find(in: frame, with: .minXEdge)
            XCTAssertTrue(result, "dot not find at index: \(index)")
        }
    }

    func testEqual() {
        let (bitmap, frames) = getBitmapWithFrames(from: .equal)
        let letterPixelFinder = getLetterPixelFinder(from: bitmap)
        for (index, frame) in frames.enumerated() {
            let result = letterPixelFinder.find(in: frame, with: .minXEdge)
            XCTAssertTrue(result, "dot not find at index: \(index)")
        }
    }

    func testQuotes() {
        let (bitmap, frames) = getBitmapWithFrames(from: .quotes)
        let letterPixelFinder = getLetterPixelFinder(from: bitmap)
        for (index, frame) in frames.enumerated() {
            let result = letterPixelFinder.find(in: frame, with: .minXEdge)
            XCTAssertTrue(result, "dot not find at index: \(index)")
        }
    }

    func testUnderscore() {
        let (bitmap, frames) = getBitmapWithFrames(from: .underscore)
        let letterPixelFinder = getLetterPixelFinder(from: bitmap)
        for (index, frame) in frames.enumerated() {
            let result = letterPixelFinder.find(in: frame, with: .minXEdge)
            XCTAssertTrue(result, "dot not find at index: \(index)")
        }
    }

    private func getBitmapWithFrames(from picture: LetterPixelFinderPicture) -> (NSBitmapImageRep, [CGRect]) {
        return ( getBitmap(from: picture), getFrames(from: picture) )
    }
    
    private func getBitmap(from picture: LetterPixelFinderPicture) -> NSBitmapImageRep {
        let image = NSImage(named: .init(picture.imageName))!
        image.lockFocus()
        let bitmap = NSBitmapImageRep(data: image.tiffRepresentation!)!
        image.unlockFocus()
        return bitmap
    }
    
    private func getLetterPixelFinder(from bitmap: NSBitmapImageRep) -> LetterPixelFinder {
        let pixelChecker = LetterPixelChecker(backgroundWhite: 1, letterDefaultWhite: 0, whitePercent: 70)
        let existenceChecker = LetterExistenceChecker(bitmap, pixelChecker: pixelChecker)
        let letterPixelFinder = LetterPixelFinder(checker: existenceChecker)
        return letterPixelFinder
    }
    
    private func getFrames(from picture: LetterPixelFinderPicture) -> [CGRect] {
        guard let frames = CodableHelper.decode(self, path: picture.json,
                                                structType: [Answer].self) else { return [] }
        return frames.map { $0.frame }
    }

    
}

