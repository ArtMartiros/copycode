//
//  String.swift
//  CopyCode
//
//  Created by Артем on 16/09/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

extension String {
    func trimWhiteSpacesAtTheEnd()  -> String {
       return self.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
    }
}
