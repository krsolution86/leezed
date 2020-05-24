//
//  NetworkManager.swift
//  Leezed
//
//  Created by Neha Gupta on 18/09/19.
//  Copyright © 2019 Shertech. All rights reserved.
//

import UIKit
import Alamofire

class NetworkManager {
    
    static let retrieveManager = NetworkManager()
    private init(){}
    let appdel = UIApplication.shared.delegate as? AppDelegate
    
    
    func LoadLoginView(){
        
        self.appdel?.LoadMenuWithoutLogin()
        
        
    }
    func getSearchProduct(_ lat: String, long: String, completion: @escaping ([Products], Error?) -> ()) {
        
        var arrProducts = [Products]()
        let urlPath = kBaseURL + "/products/searchProducts?searchTerms=&lat=\(lat)&lon=\(long)"
        print(urlPath)
        
        guard let url = URL(string: urlPath) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] {
                    let results = jsonResult["products"] as! [[String: Any]]
                    print(results)
                    
                    for i in 0..<results.count{
                        let objDict = results[i]
                        
                        var productID = 0
                        if let val = objDict["productID"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            productID = val as? Int ?? 0
                        }
                        
                        var newuserID = 0
                        if let val = objDict["ownerID"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            newuserID = val as? Int ?? 0
                        }
                        var ownername = "N/A"
                        if let val = objDict["ownerName"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            ownername = String.getValidStringValue(string: val as? String ?? "")
                        }
                        
                        var name = "N/A"
                        if let val = objDict["productName"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            name = String.getValidStringValue(string: val as? String ?? "")
                        }
                        
                        var description = "N/A"
                        if let val = objDict["productDesc"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            description = String.getValidStringValue(string: val as? String ?? "")
                        }
                        
                        var officialUrl = "N/A"
                        if let val = objDict["officalUrl"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            officialUrl = String.getValidStringValue(string: val as? String ?? "")
                        }
                        
                        var thumbnailUrl = "N/A"
                        if let val = objDict["thumbnailUrl"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            thumbnailUrl = String.getValidStringValue(string: val as? String ?? "")
                        }
                        
                        var category = "N/A"
                        if let val = objDict["categoryName"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            category = String.getValidStringValue(string: val as? String ?? "")
                        }
                        
                        var location = "N/A"
                        if let val = objDict["location"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            location = String.getValidStringValue(string: val as? String ?? "")
                        }
                        
                        var availableFromDate = "N/A"
                        if let val = objDict["availableFromDate"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            availableFromDate = String.getValidStringValue(string: val as? String ?? "")
                        }
                        
                        var availableToDate = "N/A"
                        if let val = objDict["availableToDate"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            availableToDate = String.getValidStringValue(string: val as? String ?? "")
                        }
                        
                        var activeInd = 0
                        if let val = objDict["activeInd"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            activeInd = val as? Int ?? 0
                        }
                        
                        var categoryID = "N/A"
                        if let val = objDict["categoryID"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            categoryID = String.getValidStringValue(string: val as? String ?? "")
                        }
                        
                        var rentPrice = 0.0
                        if let val = objDict["rentPrice"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            rentPrice = Double(val as? Float ?? 0.0)
                        }
                        
                        var minRental = 0.0
                        if let val = objDict["minRental"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            minRental = Double(val as? Float ?? 0.0)
                        }
                        
                        var durationUnit = "N/A"
                        if let val = objDict["durationUnit"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            durationUnit = String.getValidStringValue(string: val as? String ?? "")
                        }
                        
                        var durationUnitDesc = "N/A"
                        if let val = objDict["durationUnitDesc"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            durationUnitDesc = String.getValidStringValue(string: val as? String ?? "")
                        }
                        
                        var zipCode = 0
                        if let val = objDict["zipCode"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            zipCode = val as? Int ?? 0
                        }
                        
                        var imageURL = [String]()
                        if let value = objDict["imageUrls"]{
                            let arr = [(value as? String ?? "") .components(separatedBy: ",")]
                            imageURL = arr[0]
                        }
                        
                        let objProducts = Products(productID: productID, name: name, description: description, officialUrl: officialUrl, thumbnailUrl: thumbnailUrl, category: category, location: location, availableFromDate: availableFromDate, availableToDate: availableToDate, activeInd: activeInd, categoryID: categoryID, rentPrice: rentPrice, minRental: minRental, durationUnit: durationUnit, durationUnitDesc:durationUnitDesc, zipCode: zipCode,userID: newuserID,userName: ownername,imageURLS: imageURL)
                        
                        arrProducts.append(objProducts)
                    }
                    completion(arrProducts, nil)
                }
            } catch {
                completion(arrProducts, error)
                //Catch Error here...
            }
        }
        task.resume()
    }
    
    func searchRecentProducts(completion: @escaping ([Products], Error?) -> ()) {
        
        var arrProducts = [Products]()
        let urlPath = kBaseURL + "/products/searchRecentProducts"
        print(urlPath)
        
        guard let url = URL(string: urlPath) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] {
                    let results = jsonResult["products"] as! [[String: Any]]
                    print(results)
                    
                    for i in 0..<results.count{
                        let objDict = results[i]
                        
                        var productID = 0
                        if let val = objDict["productID"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            productID = val as? Int ?? 0
                        }
                        var newuserID = 0
                        if let val = objDict["ownerID"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            newuserID = val as? Int ?? 0
                        }
                        var ownername = "N/A"
                        if let val = objDict["ownerName"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            ownername = String.getValidStringValue(string: val as? String ?? "")
                        }
                        
                        var name = "N/A"
                        if let val = objDict["productName"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            name = String.getValidStringValue(string: val as? String ?? "")
                        }
                        
                        var description = "N/A"
                        if let val = objDict["productDesc"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            description = String.getValidStringValue(string: val as? String ?? "")
                        }
                        
                        var officialUrl = "N/A"
                        if let val = objDict["officalUrl"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            officialUrl = String.getValidStringValue(string: val as? String ?? "")
                        }
                        
                        var thumbnailUrl = "N/A"
                        if let val = objDict["thumbnailUrl"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            thumbnailUrl = String.getValidStringValue(string: val as? String ?? "")
                        }
                        
                        var category = "N/A"
                        if let val = objDict["categoryName"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            category = String.getValidStringValue(string: val as? String ?? "")
                        }
                        
                        var location = "N/A"
                        if let val = objDict["location"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            location = String.getValidStringValue(string: val as? String ?? "")
                        }
                        
                        var availableFromDate = "N/A"
                        if let val = objDict["availableFromDate"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            availableFromDate = String.getValidStringValue(string: val as? String ?? "")
                        }
                        
                        var availableToDate = "N/A"
                        if let val = objDict["availableToDate"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            availableToDate = String.getValidStringValue(string: val as? String ?? "")
                        }
                        
                        var activeInd = 0
                        if let val = objDict["activeInd"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            activeInd = val as? Int ?? 0
                        }
                        
                        var categoryID = "N/A"
                        if let val = objDict["categoryID"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            categoryID = String.getValidStringValue(string: val as? String ?? "")
                        }
                        
                        var rentPrice = 0.0
                        if let val = objDict["rentPrice"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            rentPrice = val as? Double ?? 0.0
                        }
                        
                        var minRental = 0.0
                        if let val = objDict["minRental"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            minRental = val as? Double ?? 0.0
                        }
                        
                        var durationUnit = "N/A"
                        if let val = objDict["durationUnit"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            durationUnit = String.getValidStringValue(string: val as? String ?? "")
                        }
                        
                        var durationUnitDesc = "N/A"
                        if let val = objDict["durationUnitDesc"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            durationUnitDesc = String.getValidStringValue(string: val as? String ?? "")
                        }
                        
                        var zipCode = 0
                        if let val = objDict["zipCode"] {
                            // now val is not nil and the Optional has been unwrapped, so use it
                            zipCode = val as? Int ?? 0
                        }
                        var imageURL = [String]()
                        if let value = objDict["imageUrls"]{
                           let arr = [(value as? String ?? "") .components(separatedBy: ",")]
                            imageURL = arr[0] 
                        }
                        
                        let objProducts = Products(productID: productID, name: name, description: description, officialUrl: officialUrl, thumbnailUrl: thumbnailUrl, category: category, location: location, availableFromDate: availableFromDate, availableToDate: availableToDate, activeInd: activeInd, categoryID: categoryID, rentPrice: rentPrice, minRental: minRental, durationUnit: durationUnit, durationUnitDesc:durationUnitDesc, zipCode: zipCode,userID: newuserID,userName: ownername,imageURLS: imageURL)
                        
                        arrProducts.append(objProducts)
                    }
                    completion(arrProducts, nil)
                }
            } catch {
                completion(arrProducts, error)
                //Catch Error here...
            }
        }
        task.resume()
    }
    
    func postSignUp(signUpObject:SignUp, completion: @escaping ([String: Any], Error?) -> ()) {
        
        let urlPath = kBaseURL + "/users/signup"
        print(urlPath)

        guard let url = URL(string: urlPath) else { return }

        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        let signUpDict: [String: Any] = ["email": signUpObject.UserEmail, "password": signUpObject.Password, "screenName": signUpObject.ScreenName,"name":"","phone":"", "disclaimerStatus": "true"]
        let jsonData: Data
        do {
            jsonData = try JSONSerialization.data(withJSONObject: signUpDict, options: [])
            urlRequest.httpBody = jsonData
        } catch {
            print("Error: cannot create JSON from signUpDict")
            return
        }

        let session = URLSession.shared

        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST on signUpDict")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }

            // parse the result as JSON, since that's what the API provides
            do {
                guard let jsonResult = try JSONSerialization.jsonObject(with: responseData,
                                                                          options: .allowFragments) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
                print("The signUpDict result is: " + jsonResult.description)
                completion(jsonResult, nil)
            } catch  {
                print("error parsing response from POST on signUpDict")
                completion([String: Any](), error)
                return
            }
        }
        task.resume()
    }
    
    func postSignIn(signInDict:[String: Any], completion: @escaping ([String: Any], Error?) -> ()) {
        
        let urlPath = kBaseURL + "/users/signin"
        print(urlPath)
        
        guard let url = URL(string: urlPath) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        let jsonData: Data
        do {
            jsonData = try JSONSerialization.data(withJSONObject: signInDict, options: [])
            urlRequest.httpBody = jsonData
        } catch {
            print("Error: cannot create JSON from signInDict")
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST on signInDict")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let jsonResult = try JSONSerialization.jsonObject(with: responseData,
                                                                        options: .allowFragments) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
                print("The signInDict result is: " + jsonResult.description)
                completion(jsonResult, nil)
            } catch  {
                print("error parsing response from POST on signInDict")
                completion([String: Any](), error)
                return
            }
        }
        task.resume()
    }
    
    func LoginViaFB(FacebookToken:[String: Any], completion: @escaping ([String: Any], Error?) -> ()) {
        
        let urlPath = kBaseURL + "/users/facebook"
        print(urlPath)
        
        guard let url = URL(string: urlPath) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        let jsonData: Data
        do {
            jsonData = try JSONSerialization.data(withJSONObject: FacebookToken, options: [])
            urlRequest.httpBody = jsonData
        } catch {
            print("Error: cannot create JSON from signInDict")
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST on signInDict")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                let temp = String(decoding: responseData, as: UTF8.self)
                print(temp)
                guard let jsonResult = try JSONSerialization.jsonObject(with: responseData,
                                                                        options: .allowFragments) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
                print("The signInDict result is: " + jsonResult.description)
                completion(jsonResult, nil)
            } catch  {
                print("error parsing response from POST on signInDict")
                completion([String: Any](), error)
                return
            }
        }
        task.resume()
    }
    
    //orders/fetchChatHistory?orderID=1069
    
    
    
    func getmessageFromOrder(orderID : String,_ completion: @escaping ([String: Any], Error?) -> ()) {
        let urlPath = kBaseURL + "/orders/fetchChatHistory?orderID=\(orderID)"
        print(urlPath)
        
        guard let url = URL(string: urlPath) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(Defaults.retrieveDefaults.getAuthToken())", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "GET"
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling GET on getUserProfile")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let jsonResult = try JSONSerialization.jsonObject(with: responseData,
                                                                        options: .allowFragments) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            completion([String: Any](), error)
                                                                            return
                }
                print("The getUserProfile result is: " + jsonResult.description)
                
                
                
                completion(jsonResult, nil)
            } catch  {
                print("error parsing response from GET on getUserProfile")
                completion([String: Any](), error)
                return
            }
        }
        task.resume()
    }
    
    ///orders/sendMessage
    
    func PostMessge(placeRentDict:[String: Any], completion: @escaping ([String: Any], Error?) -> ()) {
           
           let urlPath = kBaseURL + "/orders/sendMessage"
           print(urlPath)
           
           guard let url = URL(string: urlPath) else { return }
           
           var urlRequest = URLRequest(url: url)
           urlRequest.setValue("Bearer \(Defaults.retrieveDefaults.getAuthToken())", forHTTPHeaderField: "Authorization")
           urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
           urlRequest.httpMethod = "POST"
           let jsonData: Data
           do {
               jsonData = try JSONSerialization.data(withJSONObject: placeRentDict, options: [])
               urlRequest.httpBody = jsonData
           } catch {
               print("Error: cannot create JSON from placeRentDict")
               return
           }
           
           let session = URLSession.shared
           
           let task = session.dataTask(with: urlRequest) {
               (data, response, error) in
               guard error == nil else {
                   print("error calling POST on placeRentDict")
                   print(error!)
                   return
               }
               guard let responseData = data else {
                   print("Error: did not receive data")
                   return
               }
               
               // parse the result as JSON, since that's what the API provides
               do {
                   guard let jsonResult = try JSONSerialization.jsonObject(with: responseData,
                                                                           options: .allowFragments) as? [String: Any] else {
                                                                               print("Could not get JSON from responseData as dictionary")
                                                                               return
                   }
                   print("The placeRentDict result is: " + jsonResult.description)
                   completion(jsonResult, nil)
               } catch  {
                   print("error parsing response from POST on placeRentDict")
                   completion([String: Any](), error)
                   return
               }
           }
           task.resume()
       }
    
    
    func getUserProfile(userID: String,_ completion: @escaping ([String: Any], Error?) -> ()) {
        let urlPath = kBaseURL + "/users/getByIdUser?userID=\(userID)"
        print(urlPath)
        
        guard let url = URL(string: urlPath) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(Defaults.retrieveDefaults.getAuthToken())", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "GET"
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling GET on getUserProfile")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let jsonResult = try JSONSerialization.jsonObject(with: responseData,
                                                                        options: .allowFragments) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            completion([String: Any](), error)
                                                                            return
                }
                print("The getUserProfile result is: " + jsonResult.description)
                
                var userDict = [String: Any]()
                
                userDict["userID"] = String.getValidStringValuefromNumber(userID: jsonResult["userID"] as? NSNumber ?? 0)
                userDict["name"] = String.getValidStringValue(string: jsonResult["name"] as? String ?? "")
                userDict["email"] = String.getValidStringValue(string: jsonResult["email"] as? String ?? "")
                userDict["isAdmin"] = String.getValidStringValue(string: jsonResult["isAdmin"] as? String ?? "")
                userDict["phone"] = String.getValidStringValue(string: jsonResult["phone"] as? String ?? "")
                userDict["screenName"] = String.getValidStringValue(string: jsonResult["screenName"] as? String ?? "")
                
                completion(userDict, nil)
            } catch  {
                print("error parsing response from GET on getUserProfile")
                completion([String: Any](), error)
                return
            }
        }
        task.resume()
    }
    
    func placeRentRequest(placeRentDict:[String: Any], completion: @escaping ([String: Any], Error?) -> ()) {
        
        let urlPath = kBaseURL + "/orders/placeRentRequest"
        print(urlPath)
        
        guard let url = URL(string: urlPath) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(Defaults.retrieveDefaults.getAuthToken())", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        let jsonData: Data
        do {
            jsonData = try JSONSerialization.data(withJSONObject: placeRentDict, options: [])
            urlRequest.httpBody = jsonData
        } catch {
            print("Error: cannot create JSON from placeRentDict")
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST on placeRentDict")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let jsonResult = try JSONSerialization.jsonObject(with: responseData,
                                                                        options: .allowFragments) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
                print("The placeRentDict result is: " + jsonResult.description)
                completion(jsonResult, nil)
            } catch  {
                print("error parsing response from POST on placeRentDict")
                completion([String: Any](), error)
                return
            }
        }
        task.resume()
    }
    
    
    
    
    /*
     https://www.leezed.com/api/v1/users/updateProfile
     {email: "abhishekdxt3@gmail.com"screenName: "testUser"phone: "9179821599"name: "testUser1"}
     
     */
    
    
    
    func SubmitProfileRequest(profileDict:[String: Any], completion: @escaping ([String: Any], Error?) -> ()) {
        
        let urlPath = kBaseURL + "/users/updateProfile"
        print(urlPath)
        
        guard let url = URL(string: urlPath) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(Defaults.retrieveDefaults.getAuthToken())", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        let jsonData: Data
        do {
            jsonData = try JSONSerialization.data(withJSONObject: profileDict, options: [])
            urlRequest.httpBody = jsonData
        } catch {
            print("Error: cannot create JSON from placeRentDict")
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST on placeRentDict")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let jsonResult = try JSONSerialization.jsonObject(with: responseData,
                                                                        options: .allowFragments) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
                print("The placeRentDict result is: " + jsonResult.description)
                completion(jsonResult, nil)
            } catch  {
                print("error parsing response from POST on placeRentDict")
                completion([String: Any](), error)
                return
            }
        }
        task.resume()
    }
    
    
    
    func getCategories(_ completion: @escaping ([String: Any], Error?) -> ()) {
        
        let urlPath = kBaseURL + "/common/getCategories"
        print(urlPath)
        
        guard let url = URL(string: urlPath) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(Defaults.retrieveDefaults.getAuthToken())", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "GET"
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling GET on getCategories")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let jsonResult = try JSONSerialization.jsonObject(with: responseData,
                                                                        options: .allowFragments) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            completion([String: Any](), error)
                                                                            return
                }
                print("The getCategories result is: " + jsonResult.description)
                
                completion(jsonResult, nil)
            } catch  {
                print("error parsing response from GET on getCategories")
                completion([String: Any](), error)
                return
            }
        }
        task.resume()
    }
    
    func addProductRequest(addProductDict:[String: Any], completion: @escaping ([String: Any], Error?) -> ()) {
        
        let urlPath = kBaseURL + "/products/create"
        print(urlPath)
        
        guard let url = URL(string: urlPath) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(Defaults.retrieveDefaults.getAuthToken())", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        let jsonData: Data
        do {
            jsonData = try JSONSerialization.data(withJSONObject: addProductDict, options: [])
            urlRequest.httpBody = jsonData
        } catch {
            print("Error: cannot create JSON from addProductDict")
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST on addProductDict")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let jsonResult = try JSONSerialization.jsonObject(with: responseData,
                                                                        options: .allowFragments) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
                print("The addProductDict result is: " + jsonResult.description)
                completion(jsonResult, nil)
            } catch  {
                print("error parsing response from POST on addProductDict")
                completion([String: Any](), error)
                return
            }
        }
        task.resume()
    }
    
    
    
    func updateProductRequest(addProductDict:[String: Any], completion: @escaping ([String: Any], Error?) -> ()) {
        
        let urlPath = kBaseURL + "/products/update"
        print(urlPath)
        
        guard let url = URL(string: urlPath) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(Defaults.retrieveDefaults.getAuthToken())", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        let jsonData: Data
        do {
            jsonData = try JSONSerialization.data(withJSONObject: addProductDict, options: [])
            urlRequest.httpBody = jsonData
        } catch {
            print("Error: cannot create JSON from addProductDict")
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST on addProductDict")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let jsonResult = try JSONSerialization.jsonObject(with: responseData,
                                                                        options: .allowFragments) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
                print("The addProductDict result is: " + jsonResult.description)
                completion(jsonResult, nil)
            } catch  {
                print("error parsing response from POST on addProductDict")
                completion([String: Any](), error)
                return
            }
        }
        task.resume()
    }
    
    func getMyProductList(_ completion: @escaping ([MyproductItem], Error?) -> ()) {
        
        var arrProducts = [MyproductItem]()
        let urlPath = kBaseURL + "/products/getMyItems"
        print(urlPath)
        
        guard let url = URL(string: urlPath) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(Defaults.retrieveDefaults.getAuthToken())", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "GET"
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling GET on getMyOrderList")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let jsonResult = try JSONSerialization.jsonObject(with: responseData,
                                                                        options: .allowFragments) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            completion(arrProducts, error)
                                                                            return
                }
                print("The getMyOrderList result is: " + jsonResult.description)
                
                let results = jsonResult["myItems"] as! [[String: Any]]
                print(results)
                
                for i in 0..<results.count{
                    let objDict = results[i]
                    
                    var availableFromDate = "N/A"
                    if let val = objDict["availableFromDate"] {
                        // now val is not nil and the Optional has been unwrapped, so use it
                        availableFromDate = String.getValidStringValue(string: val as? String ?? "")
                    }
                    
                    var availableToDate = "N/A"
                    if let val = objDict["availableToDate"] {
                        // now val is not nil and the Optional has been unwrapped, so use it
                        availableToDate = String.getValidStringValue(string: val as? String ?? "")
                    }
                    
                    var categoryID = 0
                    if let val = objDict["categoryID"] {
                        // now val is not nil and the Optional has been unwrapped, so use it
                        categoryID = val as?Int ?? 0
                    }
                    
                    var categoryName = "N/A"
                    if let val = objDict["categoryName"] {
                        // now val is not nil and the Optional has been unwrapped, so use it
                        categoryName = String.getValidStringValue(string: val as? String ?? "")
                    }
                    
                    var durationUnit = "N/A"
                    if let val = objDict["durationUnit"] {
                        // now val is not nil and the Optional has been unwrapped, so use it
                        durationUnit = String.getValidStringValue(string: val as? String ?? "")
                    }
                    
                    var durationUnitDesc = "N/A"
                    if let val = objDict["durationUnitDesc"] {
                        // now val is not nil and the Optional has been unwrapped, so use it
                        durationUnitDesc = String.getValidStringValue(string: val as? String ?? "")
                    }
                    
                    var location = "N/A"
                    if let val = objDict["location"] {
                        // now val is not nil and the Optional has been unwrapped, so use it
                        location = String.getValidStringValue(string: val as? String ?? "")
                    }
                    
                    var minRental = 0.0
                    if let val = objDict["minRental"] {
                        // now val is not nil and the Optional has been unwrapped, so use it
                        minRental = val as? Double ?? 0.0
                    }
                    
                    var name = "N/A"
                    if let val = objDict["name"] {
                        // now val is not nil and the Optional has been unwrapped, so use it
                        name = String.getValidStringValue(string: val as? String ?? "None")
                    }
                    
                    var pickupInstructions = "N/A"
                    if let val = objDict["pickupInstructions"] {
                        // now val is not nil and the Optional has been unwrapped, so use it
                        pickupInstructions = String.getValidStringValue(string: val as? String ?? "None")
                    }
                    
                    var productDesc = "N/A"
                    if let val = objDict["productDesc"] {
                        // now val is not nil and the Optional has been unwrapped, so use it
                        productDesc = String.getValidStringValue(string: val as? String ?? "None")
                    }
                    
                    var productID = 0
                    if let val = objDict["productID"] {
                        // now val is not nil and the Optional has been unwrapped, so use it
                        productID = val as? Int ?? 0
                    }
                    
                    var rentPrice = 0.0
                    if let val = objDict["rentPrice"] {
                        // now val is not nil and the Optional has been unwrapped, so use it
                        rentPrice = val as? Double ?? 0.0
                    }
                    
                    var thumbnailUrl = "N/A"
                    if let val = objDict["thumbnailUrl"] {
                        // now val is not nil and the Optional has been unwrapped, so use it
                        thumbnailUrl = String.getValidStringValue(string: val as? String ?? "")
                    }
                    
                    var username = "N/A"
                    if let val = objDict["username"] {
                        // now val is not nil and the Optional has been unwrapped, so use it
                        username = String.getValidStringValue(string: val as? String ?? "")
                    }
                    
                    var zipCode = ""
                    if let val = objDict["zipCode"] {
                        // now val is not nil and the Optional has been unwrapped, so use it
                        zipCode = val as? String ?? ""
                    }
                    
                    
                    let objProducts = MyproductItem(availableFromDate: availableFromDate, availableToDate: availableToDate, categoryID: categoryID, categoryName: categoryName, durationUnit: durationUnit, durationUnitDesc: durationUnitDesc, location: location, minRental: minRental, name: name, pickupInstructions: pickupInstructions, productDesc: productDesc, productID: productID, rentPrice: rentPrice, thumbnailUrl: thumbnailUrl, username: username, zipCode: zipCode)
                    
                    arrProducts.append(objProducts)
                }
                completion(arrProducts, nil)
            } catch  {
                print("error parsing response from GET on getMyOrderList")
                completion(arrProducts, error)
                return
            }
        }
        task.resume()
    }
    
    
    
    
    
    
    
    func getMyOrderList(_ completion: @escaping ([OrderList], Error?) -> ()) {
        
        var arrProducts = [OrderList]()
        let urlPath = kBaseURL + "/orders/getMyOrders"
        print(urlPath)
        
        guard let url = URL(string: urlPath) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(Defaults.retrieveDefaults.getAuthToken())", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "GET"
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling GET on getMyOrderList")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let jsonResult = try JSONSerialization.jsonObject(with: responseData,
                                                                        options: .allowFragments) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            completion(arrProducts, error)
                                                                            return
                }
                print("The getMyOrderList result is: " + jsonResult.description)
                
                let results = jsonResult["myOrders"] as! [[String: Any]]
                print(results)
                
                for i in 0..<results.count{
                    let objDict = results[i]
                    
                    var orderID = 0
                    if let val = objDict["orderID"] {
                        // now val is not nil and the Optional has been unwrapped, so use it
                        orderID = val as? Int ?? 0
                    }
                    
                    var productID = 0
                    if let val = objDict["productID"] {
                        // now val is not nil and the Optional has been unwrapped, so use it
                        productID = val as? Int ?? 0
                    }
                    
                    var productName = "N/A"
                    if let val = objDict["productName"] {
                        // now val is not nil and the Optional has been unwrapped, so use it
                        productName = String.getValidStringValue(string: val as? String ?? "")
                    }
                    
                    var rentedFrom = "N/A"
                    if let val = objDict["rentedFrom"] {
                        // now val is not nil and the Optional has been unwrapped, so use it
                        rentedFrom = String.getValidStringValue(string: val as? String ?? "")
                    }
                    
                    var rentedFromUserID = 0
                    if let val = objDict["rentedFromUserID"] {
                        // now val is not nil and the Optional has been unwrapped, so use it
                        rentedFromUserID = val as? Int ?? 0
                    }
                    
                    var isApproved = 0
                    if let val = objDict["isApproved"] {
                        // now val is not nil and the Optional has been unwrapped, so use it
                        isApproved = val as? Int ?? 0
                    }
                    
                    var approvalComments = "N/A"
                    if let val = objDict["approvalComments"] {
                        // now val is not nil and the Optional has been unwrapped, so use it
                        approvalComments = String.getValidStringValue(string: val as? String ?? "None")
                    }
                    
                    var userID = 0
                    if let val = objDict["userID"] {
                        // now val is not nil and the Optional has been unwrapped, so use it
                        userID = val as? Int ?? 0
                    }
                    
                    var ownerName = "N/A"
                    if let val = objDict["ownerName"] {
                        // now val is not nil and the Optional has been unwrapped, so use it
                        ownerName = String.getValidStringValue(string: val as? String ?? "")
                    }
                    
                    var requestedBy = "N/A"
                    if let val = objDict["requestedBy"] {
                        // now val is not nil and the Optional has been unwrapped, so use it
                        requestedBy = String.getValidStringValue(string: val as? String ?? "")
                    }
                    
                    var rentPrice = 0
                    if let val = objDict["rentPrice"] {
                        // now val is not nil and the Optional has been unwrapped, so use it
                        rentPrice = val as? Int ?? 0
                    }
                    
                    var discounts = 0
                    if let val = objDict["discounts"] {
                        // now val is not nil and the Optional has been unwrapped, so use it
                        discounts = val as? Int ?? 0
                    }
                    
                    var rentalStartDate = "N/A"
                    if let val = objDict["rentalStartDate"] {
                        // now val is not nil and the Optional has been unwrapped, so use it
                        rentalStartDate = String.getValidStringValue(string: val as? String ?? "")
                    }
                    
                    var rentalEndDate = "N/A"
                    if let val = objDict["rentalEndDate"] {
                        // now val is not nil and the Optional has been unwrapped, so use it
                        rentalEndDate = String.getValidStringValue(string: val as? String ?? "")
                    }
                    
                    var pickupInstructions = "N/A"
                    if let val = objDict["pickupInstructions"] {
                        // now val is not nil and the Optional has been unwrapped, so use it
                        pickupInstructions = String.getValidStringValue(string: val as? String ?? "")
                    }
                    
                    var location = "N/A"
                    if let val = objDict["location"] {
                        // now val is not nil and the Optional has been unwrapped, so use it
                        location = String.getValidStringValue(string: val as? String ?? "")
                    }
                    
                    let objProducts = OrderList(orderID: orderID, productID: productID, productName: productName, rentedFrom: rentedFrom, rentedFromUserID: rentedFromUserID, isApproved: isApproved, approvalComments: approvalComments, userID: userID, ownerName: ownerName, requestedBy: requestedBy, rentPrice: rentPrice, discounts: discounts, rentalStartDate: rentalStartDate, rentalEndDate: rentalEndDate, pickupInstructions: pickupInstructions, location: location)
                    
                    arrProducts.append(objProducts)
                }
                completion(arrProducts, nil)
            } catch  {
                print("error parsing response from GET on getMyOrderList")
                completion(arrProducts, error)
                return
            }
        }
        task.resume()
    }
    
    func ForgotPassword(resetPasswordDict:[String: Any], completion: @escaping ([String: Any], Error?) -> ()) {
        
        let urlPath = kBaseURL + "/users/sendPwdResetEmail"
        print(urlPath)
    
        guard let url = URL(string: urlPath) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        let jsonData: Data
        do {
            jsonData = try JSONSerialization.data(withJSONObject: resetPasswordDict, options: [])
            urlRequest.httpBody = jsonData
        } catch {
            print("Error: cannot create JSON from resetPasswordDict")
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST on resetPasswordDict")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let jsonResult = try JSONSerialization.jsonObject(with: responseData,
                                                                        options: .allowFragments) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
                print("The resetPasswordDict result is: " + jsonResult.description)
                completion(jsonResult, nil)
            } catch  {
                print("error parsing response from POST on resetPasswordDict")
                completion([String: Any](), error)
                return
            }
        }
        task.resume()
    }
    
    func addProductImages(Productimages:[UIImage],param: [String : String], completion: @escaping ([String: Any], Error?) -> ()) {
        let urlPath = kBaseURL + "/images/upload"
        print(urlPath)
    let headers: HTTPHeaders = [
        /* "Authorization": "your_access_token",  in case you need authorization header */
        "Content-type": "application/json",
        "Authorization": "Bearer \(Defaults.retrieveDefaults.getAuthToken())"
    ]
       AF.upload(multipartFormData: { (multipartFormData) in

           for (key, value) in param {
               multipartFormData.append((value).data(using: String.Encoding.utf8)!, withName: key)
           }

           for img in Productimages {
            let timestamp = NSDate().timeIntervalSince1970
            let strTime = String(timestamp)
            guard let imgData = img.jpegData(compressionQuality: 0.3) else { return }
               multipartFormData.append(imgData, withName: "photos", fileName: strTime + ".png", mimeType: "image/png")
           }


       },to: urlPath, usingThreshold: UInt64.init(),
         method: .post,
         headers: headers).responseJSON(completionHandler: { (response) in
            
            switch(response.result) {
            case .success(let value):
                //print("contact response result value:\(response.value)")
                if let JSON = value as? [String: Any] {
                    completion(JSON, response.error)
                    print(JSON)
                }else{
                    completion([String: Any](), response.error)
                }
            case .failure(_):
                print("contact failure response result value:\(response.result)")
                completion([String: Any](), response.error)
                

            }
})
    }
    
    func productOrderApproval(ProductApprovalDict:[String: Any], completion: @escaping ([String: Any], Error?) -> ()) {
        
        let urlPath = kBaseURL + "/orders/processRentRequests"
        print(urlPath)
        
       guard let url = URL(string: urlPath) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        let jsonData: Data
        do {
            jsonData = try JSONSerialization.data(withJSONObject: ProductApprovalDict, options: [])
            urlRequest.httpBody = jsonData
        } catch {
            print("Error: cannot create JSON from productOrderApproval")
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST on productOrderApproval")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let jsonResult = try JSONSerialization.jsonObject(with: responseData,
                                                                        options: .allowFragments) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
                print("The resetPasswordDict result is: " + jsonResult.description)
                completion(jsonResult, nil)
            } catch  {
                print("error parsing response from POST on resetPasswordDict")
                completion([String: Any](), error)
                return
            }
        }
        task.resume()
    }
    
    
    //users/contactus
    
    func ContactFormSubmit(contactUsDict:[String: Any], completion: @escaping ([String: Any], Error?) -> ()) {
        
        let urlPath = kBaseURL + "/users/contactus"
        print(urlPath)
    
        guard let url = URL(string: urlPath) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        let jsonData: Data
        do {
            jsonData = try JSONSerialization.data(withJSONObject: contactUsDict, options: [])
            urlRequest.httpBody = jsonData
        } catch {
            print("Error: cannot create JSON from resetPasswordDict")
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST on resetPasswordDict")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let jsonResult = try JSONSerialization.jsonObject(with: responseData,
                                                                        options: .allowFragments) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
                print("The resetPasswordDict result is: " + jsonResult.description)
                completion(jsonResult, nil)
            } catch  {
                print("error parsing response from POST on resetPasswordDict")
                completion([String: Any](), error)
                return
            }
        }
        task.resume()
    }
    
    
    func ServiceWithPOSTMethod(URLStr :  String ,addProductDict:[String: Any], completion: @escaping ([String: Any], Error?) -> ()) {
        
        let urlPath = kBaseURL + URLStr
        print(urlPath)
        
        guard let url = URL(string: urlPath) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(Defaults.retrieveDefaults.getAuthToken())", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        let jsonData: Data
        do {
            jsonData = try JSONSerialization.data(withJSONObject: addProductDict, options: [])
            urlRequest.httpBody = jsonData
        } catch {
            print("Error: cannot create JSON from addProductDict")
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST on addProductDict")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let jsonResult = try JSONSerialization.jsonObject(with: responseData,
                                                                        options: .allowFragments) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
                print("The addProductDict result is: " + jsonResult.description)
                completion(jsonResult, nil)
            } catch  {
                print("error parsing response from POST")
                completion([String: Any](), error)
                return
            }
        }
        task.resume()
    }
    
    
    func ServiceWithGETTMethod(urlString: String,_ completion: @escaping ([String: Any], Error?) -> ()) {
        let combinedPath = kBaseURL + urlString
        let urlPath = combinedPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        //var urlString = originalString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        print(urlPath)
        
        guard let url = URL(string: urlPath) else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(Defaults.retrieveDefaults.getAuthToken())", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "GET"
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling GET on getCategories")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let jsonResult = try JSONSerialization.jsonObject(with: responseData,
                                                                        options: .allowFragments) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            completion([String: Any](), error)
                                                                            return
                }
                print("The getCategories result is: " + jsonResult.description)
                
                completion(jsonResult, nil)
            } catch  {
                print("error parsing response from GET on getCategories")
                completion([String: Any](), error)
                return
            }
        }
        task.resume()
    }
    
    
    

}
