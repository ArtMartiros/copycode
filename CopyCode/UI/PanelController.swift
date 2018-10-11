//
//  PanelController.swift
//  CopyCode
//
//  Created by Артем on 08/07/2018.
//  Copyright © 2018 Артем. All rights reserved.
//

import Cocoa
import Mixpanel

final class PanelController: NSWindowController {
    private var panel: Panel { return window as! Panel }
    
    convenience init() {
        self.init(window: nil)
        Bundle.main.loadNibNamed(NSNib.Name("Panel"), owner: self, topLevelObjects: nil)
        panel.panelDelegate = self
    }

    func openPanel(with image: CGImage) {
        guard let screenRect = NSScreen.screens.first?.frame else { return }
        panel.initialSetupe(with: screenRect)
        let image = NSImage(cgImage: image, size: screenRect.size)
        panel.imageView.image = image
        showWords(image: image, size:  screenRect.size)
        
    }
    
    func closePanel() {
        panel.closePanel()
    }
    
   private let textDetection = TextRecognizerManager()
    //отсчет пикселей с левого верхнего угла
    func showWords(image: NSImage, size: CGSize) {
        Timer.stop(text: "showWords")
        textDetection.performRequest(image: image) { [weak self] (bitmap, blocks, error) in
            self?.panel.imageView.layer?.sublayers?.removeSubrange(1...)
            let transcriptor = TextTranscriptor()
            if Settings.showTextView {
                for block in blocks {
                    if case .grid(let grid) = block.typography {
                        let text = transcriptor.transcript(block: block)
                        let width = grid.trackingData.defaultTracking.width
                        let spacing = grid.leading.lineSpacing
                        self?.panel.addTextFrame(with: text, in: block.frame, letterWidth: width, spacing: spacing - 1)
                    }
                }
            }
            
            Timer.stop(text: "TextTranscriptor transcriptor")
            if Settings.showBlock {
                let layers = blocks.layers(.blue, width: 3)
                layers.forEach { self?.panel.imageView.layer!.addSublayer($0) }
            }
            
            //------------Columns--------------
//            let columnsLayers = columns.map { $0.layer(.green, width: 2) }
//            columnsLayers.forEach { self.panel.imageView.layer!.addSublayer($0) }
        
            //------------Lines--------------
            let lines = blocks.reduce([Line]()) { $0 + $1.lines }
            let lineLayers = lines.layers(.red, width: 1)
            if Settings.showLines {
                lineLayers.forEach { self?.panel.imageView.layer!.addSublayer($0) }
            }
            
            //------------Words--------------
            let words = lines.reduce([Word]()) { $0 + $1.words }
            let wordsLayers = words.map { $0.layer(.blue, width: 1) }
            if Settings.showWords {
                wordsLayers.forEach { self?.panel.imageView.layer!.addSublayer($0) }
            }

            //------------chars--------------
            
            let chars = words.reduce([Letter]()) { $0 + $1.letters }
            let charLayers = chars.map { $0.layer(.green, width: 1) }
            if Settings.showChars {
                charLayers.forEach { self?.panel.imageView.layer!.addSublayer($0) }
            }
            
            //------------Column--------------
//            let columnFrames = BlockCreator(rectangles: words, in: bitmap).column().map { $0.frame }
//            let columnLayers = layerCreator.layerForFrame(width: 1, color: NSColor.green, frames: columnFrames)
//            columnLayers.forEach { self.panel.imageView.layer!.addSublayer($0) }
//
            Mixpanel.mainInstance().track(event: Mixpanel.kImageRecognize)
            Mixpanel.mainInstance().people.increment(property: Mixpanel.kCountRecognize, by: 1)
        }
    }

}

extension PanelController: PanelDelegate {
    func tapCloseButton(panel: Panel) {
        closePanel()
    }
    
    func tapCopyButton(panel: Panel, text: String?) {
        guard let string = text else { return }
        let pasterboard = NSPasteboard.general
        pasterboard.setString(string, forType: .string)
        closePanel()
    }
}
