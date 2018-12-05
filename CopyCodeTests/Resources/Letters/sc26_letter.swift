//
//  sc26_letter.swift
//  CopyCodeTests
//
//  Created by Артем on 05/12/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

let sc26_letter = [
    0: "char letter;",
    1: "ifstream reader(\"stevequote.txt\");",
    2: "if(! reader){",
    3: "cout << \"Error opening file\" << endl;",
    4: "return -1;",
    5: "} else {",
    6: "for(int i = 0; ! reader.eof(); i++){",
    7: "reader.get(letter);",
    8: "cout",
    9: "}",
]
