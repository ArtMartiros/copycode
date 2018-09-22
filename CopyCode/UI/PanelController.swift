//
//  PanelController.swift
//  CopyCode
//
//  Created by Артем on 08/07/2018.
//  Copyright © 2018 Артем. All rights reserved.
//

import Cocoa

let showBlock = true
let showTextView = true

class PanelController: NSWindowController {
    var observer: NSObjectProtocol?
    private var panel: Panel {
        return window as! Panel
    }
    
    convenience init() {
        self.init(window: nil)
        Bundle.main.loadNibNamed(NSNib.Name("Panel"), owner: self, topLevelObjects: nil)
    }
    
    func closePanel() {
        panel.closePanel()
    }

    func openPanel(with image: CGImage) {
        addNotification()
        guard let screenRect = NSScreen.screens.first?.frame else { return }
        panel.initialSetupe(with: screenRect)
        
//        let frame = NSRect(x: 0, y: 0, width: 200, height: 200)
//        panel.addTextView(with: "Hello more complex", in: frame,  letterWidth: 7.5)
        
        let image = NSImage(cgImage: image, size: screenRect.size)
        panel.imageView.image = image
        showWords(image: image, size:  screenRect.size)
        
    }
    
    let textDetection = TextRecognizerManager()
    //отсчет пикселей с левого верхнего угла
    func showWords(image: NSImage, size: CGSize) {
        Timer.stop(text: "showWords")
        textDetection.performRequest(image: image) { [weak self] (bitmap, blocks, error) in
            self?.panel.imageView.layer?.sublayers?.removeSubrange(1...)
            let transcriptor = TextTranscriptor()
            if showTextView {
                for block in blocks {
                    if case .grid(let grid) = block.typography {
                        let text = transcriptor.test(block: block)
                        let width = grid.trackingData.defaultTracking.width
                        let spacing = grid.leading.lineSpacing
                        self?.panel.addTextView(with: text, in: block.frame, letterWidth: width, spacing: spacing - 1)
                    }
                }
            }
            
            Timer.stop(text: "TextTranscriptor transcriptor")
            if showBlock {
                let layers = blocks.layers(.blue, width: 3)
                layers.forEach { self?.panel.imageView.layer!.addSublayer($0) }
            }
            
            //            for block in blocks {
//                for line in block.lines {
//                    let words = line.wordsRectangles
//                    let newWords = converter.convertNew(words, in: bitmap)
//                    for word in newWords {
//                        let letterRecognizer = LetterRecognizer(bitmap, rectangle: word)
//                        let test = word.letters.map { letterRecognizer.recognize(from: $0) }
//                        print("Gansta \(test)")
//                    }
//                    print("Gansta next line ---------------")
//                }
//            }
            //------------Columns--------------
//            let columnsLayers = columns.map { $0.layer(.green, width: 2) }
//            columnsLayers.forEach { self.panel.imageView.layer!.addSublayer($0) }
        
            //------------Lines--------------
            let lineCreator = LineCreator<LetterRectangle>()
//            let newLines = lineCreator.createCusome2(from: words)
//            let lineLayers = newLines.map { $0.layer(.green, width: 2) }
             let lines = blocks.reduce([Line]()) { $0 + $1.lines }
           
            let lineLayers = lines.layers(.red, width: 3)
             lineLayers.forEach { self?.panel.imageView.layer!.addSublayer($0) }
//
            //------------Words--------------
//            let wordsLayers = words.map { $0.layer(.blue, width: 0.5) }
//            wordsLayers.forEach { self.panel.imageView.layer!.addSublayer($0) }
//
            //------------newWords--------------
            let newWords = lines.reduce([Word]()) { $0 + $1.words }
            let newWordsLayers = newWords.map { $0.layer(.blue, width: 1) }
            newWordsLayers.forEach { self?.panel.imageView.layer!.addSublayer($0) }
            

            

//
//            lineLayers.forEach { self.panel.imageView.layer!.addSublayer($0) }
            //------------chars--------------
            
            let chars = newWords.reduce([Letter]()) { $0 + $1.letters }
            let charLayers = chars.map { $0.layer(.green, width: 1) }
            charLayers.forEach { self?.panel.imageView.layer!.addSublayer($0) }
            
//            var charLayers: [CALayer] = []
//            for word in words {
//                charLayers.append(contentsOf: word.letters.map {  $0.layer(.red, width: 0.5) } )
//            }
//            charLayers.forEach { self.panel.imageView.layer!.addSublayer($0) }

            
            //------------Column--------------
//            let columnFrames = BlockCreator(rectangles: words, in: bitmap).column().map { $0.frame }
//            let columnLayers = layerCreator.layerForFrame(width: 1, color: NSColor.green, frames: columnFrames)
//            columnLayers.forEach { self.panel.imageView.layer!.addSublayer($0) }
//       
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

//extension PanelController {
//    /// Updates the UI with the results of the classification.
//    /// - Tag: ProcessClassifications
//    func processClassifications(for request: VNRequest, error: Error?) {
//        DispatchQueue.main.async {
//            guard let results = request.results else {
//                print("Unable to classify image.\n\(error!.localizedDescription)")
//                return
//            }
//            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
//            let classifications = results as! [VNClassificationObservation]
//
//            if classifications.isEmpty {
//                print("Nothing recognized.")
//            } else {
//                // Display top classifications ranked by confidence in the UI.
//                let topClassifications = classifications.prefix(2)
//                let descriptions = topClassifications.map { classification in
//                    // Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
//                    return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
//                }
//                Timer.stop(text: "classification")
//                print("Classification:\n" + descriptions.joined(separator: "\n"))
//            }
//        }
//    }
//
//
//}

