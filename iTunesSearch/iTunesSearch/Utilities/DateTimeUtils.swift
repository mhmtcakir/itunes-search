//
//  DateTimeUtils.swift
//  iTunesSearch
//
//  Created by Mehmet Çakır on 18.07.2018.
//  Copyright © 2018 Mehmet Çakır. All rights reserved.
//

import Foundation

class DateTimeUtils {    
    var formatter:DateFormatter?
    let kResponseDateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    let kPrintDateFormat = "dd MMM yyyy"
    
    static let sharedInstance:DateTimeUtils = {
        let instance = DateTimeUtils()
        instance.formatter = DateFormatter()
        return instance
    }()
    
    func dateStringToFormattedString(dateString:String?) -> String {
        guard let dateString = dateString else {
            return ""
        }
        
        DateTimeUtils.sharedInstance.formatter?.dateFormat = kResponseDateFormat
        if let date = DateTimeUtils.sharedInstance.formatter?.date(from: dateString) {
            DateTimeUtils.sharedInstance.formatter?.dateFormat = kPrintDateFormat
            if let formattedDateString = DateTimeUtils.sharedInstance.formatter?.string(from: date) {
                return formattedDateString
            }
        }
        
        return ""
    }
}
