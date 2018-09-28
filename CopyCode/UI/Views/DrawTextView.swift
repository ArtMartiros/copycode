//
//  DrawTextView.swift
//  CopyCode
//
//  Created by Артем on 28/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Cocoa

class DrawTextView: NSTextView {
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        let context = NSGraphicsContext.current?.cgContext
        drawBorderGraphInContext(context)
    }
    
    fileprivate struct Constants {
        static let borderCornerRadius: CGFloat = 8.0
        static let borderLineWidth: CGFloat = 4
    }
    
    func drawBorderGraphInContext(_ context: CGContext?) {
        
        drawRoundedRect(bounds, inContext: context,
                        radius: Constants.borderCornerRadius,
                        borderColor: NSColor.textViewStrokeColor.cgColor,
                        borderWidth: Constants.borderLineWidth,
                        fillColor: NSColor.textViewFillColor.cgColor)
    }
    
    func drawRoundedRect(_ rect: CGRect, inContext context: CGContext?,
                         radius: CGFloat, borderColor: CGColor, borderWidth: CGFloat, fillColor: CGColor) {
        // 1
        let path = CGMutablePath()
        
        // 2
        path.move( to: CGPoint(x:  rect.midX, y:rect.minY ))
        path.addArc( tangent1End: CGPoint(x: rect.maxX, y: rect.minY ), tangent2End: CGPoint(x: rect.maxX, y: rect.maxY), radius: radius)
        path.addArc( tangent1End: CGPoint(x: rect.maxX, y: rect.maxY ), tangent2End: CGPoint(x: rect.minX, y: rect.maxY), radius: radius)
        path.addArc( tangent1End: CGPoint(x: rect.minX, y: rect.maxY ), tangent2End: CGPoint(x: rect.minX, y: rect.minY), radius: radius)
        path.addArc( tangent1End: CGPoint(x: rect.minX, y: rect.minY ), tangent2End: CGPoint(x: rect.maxX, y: rect.minY), radius: radius)
        
        path.closeSubpath()
        
        // 3
        context?.setLineWidth(borderWidth)
        context?.setFillColor(fillColor)
        context?.setStrokeColor(borderColor)
        
        // 4
        context?.addPath(path)
        context?.drawPath(using: .fillStroke)
    }
}
