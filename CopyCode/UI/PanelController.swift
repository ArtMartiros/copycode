//
//  PanelController.swift
//  CopyCode
//
//  Created by Артем on 08/07/2018.
//  Copyright © 2018 Артем. All rights reserved.
//

import Cocoa
import Mixpanel
import FirebaseDatabase
import FirebaseStorage
//import FirebaseAuth

class Screen {
    static var screen: NSScreen {
        return NSScreen.screens.first!
    }
}

final class PanelController: NSWindowController {
    // swiftlint:disable force_cast
    private var panel: Panel { return window as! Panel }

    convenience init() {
        self.init(window: nil)
        Bundle.main.loadNibNamed(NSNib.Name("Panel"), owner: self, topLevelObjects: nil)
        panel.panelDelegate = self
    }

    var isTest = false
    func openPanel(with cgImage: CGImage) {
        let frame = Screen.screen.frame
        panel.initialSetupe(with: frame, showScreeenButton: false)
        let testImage = NSImage("sc3")
        testImage.size = frame.size
//        Save().save(cgImage)
        let image = NSImage(cgImage: cgImage, size: frame.size)
        panel.imageView.image = isTest ? testImage : image
        if Settings.enableFirebase {
            GlobalValues.shared.screenImage = image
        }
        if isTest {
            testShow()
        } else {
            let cgImage = !isRetina ? prepare(image: image).toCGImage : cgImage
            showWords(image: cgImage)
        }

    }

    func testShow() {
        let words = CodableHelper.decode(self, path: "sc3_rects_low", structType: [SimpleWord].self, shouldPrint: false)!
        let updatedWords = words.map { $0.updated(by: 2) }
        let chars = updatedWords.reduce([Rectangle]()) { $0 + $1.letters }
        let charLayers = chars.map { $0.layer(.green, width: 1) }
        if Settings.showChars {
            charLayers.forEach { panel.imageView.layer!.addSublayer($0) }
        }
    }
    func closePanel() {
        GlobalValues.shared.clear()
        panel.closePanel()
    }

    private let textDetection = TextRecognizerManager()
    //        let newBlock = CodableHelper.decode(self!, path: "sc1_restored_low", structType: SimpleBlock.self)?.updated(by: 2)
    //        let blocks = [newBlock!]

    //отсчет пикселей с левого верхнего угла
    func showWords(image: CGImage) {
        Timer.stop(text: "showWords")
        textDetection.performRequest(image: image, retina: isRetina) { [weak self] (_, oldBlocks, _) in
            self?.panel.imageView.layer?.sublayers?.removeSubrange(1...)
            let blocks = oldBlocks.map { $0.updated(by: 2) }
            let transcriptor = TextTranscriptor()
            if Settings.showTextView {
                for block in blocks {
                    if case .grid(let grid) = block.typography {
                        let text = transcriptor.transcript(block: block)
                        let width = grid.trackingData.defaultTracking.width
                        let spacing = grid.leading.lineSpacing
                        let updatedFrame = grid.getUpdatedFrame(from: block.frame)
                        self?.panel.addTextFrame(with: text, in: updatedFrame, letterWidth: width, spacing: spacing - 1)
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

            let chars = words.reduce([Rectangle]()) { $0 + $1.letters }
            let charLayers = chars.map { $0.layer(.green, width: 1) }
            if Settings.showChars {
                charLayers.forEach { self?.panel.imageView.layer!.addSublayer($0) }
            }

            //------------Column--------------
            //            let columnFrames = BlockCreator(rectangles: words, in: bitmap).column().map { $0.frame }
            //            let columnLayers = layerCreator.layerForFrame(width: 1, color: NSColor.green, frames: columnFrames)
            //            columnLayers.forEach { self.panel.imageView.layer!.addSublayer($0) }
            //
            if Settings.release {
                self?.sendToFirebase()
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
        pasterboard.setString(string, forType: .string)
        closePanel()
    }
}

extension PanelController {
    fileprivate var isRetina: Bool {
       return Screen.screen.backingScaleFactor != 1
    }

    fileprivate func prepare(image: NSImage) -> NSImage {
        let adjusted = image.adjustColors
        Timer.stop(text: "Adjusted")
        let resized = resize(adjusted)
        Timer.stop(text: "Resized")
        return resized
    }

    fileprivate func resize(_ image: NSImage) -> NSImage {
        guard !isRetina else { return image }
        let newSize = CGSize(width: Screen.screen.frame.width * 2, height: Screen.screen.frame.height * 2)
        return image.resize(targetSize: newSize)
    }
}

extension PanelController {
    private var screenRef: DatabaseReference { return Database.database().reference().child("screens") }
    private var storageRef: StorageReference { return Storage.storage().reference() }

    func sendToFirebase() {
        guard let imageData = GlobalValues.shared.screenImage?.tiffRepresentation,
            let rectangles = GlobalValues.shared.wordRectangles
            else { return }

        let wordsData = CodableHelper.toData(rectangles)
        let user = Date().toString(.yyyyMMdd ) //Auth.auth().currentUser,
        let stringDate = Date().toString(.yyyyMMddHHmm)
        let timeDate = Date().toString(.HHmm)
        let screenStorageRef = storageRef.child(user).child("screens").child(stringDate + ".png")
        let jsonStorageRef = storageRef.child(user).child("json").child(stringDate + ".json")

        screenStorageRef.putData(imageData, metadata: nil) { (_, _) in
            screenStorageRef.downloadURL(completion: { [weak self] (screenURL, _) in
                guard let screenURL = screenURL else { return }
                jsonStorageRef.putData(wordsData, metadata: nil, completion: { (_, _) in
                    jsonStorageRef.downloadURL(completion: { (jsonURL, _) in
                        guard let jsonURL = jsonURL else { return }
                        self?.screenRef.child(user).child(timeDate).setValue(["screenURL": screenURL.absoluteString,
                                                                                    "uploadTime": ServerValue.timestamp(),
                                                                                    "date": stringDate,
                                                                                    "jsonURL": jsonURL.absoluteString])
                        GlobalValues.shared.clear()
                    })
                })
            })
        }
    }
}
