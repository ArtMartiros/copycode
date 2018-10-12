//
//  Panel.swift
//  CaptureScreen
//
//  Created by Артем on 08/07/2018.
//  Copyright © 2018 Артем. All rights reserved.
//

import Cocoa

let TapCloseButton: Notification.Name  = .init("TapClose")

protocol PanelDelegate: class {
    func tapCloseButton(panel: Panel)
    func tapCopyButton(panel: Panel, text: String?)
}

class Panel: NSPanel {
    private var alertView: NSImageView?
    
	@IBOutlet weak var imageView: NSImageView!
	@IBAction func tapClose(_ sender: NSButtonCell) {
		panelDelegate?.tapCloseButton(panel: self)
	}
    
    private let stringCreator = AttrStringCreator()
    private let textViewCreator = TextViewCreator()
    private let buttonCreator = ButtonCreator()
    weak var panelDelegate: PanelDelegate?
    
    func addTextFrame(with text: String, in frame: NSRect, letterWidth: CGFloat, spacing: CGFloat) {
        let attrString = stringCreator.createForTextView(with: text, letterWidth: letterWidth, spacing: spacing)
        let updatedFrame = frame.update(by: 10, in: .offset(.right))
        let textView = textViewCreator.create(with: updatedFrame, with: attrString)
        textView.copyDelegate = self
        textView.delegate = self
        self.contentView?.addSubview(textView)
    }

    private func alertInitialSetup() {
        let frame = contentView!.frame
        let width: CGFloat = 200
        let height: CGFloat = 184
        let x = (frame.width / 2) - (width / 2)
        let y = frame.height * (1/3) - (height / 2)
        alertView = NSImageView(image: NSImage(named: .init("picSuccessCopy")!)!)
        alertView?.frame = CGRect(x: x, y: y, width: width, height: height)
        alertView?.alphaValue = 0
        // Tell the view to create a backing layer.
        alertView?.wantsLayer = true
        alertView?.layerContentsRedrawPolicy = .onSetNeedsDisplay
        self.contentView?.addSubview(alertView!)
    }
    
    private func showAlert(completion: @escaping () -> Void) {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.3
            alertView?.animator().alphaValue = 1
        }, completionHandler: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                NSAnimationContext.runAnimationGroup({ [weak self] (context) in
                    context.duration = 0.5
                    self?.alertView?.animator().alphaValue = 0
                }, completionHandler: completion)
            })
        })
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
        if Settings.showAlert {
            alertInitialSetup()
        }
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

extension Panel: CopyTextViewDelegate, NSTextViewDelegate  {
    func copyButtonTapped(textView: CopyTextView, text: String?) {
        showAlert { [weak self] in
            guard let sself = self else { return }
            sself.panelDelegate?.tapCopyButton(panel: sself, text: text)
        }
    }
}

