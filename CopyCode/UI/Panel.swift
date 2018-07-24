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

	override var canBecomeKey: Bool {
		return true
	}
}
