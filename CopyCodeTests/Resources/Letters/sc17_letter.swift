//
//  sc17_letter.swift
//  CopyCodeTests
//
//  Created by Артем on 04/12/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

let sc17_letter = [
    0: "UIGraphicsBeginImageContextWithOptions(CGSize(width: 100, height: 100), false, 0)",

    1: "let square = CGRect(x: 0, y: 0, width: 100, height: 100)",

    2: "let context = UIGraphicsGetCurrentContext()!",
    3: "context.setFillColor(UIColor.white.cgColor)",
    4: "context.addRect(square)",
    5: "context.drawPath(using: .fill)",
    6: "let image = UIGraphicsGetImageFromCurrentImageContext()",
    7: "UIGraphicsEndImageContext()"

]
