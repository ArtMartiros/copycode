//
//  Tree.swift
//  CopyCode
//
//  Created by Артем on 18/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

///Binary tree for complicated logic
enum Tree<Node, Result> {
    ///Empty result
    case empty
    ///Result with generic type
    case r(Result)
    ///Recursive case with generic tree
    indirect case n(Node, Tree<Node, Result>, Tree<Node, Result>)
}
