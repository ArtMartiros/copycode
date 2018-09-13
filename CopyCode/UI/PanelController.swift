//
//  PanelController.swift
//  CopyCode
//
//  Created by Артем on 08/07/2018.
//  Copyright © 2018 Артем. All rights reserved.
//

import Cocoa

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
        panel.orderOut(nil)
    }

    func openPanel(with image: CGImage) {
        addNotification()
        let screenRect = NSScreen.screens.first?.frame
        panel.makeKeyAndOrderFront(nil)
        panel.setFrame(screenRect!, display: true)
        let image = NSImage(cgImage: image, size: screenRect!.size)
        panel.imageView.image = image//.adjustColors.grayscale
        showWords(image: image, size:  screenRect!.size)
        
    }
    
    let textDetection = TextRecognizerManager()
    //отсчет пикселей с левого верхнего угла
    func showWords(image: NSImage, size: CGSize) {
        Timer.stop(text: "showWords")
        textDetection.performRequest(image: image) { (bitmap, words, error) in
            self.panel.imageView.layer?.sublayers?.removeSubrange(1...)
            
            let recognizer = WordRecognizer(in: bitmap)
            let columnDetection = DigitColumnDetection(recognizer: recognizer)
            let columnMerger = DigitColumnMerger()
            let columnCreator = DigitColumnSplitter(columnDetection: columnDetection, columnMerger: columnMerger)

            let restorer = MissingElementsRestorer(bitmap: bitmap)
            
            //------------blocks--------------
            let creator = BlockCreator(digitalColumnCreator: columnCreator, elementsRestorer: restorer)
            let blocks = creator.create(from: words)
            let layers = blocks.layers(.blue, width: 3)
            layers.forEach { self.panel.imageView.layer!.addSublayer($0) }
//            let converter = TypeConverter()
            
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
           
            let lineLayers = lines.layers(.red, width: 1)
             lineLayers.forEach { self.panel.imageView.layer!.addSublayer($0) }
//
            //------------Words--------------
//            let wordsLayers = words.map { $0.layer(.blue, width: 0.5) }
//            wordsLayers.forEach { self.panel.imageView.layer!.addSublayer($0) }
//
            //------------newWords--------------
            let newWords = lines.reduce([Word]()) { $0 + $1.words }
            let newWordsLayers = newWords.map { $0.layer(.blue, width: 1) }
            newWordsLayers.forEach { self.panel.imageView.layer!.addSublayer($0) }
            

            

//
//            lineLayers.forEach { self.panel.imageView.layer!.addSublayer($0) }
            //------------chars--------------
            
            let chars = newWords.reduce([LetterRectangle]()) { $0 + $1.letters }
            let charLayers = chars.map { $0.layer(.green, width: 1) }
            charLayers.forEach { self.panel.imageView.layer!.addSublayer($0) }
            
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

