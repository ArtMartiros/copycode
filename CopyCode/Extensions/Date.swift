//
//  Date.swift
//  CopyCode
//
//  Created by Артем on 14/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

extension Date {
    var toString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "MSC") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: self)
        return strDate
    }
}
