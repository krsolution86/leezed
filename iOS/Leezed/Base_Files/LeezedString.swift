//
//  LeezedString.swift
//  Leezed
//
//  Created by Neha Gupta on 22/09/19.
//  Copyright © 2019 Shertech. All rights reserved.
//

import UIKit
import Foundation
import CommonCrypto

extension String  {
    
    static func getValidStringValue(string:String) -> String {
        var resultString = ""
        let updatedString:AnyObject = string as AnyObject
        if updatedString is NSNull{
            return resultString
        }
        if string.hasPrefix("\"") {
            resultString = string.replacingOccurrences(of: "\"", with: "")
        }
        else if updatedString is NSNumber{
            resultString = String((updatedString as? NSNumber)?.intValue ?? 0) 
            
        }
        else
        {
            resultString = string
        }
        return resultString
    }
    
    static func getValidStringValuefromNumber(userID:NSNumber) -> String {
        
        return userID.stringValue
    }
    
    static func isEmpty(str : String) -> Bool {
        if str.isEmpty {
            return true
        }
        if str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
            return true
        }
        if (str == "") {
            return true
        }
        return false
    }

    static func refineDateFormat(sourceFormat:String,destinationFormat:String,sourceString:String) -> String {
        
        var dateString = ""
        let sourceDateFormatter = DateFormatter()
        sourceDateFormatter.timeZone = NSTimeZone.system
        sourceDateFormatter.locale = Locale(identifier: "en_US")
        sourceDateFormatter.dateFormat=sourceFormat
        let sourceDate = sourceDateFormatter.date(from: sourceString)
        
        let destinationDateFormatter = DateFormatter()
        destinationDateFormatter.timeZone = NSTimeZone.system
        destinationDateFormatter.locale = Locale(identifier: "en_US")
        destinationDateFormatter.dateFormat=destinationFormat
        if sourceDate == nil {
            print("\n\n :::: WARNING: Date String return as: EMPTY  ::::\n\n")
            return dateString
        }
        let stringFromDate = destinationDateFormatter.string(from: sourceDate!)
        if stringFromDate.isEmpty {
            
        }else{
            dateString = stringFromDate
        }
        return dateString
    }
}
