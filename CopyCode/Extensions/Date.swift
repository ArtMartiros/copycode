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
        case yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss"
        case yyyyMMddHHmm = "yyyy-MM-dd HH:mm"
        case yyyyMMdd = "yyyy-MM-dd"
        case HHmm = "HH:mm"
        case HHmmss = "HH:mm:ss"
    }

    func toString(_ type: DateType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "MSC") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = type.rawValue //Specify your format that you want
        let strDate = dateFormatter.string(from: self)
        return strDate
    }

    func current(_ component: Calendar.Component) -> Int {
        let component = Calendar.current.component(component, from: self)
        return component
    }

    func current(_ components: [Calendar.Component], separator: String) -> String {
        let result = components.map { "\(Calendar.current.component($0, from: self))" }.joined(separator: separator)
        return result
    }
}
