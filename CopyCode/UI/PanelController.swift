//
//  PanelController.swift
//  CopyCode
//
//  Created by Артем on 08/07/2018.
//  Copyright © 2018 Артем. All rights reserved.
//

import Cocoa
import CoreML
import Vision
//extension NSImage {
//    var preparedImage: NSImage {
//        lockFocus()
//        let bitMap = NSBitmapImageRep(data: tiffRepresentation!)
//        let testSize = bitMap!.size
//        draw(in: CGRect(origin: .zero, size: testSize))
//        unlockFocus()
//        return adjustColors.grayscale
//    }
//}

class ImageDrawer {
    private let image: NSImage
    
    init(image: NSImage) {
        self.image = image
    }
    
    var preparedImage: NSImage {
        return image.preparedImage
    }
}
class PanelController: NSWindowController {
    var observer: NSObjectProtocol?
    var myModel = true
    private var panel: Panel {
        return window as! Panel
    }
    
    
    convenience init() {
        self.init(window: nil)
        Bundle.main.loadNibNamed(NSNib.Name("Panel"), owner: self, topLevelObjects: nil)
    }
    
    func closePanel() {
        panel.orderOut(nil)
    }
    let test = false
    struct Hmm {
        let image: String
        let test: String
    }
    let testCases: [Hmm] = [Hmm(image: "picA1", test: "ABCDEFGHIJKLMNOPQRSTUVWXYZ"),
                            Hmm(image: "picA2", test: "abcdefghijklmnopqrstuvwxyz"),
                            Hmm(image: "picA3", test: "1234567890")]
    var current: Hmm {
        return testCases[1]
    }
    
    func openPanel(with image: CGImage) {
        addNotification()
        let screenRect = NSScreen.screens.first?.frame
        panel.makeKeyAndOrderFront(nil)
        
        if test {
            let testImage = NSImage(named: .init("picWordsHigh2"))
            testImage?.lockFocus()
            let bitMap = NSBitmapImageRep(data: testImage!.tiffRepresentation!)
            let testSize = bitMap!.size
            testImage?.draw(in: CGRect(origin: .zero, size: testSize))
            testImage?.unlockFocus()
            let new = testImage?.adjustColors.grayscale
            panel.setFrame(CGRect(origin: .zero, size: testSize), display: true)
            panel.imageView.image = new
            showWords(image: new!, size:  testSize)
        } else {
            panel.setFrame(screenRect!, display: true)
            let image = NSImage(cgImage: image, size: screenRect!.size)
            panel.imageView.image = image
            showWords(image: image, size:  screenRect!.size)
        }
    }
    
    let textDetection = TextDetection()
    //отсчет пикселей с левого верхнего угла
    func showWords(image: NSImage, size: CGSize) {
        textDetection.performRequest(cgImage: image.toCGImage) { results, error in
            image.lockFocus()
            let bitMap = NSBitmapImageRep(data: image.tiffRepresentation!)
            print(size)
            Timer.stop(text: "before finish")
            var letters:[VNRectangleObservation] = []
            results.forEach {
                let word = $0.characterBoxes?.compactMap { $0 } ?? []
                letters.append(contentsOf: word)
            }
            letters.sort(by: { (one, two) -> Bool in
                return one.topLeft.x < two.topLeft.x
            })
            
            var rightLetters = Array(self.current.test).map { String($0) }
            for (index, letter) in letters.enumerated() {
                //                if let char = myTree.find(in: bitMap!, with: letter) {
                //                    let rightLetter = rightLetters[index]
                //                    if char == rightLetter {
                //                        print("✅: \(char)")
                //                    } else {
                //                        print("❌ expect: \(rightLetter), instead \(char)")
                //                    }
                //                }
                
                //                let framePixel = letter.frame(in: bitMap!.pixelSize)
                //                let y = bitMap!.pixelsHigh - Int(framePixel.maxY)
                //                let x = Int(framePixel.minX)
                //                for i in 0..<100 { // for 0 to 9 .
                //                    let xt = x + i
                //                    for j in 0..<100 {
                //                        let yt = y + j
                //                        let color = bitMap?.colorAt(x: xt, y: yt)
                //                        let color1 = color?.usingColorSpace(NSColorSpace.deviceGray)
                //                        var grayscale: CGFloat = 0
                //                        var alpha: CGFloat = 0
                //                        color1?.getWhite(&grayscale, alpha: &alpha)
                //                        print("Pos x: \(xt), y: \(yt) grayscale: \(grayscale.rounded(toPlaces: 3))")
                //                    }
                //                }
                let _  = "dd"
            }
            
            image.unlockFocus()
            Timer.stop(text: "finish")
            //            let handler = TextDetectionHandler(request: request, imageSize: size)
            let layerCreator = LayerCreator()
            let frames = letters.compactMap { (h) -> CGRect in
                let test =  h.frame(in: size)
                //                print(test)
                return test
            }
            let wordFrames = results.compactMap { $0.frame(in: size) }
            //
            //            let frames = handler.words.reduce([CGRect](), { (result, word ) -> [CGRect] in
            //                var result = result
            //                result.append(contentsOf: word.letters)
            //                return result
            //            })
            //
            //            var grayscale: CGFloat = 0
            //            var alpha: CGFloat = 0
            //            Timer.stop(text: "before bitmap")
            //            image.lockFocus()
            //            let bitMap = NSBitmapImageRep(data: image.tiffRepresentation!)
            //            for frame in frames {
            //                let color = bitMap?.colorAt(x: Int(frame.minX), y: Int(frame.minY))
            //                let color1 = bitMap?.colorAt(x: Int(frame.minX), y: Int(frame.maxY))
            //                let color2 = bitMap?.colorAt(x: Int(frame.maxX), y: Int(frame.maxY))
            //                let color3 = bitMap?.colorAt(x: Int(frame.maxX), y: Int(frame.minY))
            //            }
            //            image.unlockFocus()
            //            Timer.stop(text: "after bitmap")
            //
            //            let images = frames.compactMap { image.crop(to: $0) }
            //            Timer.stop(text: "after crop")
            //            for item in images {
            //                item.bL
            //                item.bR
            //                item.tL
            //                item.tR
            ////                item.bottomRight.color
            ////                item.topRight.color
            ////                item.topLeft.color
            ////                self.updateClassifications(for: item)
            //            }
            //
            //
            //            Timer.stop(text: "recognize")
            //
            wordFrames.forEach {
                let frame = CGRect(x: round($0.minX), y: round($0.maxY), width: round($0.width), height: round($0.height))
                print("X: \(round($0.minX)), y: \(round($0.minY)) || h: \(round($0.height)), w: \(round($0.width)) ")
            }
            let bg = layerCreator.layerForFrame(width: 0, color: NSColor.white, frames: [NSScreen.screens.first!.frame])
            let layers = layerCreator.layerForFrame(width: 0.7, color: NSColor.blue, frames: wordFrames)
            let layers2 = layerCreator.layerForFrame(width: 0.7, color: NSColor.red, frames: frames)
            self.panel.imageView.layer?.sublayers?.removeSubrange(1...)
            self.panel.imageView.layer!.addSublayer(bg[0])
            layers.forEach { self.panel.imageView.layer!.addSublayer($0) }
            //            layers2.forEach { self.panel.imageView.layer!.addSublayer($0) }
            print("sss")
        }
        
        
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(forName: TapCloseButton, object: nil, queue: nil) { (notification) in
            self.closePanel()
        }
    }
    
    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
        
    }
}

extension PanelController {
    /// Updates the UI with the results of the classification.
    /// - Tag: ProcessClassifications
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                print("Unable to classify image.\n\(error!.localizedDescription)")
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]
            
            if classifications.isEmpty {
                print("Nothing recognized.")
            } else {
                // Display top classifications ranked by confidence in the UI.
                let topClassifications = classifications.prefix(2)
                let descriptions = topClassifications.map { classification in
                    // Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
                    return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
                }
                Timer.stop(text: "classification")
                print("Classification:\n" + descriptions.joined(separator: "\n"))
            }
        }
    }
    
    
}
