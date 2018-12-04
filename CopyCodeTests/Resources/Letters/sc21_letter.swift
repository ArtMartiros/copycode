//
//  sc21_letter.swift
//  CopyCodeTests
//
//  Created by Артем on 04/12/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation
//не зацепил первый
let sc21_letter = [
//    0: "// this:",
    0: "let constraint = view2.left == view1.left * 2.0 + 10.0 ~ 750",

    1: "// is equivalent to:",
    2: "let constraint = NSLayoutConstraint(item: view2,",
    3: "attribute: NSLayoutAttribute.Left,",
    4: "relatedBy: NSLayoutRelation.Equal,",
    5: "toItem: view1,",
    6: "attribute: NSLayoutAttribute.Left,",
    7: "multiplier: 2.0,",
    8: "constant: 10.0)",
    9: "constraint.priority = 750"
]
