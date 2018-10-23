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
var screenFrame: CGRect {
    return NSScreen.screens.first!.frame
}

final class PanelController: NSWindowController {
    // swiftlint:disable force_cast
    private var panel: Panel { return window as! Panel }

    convenience init() {
        self.init(window: nil)
        Bundle.main.loadNibNamed(NSNib.Name("Panel"), owner: self, topLevelObjects: nil)
        panel.panelDelegate = self
    }

    func openPanel(with cgImage: CGImage) {
//        let show = Auth.auth().currentUser != nil
        panel.initialSetupe(with: screenFrame, showScreeenButton: false)
        let image = NSImage(cgImage: cgImage, size: screenFrame.size)
        panel.imageView.image = image
        if Settings.enableFirebase {
            GlobalValues.shared.screenImage = image
        }
        showWords(image: cgImage)
    }

    func closePanel() {
        GlobalValues.shared.clear()
        panel.closePanel()
    }

    private let textDetection = TextRecognizerManager()
    //отсчет пикселей с левого верхнего угла
    func showWords(image: CGImage) {
        Timer.stop(text: "showWords")
        textDetection.performRequest(image: image) { [weak self] (bitmap, oldBlocks, _) in
            self?.panel.imageView.layer?.sublayers?.removeSubrange(1...)
            let rate = bitmap.size.width / screenFrame.width
            let intRate = Int(rate)
            let blocks = oldBlocks.map { $0.updated(by: intRate) }
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
