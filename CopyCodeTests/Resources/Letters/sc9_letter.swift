//
//  sc9_letter.swift
//  CopyCodeTests
//
//  Created by Артем on 12/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

let sc9_letter = [
    0: "let nn = [1000, 1,  5, 2, 100, 0, 6]",
    1: "//let n = 2",
    2: "//nn[..<n]",
    3: "func msort(_ m: [Int]) -> [Int] {",
    4: "if m.count == 1 {",
    5: "return m",
    6: "}",
    7: "let mid = m.count / 2",
    8: "let leftSorted = msort(Array(m[..<mid]))",
    9: "let rightSorted = msort(Array(m[mid...]))",
    10: "var result = [Int]()",
    11: "var leftIndex = 0",
    12: "var rightIndex = 0",
    13: "for _ in (0...(m.count-1)) {",
    14: "if rightIndex == rightSorted.count || leftIndex != leftSorted.count && leftSorted[leftIndex] <=",
    15: "rightSorted[rightIndex] {",
    16: "result.append(leftSorted[leftIndex])",
    17: "leftIndex += 1",
    18: "} else {",
    19: "result.append(rightSorted[rightIndex])",
    20: "rightIndex += 1",
    21: "}",
    22: "return result",
    23: "}",
    24: "msort(nn)"
]
