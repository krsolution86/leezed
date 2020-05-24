//
//  Constants.swift
//  Leezed
//
//  Created by Neha Gupta on 07/09/19.
//  Copyright © 2019 Shertech. All rights reserved.
//

import Foundation
import UIKit

let kBaseURL = "https://www.leezed.com/api/v1"
let kEmptyString = ""
let kErrorTitle = "Error"
let kUnauthorizedError = "Unauthorized Error"
let KMissingData = "Missing Data"
let KAlertOkButtonTitle = "Ok"

struct LeezedColors
{
    let kNavigationBarBackgroundColor = UIColor(red: 71.0/255.0, green: 144.0/255.0, blue: 210.0/255.0, alpha: 1.0)
    let kNavigationBarTitleFontColor = UIColor.white
    let kOrangeBaseColor = UIColor(red: 255.0/255.0, green: 156.0/255.0, blue: 22.0/255.0, alpha: 1.0)
    let kFontBlackBaseColor = UIColor(red: 28.0/255.0, green: 28.0/255.0, blue: 28.0/255.0, alpha: 1.0)
    let kBlackBaseColor = UIColor(red: 17.0/255.0, green: 17.0/255.0, blue: 17.0/255.0, alpha: 1.0)
    let kTitleLabelColor = UIColor(red: 227.0/255.0, green: 227.0/255.0, blue: 228.0/255.0, alpha: 1.0)
    let kTextFieldBackgroundColor = UIColor(red: 227.0/255.0, green: 227.0/255.0, blue: 228.0/255.0, alpha: 1.0)
    let popoverViewGradientColor = UIColor(red: 44.0/255.0, green: 57.0/255.0, blue: 74.0/255.0, alpha: 1.0)
}

struct LeezedFont {
    static func KBoulderFontWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: "BoulderCd", size: size)!
    }
    
    static func KGothicBoldFontWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: "CenturyGothic-Bold", size: size)!
    }
    
    static func KGothicRegularFontWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: "CenturyGothic", size: size)!
    }
}

class LeezedConstants
{
    static let retrieveConstants = LeezedConstants()
    private init(){}
    
    func applicationDocumentsDirectory() -> String {
        let filePath: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        return (filePath?.path)!
    }
}
