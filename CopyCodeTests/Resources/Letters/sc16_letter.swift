//
//  sc16_letter.swift
//  CopyCodeTests
//
//  Created by Артем on 04/12/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

//на 6й линии там белый квадрат поэтому вконце делаяем символы
let sc16_letter = [
    0: "UIGraphicsBeginImageContextWithOptions(CGSizeMake(100, 100), FALSE, 0);",
    1: "CGRect square = CGRectMake(0, 0, 100, 100);",
    2: "CGContextRef context = UIGraphicsGetCurrentContext();",

    3: "CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);",
    4: "CGContextAddRect(context, square);",
    5: "CGContextDrawPath(context, kCGPathFill);",

    6: "UIImage *image = UIGraphicsGetImageFromCurrentImageContext(); _________",
    7: "UIGraphicsEndImageContext();"
]
