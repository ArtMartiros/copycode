//
//  LayerCreator.swift
//  CopyCode
//
//  Created by Артем on 18/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import AppKit

class LayerCreator {
    func layerForFrame(width: CGFloat, color: NSColor, frames: [CGRect]) -> [CALayer] {
        return frames.map { layerForFrame(width: width, color: color, frame: $0) }
    }
    
    private func layerForFrame(width: CGFloat, color: NSColor, frame: CGRect) -> CALayer {
        let outline = CALayer()
        outline.frame = frame
        outline.borderWidth = width
        outline.borderColor = color.cgColor
        return outline
    }
}
