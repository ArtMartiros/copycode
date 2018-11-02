//
//  sc11_letter.swift
//  CopyCodeTests
//
//  Created by Артем on 17/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

let sc11_letter = [
    0: "class NonNegative:",
    1: "def __get__(self, instance, owner):",
    2: "return magically_get_value(...)",

    3: "def __set__(self, instance, value):",
    4: "assert value >= 0, \"non-negative value required\"",
    5: "magically_set_value(...)",

    6: "def __delete__(self, instance):",
    7: "magically_delete_value(...)"
]

//линия 0 последний символ : а не  ;
//линия 4 Z вместо r // v вместо t
let sc11_letter_low = [
    0: "class NonNegative;",
    1: "def __get__(self, instance, owner):",
    2: "return magically_get_value(...)",

    3: "def __set__(self, instance, value):",
    4: "asseZt value >= 0, \"non-negavive value required\"",
    5: "magically_set_value(...)",

    6: "def __delete__(self, instance):",
    7: "magically_delete_value(...)"
]
