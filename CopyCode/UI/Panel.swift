//
//  Panel.swift
//  CaptureScreen
//
//  Created by Артем on 08/07/2018.
//  Copyright © 2018 Артем. All rights reserved.
//

import Cocoa

let TapCloseButton: Notification.Name  = .init("TapClose")

class Panel: NSPanel {

	@IBOutlet weak var imageView: NSImageView!
	@IBAction func tapClose(_ sender: NSButtonCell) {
		NotificationCenter.default.post(name: TapCloseButton, object: nil)
	}
    private let stringCreator = AttrStringCreator()
    private let textViewCreator = TextViewCreator()
    
    func addTextView(with text: String, in frame: NSRect, letterWidth: CGFloat, spacing: CGFloat) {
        let attrString = stringCreator.create(with: text, letterWidth: letterWidth, spacing: spacing)
        let textView = textViewCreator.create(with: frame, with: attrString)
        self.contentView?.addSubview(textView)
    }
    
    func closePanel() {
        orderOut(nil)
        removeTextViews()
    }
    
    func initialSetupe(with frame: CGRect) {
        makeKeyAndOrderFront(nil)
        //две линии отвечаают за прозрачность
        isOpaque = false
        backgroundColor = NSColor(red: 1, green: 0.5, blue: 0.5, alpha: 0.5)
        setFrame(frame, display: true)
    }
    
    func removeTextViews() {
        guard let subviews = contentView?.subviews else { return }
        for view in subviews {
            if let textView = view as? NSTextView {
                textView.removeFromSuperview()
            }
        }
    }
    
	override var canBecomeKey: Bool {
		return true
	}
}
