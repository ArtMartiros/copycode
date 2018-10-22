//
//  Date.swift
//  CopyCode
//
//  Created by Артем on 14/10/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Foundation

extension Date {
    enum DateType: String {
        case yyyyMMddHHmm = "yyyy-MM-dd HH:mm"
        case yyyyMMdd = "yyyy-MM-dd"
        case HHmm = "HH:mm"
    }

    func toString(_ type: DateType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "MSC") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = type.rawValue //Specify your format that you want
        let strDate = dateFormatter.string(from: self)
        return strDate
    }
}
