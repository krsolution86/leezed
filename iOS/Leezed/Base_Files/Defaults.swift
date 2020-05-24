//
//  Defaults.swift
//  Leezed
//
//  Created by Neha Gupta on 18/09/19.
//  Copyright © 2019 Shertech. All rights reserved.
//

import UIKit
import SystemConfiguration
import MBProgressHUD
import JWTDecode
public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
}

class Defaults {
    
    static let retrieveDefaults = Defaults()
    private init(){}
    
    static let base64forDataTable = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
    
    func fetchCurrentTimestamp() -> String {
        let currentDate = Date()
        let timeZone = NSTimeZone(name: "UTC")
        // or specifc Timezone: with name
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en-US")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let timeZone = timeZone {
            dateFormatter.timeZone = timeZone as TimeZone
        }
        let DateString = dateFormatter.string(from: currentDate)
        return DateString
    }
    
    func getAuthToken() -> String {
        return UserDefaults.standard.string(forKey: "AuthToken") ?? ""
    }
    
    func setAuthToken(token: String) {
        UserDefaults.standard.set(token, forKey: "AuthToken")
        UserDefaults.standard.synchronize()
    }
    
    func setUserProfile(myDict : [String : Any]) -> Void
    {
        //archive
        if !(myDict.isEmpty){
            if myDict.keys.contains("isAdmin"){
              var dictUser = myDict
                dictUser.removeValue(forKey: "isAdmin")
                let data = NSKeyedArchiver.archivedData(withRootObject: dictUser)
                UserDefaults.standard.set(data, forKey: "UserProfile")
                    UserDefaults.standard.synchronize()
            }else{
        let data = NSKeyedArchiver.archivedData(withRootObject: myDict)
        UserDefaults.standard.set(data, forKey: "UserProfile")
            UserDefaults.standard.synchronize()
         }
        }
    }
    
    
    func getUserProfile() -> [String : Any] {
        
        //unarchive
        let newData = UserDefaults.standard.object(forKey: "UserProfile") as? Data
        var newDict = [String : Any]()
        if let newData = newData {
            newDict = NSKeyedUnarchiver.unarchiveObject(with: newData) as! [String : Any]
        }

        return newDict
    }
    
    func getPostalCode() -> String {
        return UserDefaults.standard.string(forKey: "PostalCode") ?? ""
    }
    
    func setPostalCode(code: String) {
        UserDefaults.standard.set(code, forKey: "PostalCode")
        UserDefaults.standard.synchronize()
    }
    
    func getLocationName() -> String {
        return UserDefaults.standard.string(forKey: "LocationName") ?? ""
    }
    
    func setLocationName(locationName: String) {
        UserDefaults.standard.set(locationName, forKey: "LocationName")
        UserDefaults.standard.synchronize()
    }
    
    func isUserLocationSet(isLocationSet: Bool) {
        UserDefaults.standard.set(isLocationSet, forKey: "isLocationSet")
        UserDefaults.standard.synchronize()
    }
    
    func isUserLocationSet() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLocationSet")
    }
    
    func decodeJWTToken(_ token: String) -> [String: AnyObject]? {
        let dict = [String : AnyObject]()
        do{
            let jwt = try decode(jwt: token)
            print(jwt)
            return jwt.body as [String : AnyObject]
        }catch{
            print("Failed to decode JWT: \(error)")
            return dict
        }
        /*
        let string = token.components(separatedBy: ".")
        let toDecode = string[0] as String
        
        
        var stringtoDecode: String = toDecode.replacingOccurrences(of: "-", with: "+") // 62nd char of encoding
        stringtoDecode = stringtoDecode.replacingOccurrences(of: "_", with: "/") // 63rd char of encoding
        switch (stringtoDecode.utf16.count % 4) {
        case 2: stringtoDecode = "\(stringtoDecode)=="
        case 3: stringtoDecode = "\(stringtoDecode)="
        default: // nothing to do stringtoDecode can stay the same
            print("")
        }
        let dataToDecode = Data(base64Encoded: stringtoDecode, options: [])
        let base64DecodedString = NSString(data: dataToDecode!, encoding: String.Encoding.utf8.rawValue)
        
        var values: [String: AnyObject]?
        if let string = base64DecodedString {
            if let data = string.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: true) {
                values = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject]
            }
        }*/
        //return jwt
    }
}

extension UIViewController {
    func showHUD()
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    func hideHUD()  {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func showAlert(withTitle title: String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
            print("You've pressed OK Button")
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showConfirmationAlert(alertTitle:String,alertMessage:String,actionsArray:[UIAlertAction])
    {
        self.view.endEditing(true)
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        for action in actionsArray
        {
            alertController.addAction(action)
        }
        self.present(alertController, animated: true, completion: nil)
    }    
    
//    func showConfirmationAlert(alertTitle: String?, andMessage alertMessage: String?, andActions actionsArray: [AnyHashable]?, with
//
//        viewController: UIViewController?) {
//
//        var actionsArray = actionsArray
//
//        UIView.animate(withDuration: 0, animations: {
//            viewController?.view.endEditing(true)
//
//        }) { finished in
//            let alert = UIAlertController(title: NSLocalizedString(alertTitle ?? "", comment: ""), message: NSLocalizedString(alertMessage ?? "", comment: ""), preferredStyle: .alert)
//            for i in 0..<(actionsArray?.count ?? 0) {
//                if let object = actionsArray?[i] as? UIAlertAction {
//                    alert.addAction(object)
//                }
//            }
//            viewController?.present(alert, animated: true)
//        }
//
//    }
    
//    func showGradiendView()
//    {
//        let gradientView = UIView(frame: (self.navigationController?.view.bounds)!)
//        gradientView.backgroundColor = SalesWorxColors().popoverViewGradientColor
//        gradientView.layer.opacity = 0.5
//        //self.view.addSubview(gradientView)
//        self.navigationController?.view.addSubview(gradientView)
//    }
//    func hideGradientView()
//    {
//
//    }
    
}

extension UIImageView {
    func downloadImageFrom(link:String, contentMode: UIView.ContentMode) {
        
        if self.image != nil {
            self.alpha = 1
            return
        }
        self.alpha = 0
        let urlString = link.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        let url = URL(string: urlString)!
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                return
            }

            if let response = response as? HTTPURLResponse {
                if response.statusCode / 100 != 2 {
                    return
                }
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.contentMode = contentMode
                        self.image = image
                        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                            self.alpha = 1
                        }, completion: { (finished: Bool) -> Void in
                        })
                    })
                }
            }
        }
        task.resume()
    }
}

extension Int {
    static func parse(from string: String) -> Int {
        return Int(string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) ?? 1
    }
}
