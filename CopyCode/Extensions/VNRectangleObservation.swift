//
//  VNRectangleObservation.swift
//  CopyCode
//
//  Created by Артем on 18/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation
import Vision

extension VNRectangleObservation {
    func frame(in currentSize: CGSize) -> CGRect {
        let xCord = topLeft.x * currentSize.width
        let yCord = (1 - topLeft.y) * currentSize.height
        let width = (topRight.x - bottomLeft.x) * currentSize.width
        let height = (topLeft.y - bottomLeft.y) * currentSize.height
        return CGRect(x: round(xCord), y: round(yCord), width: round(width), height: round(height))
    }
}
