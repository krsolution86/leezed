//
//  SearchVC.swift
//  Leezed
//
//  Created by shivam tripathi on 02/05/20.
//  Copyright © 2020 Shertech. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

protocol SearchDelegate : class
{
    func searchCityFromSearchView(zipCode: String,strcity: String ,strState: String, latitude: String, longitude: String)
}


class SearchVC: UIViewController ,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
    @IBOutlet weak var tblview: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var delegate : SearchDelegate?
    var arrCity = [[String: Any]]()
    var networkManager = NetworkManager.retrieveManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblview.register(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: "SearchCell")
        self.searchBar.becomeFirstResponder()
    }
//searchBarSearchButtonClicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        let newtext = (searchBar.text ?? "") + text
        if newtext.isNumeric{
            if newtext.count > 4{
                self.GetCityViaZipCode(zipcode: newtext)
            }else{
                self.arrCity.removeAll()
                self.tblview.reloadData()
            }
        }else if (self.containsOnlyLetters(input: newtext)){
            
          if newtext.count > 3{
            self.GetCity(text: newtext)
            }
            else{
                self.arrCity.removeAll()
             self.tblview.reloadData()
            }
        }
        
        if newtext.count == 0{
             self.arrCity.removeAll()
             self.tblview.reloadData()
        }
        return true
    }
    
    func GetCityViaZipCode(zipcode: String){

        let StrURL = "/users/fetchZipDetails?zipcode=" + String (zipcode)
        showHUD()
        DispatchQueue.global(qos: .userInteractive).async {
            self.networkManager.ServiceWithGETTMethod(urlString: StrURL,  ({ (result, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.hideHUD()
                        let okAction = UIAlertAction(title: NSLocalizedString(KAlertOkButtonTitle, comment: ""), style: .default, handler: { action in
                             self.networkManager.LoadLoginView()
                        })
                        self.showConfirmationAlert(alertTitle: kUnauthorizedError, alertMessage: "Please login again", actionsArray: [okAction])
                    }
                } else {
                    DispatchQueue.main.async {
                        self.hideHUD()
                        if result.keys.contains("State"){
                            self.arrCity.removeAll()
//                            let strCity = result["City"] as? String ?? ""
//                            let strState = result["State"] as? String ?? ""
//                            let lattemp = result["lat"] as? NSNumber ?? NSNumber()
//                            let longtemp = result["lon"] as? NSNumber ?? NSNumber ()
//
//                            let dict = ["City":strCity, "State":strState, "Lat": lattemp, "Log": longtemp,"Zipcode":zipcode] as [String : Any]
                            self.arrCity.append(result)
                            self.tblview.reloadData()
                        }else if result.keys.contains("error"){
                         
                         let message = result["message"] as? String ?? ""
                         let okAction = UIAlertAction(title: NSLocalizedString(KAlertOkButtonTitle, comment: ""), style: .default, handler: { action in
                             
                         })
                         self.showConfirmationAlert(alertTitle: kUnauthorizedError, alertMessage: message, actionsArray: [okAction])
                         
                     }
                    }
                }
            })
        )
        
        
        }
        
    }
    
    
    func GetCity(text: String){

        let StrURL = "/common/searchCities?searchTerm=" + String (text)
        showHUD()
        DispatchQueue.global(qos: .userInteractive).async {
            self.networkManager.ServiceWithGETTMethod(urlString: StrURL,  ({ (result, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.hideHUD()
                        let okAction = UIAlertAction(title: NSLocalizedString(KAlertOkButtonTitle, comment: ""), style: .default, handler: { action in
                             self.networkManager.LoadLoginView()
                        })
                        self.showConfirmationAlert(alertTitle: kUnauthorizedError, alertMessage: "Please login again", actionsArray: [okAction])
                    }
                } else {
                    DispatchQueue.main.async {
                        self.hideHUD()
                        if result.keys.contains("searchResults"){
                            self.arrCity.removeAll()
                            self.arrCity = result["searchResults"] as? [[String: Any]] ?? [[String: Any]]()
                            self.tblview.reloadData()
                        }else if result.keys.contains("error"){
                         
                         let message = result["message"] as? String ?? ""
                         let okAction = UIAlertAction(title: NSLocalizedString(KAlertOkButtonTitle, comment: ""), style: .default, handler: { action in
                             
                         })
                         self.showConfirmationAlert(alertTitle: kUnauthorizedError, alertMessage: message, actionsArray: [okAction])
                         
                     }
                    }
                }
            })
        )
        
        
        }
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         self.arrCity.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let dicttemp = self.arrCity[indexPath.row]
         let objcell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! SearchCell
         let strcity = dicttemp["City"] as? String ?? ""
         let strState = dicttemp["State"] as? String ?? ""
         let CityName = strcity + ", " + strState
        objcell.lbl_city.text = CityName
        
         return objcell
     }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let dicttemp = self.arrCity[indexPath.row]
        let zipCode = dicttemp["ZipCode"] as? String ?? ""
        let strcity = dicttemp["City"] as? String ?? ""
        let strState = dicttemp["State"] as? String ?? ""
        let latitude = dicttemp["lat"] as? NSNumber ?? NSNumber()
        let longitude = dicttemp["lon"] as? NSNumber ?? NSNumber()
        
        if self.delegate != nil {
            self.delegate?.searchCityFromSearchView(zipCode: zipCode, strcity: strcity, strState: strState, latitude: latitude.stringValue, longitude: longitude.stringValue)
            Defaults.retrieveDefaults.setPostalCode(code: zipCode)
            Defaults.retrieveDefaults.setLocationName(locationName: strcity + ", " + strState)
        }
        
        self.dismiss(animated: true, completion: nil)
     }
    
    
    func containsOnlyLetters(input: String) -> Bool {
       for chr in input {
          if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z")  && !(chr == " ")) {
             return false
          }
       }
       return true
    }

}

extension String {
    var isNumeric : Bool {
        return Int(self) != nil
    }
    
    
}
