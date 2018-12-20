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
    // swiftlint:disable force_cast
    private var panel: Panel { return window as! Panel }
    private let dataSender = FirebaseScreenResultSender()

    convenience init() {
        self.init(window: nil)
        Bundle.main.loadNibNamed(NSNib.Name("Panel"), owner: self, topLevelObjects: nil)
        panel.panelDelegate = self
    }

    func openPanel(with cgImage: CGImage) {
        GlobalValues.shared.clear()
        GlobalValues.shared.cgImage = cgImage

        let frame = Screen.screenFrame
        panel.initialSetupe(with: frame, showScreeenButton: false)

        let image = NSImage(cgImage: cgImage, size: frame.size)
        if Settings.isTest {
            let testImage = NSImage("sc11")
            testImage.size = frame.size
            panel.imageView.image = testImage
            testShow()
        } else {
            panel.imageView.image = image
            let cgImage = !isRetina ? prepare(image: image).toCGImage : cgImage
            showWords(image: cgImage)
        }

    }

    func testShow() {
        panel.imageView.layer?.sublayers?.removeSubrange(1...)
        let block = "sc11_grid".decode(as: SimpleBlock.self)!
        let updatedBlock = block.updated(by: 2)
        show(updatedBlock, options: [.block, .line, .word, .char])

        //        let words = "sc14_rects".decode(as: [SimpleWord].self)!
        //        let updatedWords = words.map { $0.updated(by: 2) }
        //        show(words: updatedWords, options: [.word, .char])
    }

    private func show<T: BlockProtocol>(_ block: T, options: LayerOptions) {
        let transcriptor = TextTranscriptor()
        if options.contains(.textView) {
            if let block = block as? CompletedBlock {
                if case .grid(let grid) = block.typography {
                    let text = transcriptor.transcript(block: block)
                    let width = grid.trackingData.defaultTracking.width
                    let spacing = grid.leading.lineSpacing
                    let updatedFrame = grid.getUpdatedFrame(from: block.frame)
                    panel.addTextFrame(with: text, in: updatedFrame, letterWidth: width, spacing: spacing - 1)
                }
            }
        }

        if options.contains(.column) {
            let layer = block.column.layer(.red, width: 1)
            panel.imageView.layer!.addSublayer(layer)
        }

        if options.contains(.block) {
            let layer = block.layer(.blue, width: 3)
            panel.imageView.layer!.addSublayer(layer)
        }

        let lines = block.lines
        if options.contains(.line) {
            let lineLayers = lines.layers(.red, width: 1)
            lineLayers.forEach { panel.imageView.layer!.addSublayer($0) }
        }

        let words = lines.reduce([Word]()) { $0 + $1.words }
        show(words: words, options: options)
    }

    private func show<T: Container>(words: [T], options: LayerOptions) {
        if options.contains(.word) {
            let wordsLayers = words.map { $0.layer(.blue, width: 1) }
            wordsLayers.forEach { panel.imageView.layer!.addSublayer($0) }
        }

        let chars = words.reduce([Rectangle]()) { $0 + $1.letters }
        if options.contains(.char) {
            let charLayers = chars.map { $0.layer(.green, width: 1) }
            charLayers.forEach { panel.imageView.layer!.addSublayer($0) }
        }
    }

    func closePanel() {
        GlobalValues.shared.clear()
        panel.closePanel()
    }

    private let textDetection = TextRecognizerManager()
    //отсчет пикселей с левого верхнего угла
    func showWords(image: CGImage) {
        Timer.stop(text: "showWords")
        textDetection.performRequest(image: image, retina: isRetina) { [weak self] (_, oldBlocks, _) in
            self?.panel.imageView.layer?.sublayers?.removeSubrange(1...)
            //update size для экрана
            let blocks = oldBlocks.map { $0.updated(by: 2) }

            Timer.stop(text: "TextTranscriptor transcriptor")
            blocks.forEach { self!.show($0, options: Settings.showBlockOptions) }
            if Settings.enableFirebase {
                self?.dataSender.send()
            }
            Mixpanel.mainInstance().track(event: Mixpanel.kImageRecognize)
            Mixpanel.mainInstance().people.increment(property: Mixpanel.kCountRecognize, by: 1)
        }
    }

}

extension PanelController: PanelDelegate {
    func tapCloseButton(panel: Panel) {
        closePanel()
    }

    func tapSendScreenButton(panel: Panel) {
        //        sendToFirebase()
    }

    func tapCopyButton(panel: Panel, text: String?) {
        guard let string = text else { return }
        let pasterboard = NSPasteboard.general
        pasterboard.declareTypes([.string], owner: self)
        pasterboard.setString(string, forType: .string)
        closePanel()
    }
}

extension PanelController {
    fileprivate var isRetina: Bool { return Screen.screen.backingScaleFactor != 1 }

    fileprivate func prepare(image: NSImage) -> NSImage {
        let adjusted = image.adjustColors
        Timer.stop(text: "Adjusted")
        let resized = resize(adjusted)
        Timer.stop(text: "Resized")
        return resized
    }

    fileprivate func resize(_ image: NSImage) -> NSImage {
        switch Screen.retina {
        case .nonRetina:
            let newSize = Screen.screenFrame.size.scale(by: 2)
            return image.resize(targetSize: newSize)
        case .retina(scaleFactor: _):
            return image
        }
    }
}
