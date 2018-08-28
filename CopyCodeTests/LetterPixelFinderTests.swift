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
        let (letterPixelFinder, frames) = getPixelFinderWithFrames(from: .dot)
        for (index, frame) in frames.enumerated() {
            let point = letterPixelFinder.find(in: frame, with: .minXEdge)
            XCTAssertTrue(point != nil, "dot not find at index: \(index)")
        }
    }
    
    func testDash() {
        let (letterPixelFinder, frames) = getPixelFinderWithFrames(from: .dash)
        for (index, frame) in frames.enumerated() {
            let point = letterPixelFinder.find(in: frame, with: .minXEdge)
            XCTAssertTrue(point != nil, "dash not find at index: \(index)")
        }
    }
    
    func testEqual() {
        let (letterPixelFinder, frames) = getPixelFinderWithFrames(from: .equal)
        for (index, frame) in frames.enumerated() {
            let point = letterPixelFinder.find(in: frame, with: .minXEdge)
            XCTAssertTrue(point != nil, "equal not find at index: \(index)")
        }
    }
    
    func testQuotes() {
        let (letterPixelFinder, frames) = getPixelFinderWithFrames(from: .quotes)
        for (index, frame) in frames.enumerated() {
            let point = letterPixelFinder.find(in: frame, with: .minXEdge)
            XCTAssertTrue(point != nil, "quotes not find at index: \(index)")
        }
    }
    
    func testUnderscore() {
        let (letterPixelFinder, frames) = getPixelFinderWithFrames(from: .underscore)
        for (index, frame) in frames.enumerated() {
            let point = letterPixelFinder.find(in: frame, with: .minXEdge)
            XCTAssertTrue(point != nil, "underscore not find at index: \(index)")
        }
    }

    private func getPixelFinderWithFrames(from picture: LetterPixelFinderPicture) -> (LetterPixelFinder, [CGRect]) {
        return ( getLetterPixelFinder(from: picture), getFrames(from: picture) )
    }
    
    private func getLetterPixelFinder(from picture: LetterPixelFinderPicture) -> LetterPixelFinder {
        let image = NSImage(named: .init(picture.imageName))!
        image.lockFocus()
        let bitmap = NSBitmapImageRep(data: image.tiffRepresentation!)!
        image.unlockFocus()
        let pixelChecker = LetterPixelChecker(backgroundWhite: 1, letterDefaultWhite: 0, whitePercent: 70)
        let existenceChecker = LetterExistenceChecker(bitmap, pixelChecker: pixelChecker)
        let letterPixelFinder = LetterPixelFinder(checker: existenceChecker)
        return letterPixelFinder
    }
    
    private func getFrames(from picture: LetterPixelFinderPicture) -> [CGRect] {
        guard let frames = DecodeHelper.decode(self,
                                                path: picture.json,
                                                structType: [Answer].self) else { return [] }
        return frames.map { $0.frame }
    }

    
}

