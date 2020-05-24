//
//  HomeLocationSearchViewController.swift
//  Leezed
//
//  Created by UshyakuMB2 on 27/01/20.
//  Copyright © 2020 Shertech. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import CoreLocation

protocol locationSearchDelegate : class
{
    func closeLocationSearchPopOver()
    func searchProductsBasedOnZipCode(zipCode: String,strcity: String ,strState: String, latitude: Double, longitude: Double)
}

class HomeLocationSearchViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {

    var delegate : locationSearchDelegate?
    let appDel = UIApplication.shared.delegate as? AppDelegate
    var networkManager = NetworkManager.retrieveManager
    var strCity = ""
    var strState = ""
    var lat = 0.0
    var log = 0.0
    let locationManager = CLLocationManager()

    @IBOutlet weak var userCurrentLocationView: UIControl!
    @IBOutlet weak var postalCodeTextField: UITextField!
    @IBOutlet weak var btnSet: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblLocationName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        btnSet.layer.cornerRadius = 4
        btnSet.layer.borderWidth = 1
        btnSet.layer.borderColor = LeezedColors().kTextFieldBackgroundColor.cgColor
        btnSet.layer.masksToBounds = true
        
        btnCancel.layer.cornerRadius = 4
        btnCancel.layer.masksToBounds = true
        
        userCurrentLocationView.layer.cornerRadius = 4
        userCurrentLocationView.layer.masksToBounds = true
        
        if Defaults.retrieveDefaults.isUserLocationSet() {
            lblLocationName.text = Defaults.retrieveDefaults.getLocationName()
            postalCodeTextField.text = Defaults.retrieveDefaults.getPostalCode()
        }
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tapGR.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGR)
    }

    // MARK: - Text field Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        if string.count == 0
        {
            if String.isEmpty(str: textField.text!) {
                return false
            } else {
                return true
            }
        }
        
        if String.isEmpty(str: textField.text!) && string == " " {
            return false
        }
        
        let expression = "^[0-9]*$"
        let regex = try? NSRegularExpression(pattern: expression, options: .caseInsensitive)
        let numberOfMatches = regex?.numberOfMatches(in: newString, options: [], range: NSRange(location: 0, length: newString.count)) ?? 0
        if newString.count > 4{
            self.GetCityViaZipCode(zipcode: newString)
            //textField.resignFirstResponder()
        }
        return numberOfMatches != 0 && newString.count < 13
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
                               self.strCity = result["City"] as? String ?? ""
                               self.strState = result["State"] as? String ?? ""
                               let lattemp = result["lat"] as? NSNumber ?? NSNumber()
                               let longtemp = result["lon"] as? NSNumber ?? NSNumber ()
                            self.lat = lattemp.doubleValue
                            self.log = longtemp.doubleValue
                            self.lblLocationName.text = self.strCity + ", " + self.strState
                           }else if result.keys.contains("error"){
                            
                            let message = result["message"] as? String ?? ""
                            let okAction = UIAlertAction(title: NSLocalizedString(KAlertOkButtonTitle, comment: ""), style: .default, handler: { action in
                                self.strCity = ""
                                self.strState =  ""
                                self.lat = 0.0
                                self.log = 0.0
                                self.lblLocationName.text = " "
                            })
                            self.showConfirmationAlert(alertTitle: kUnauthorizedError, alertMessage: message, actionsArray: [okAction])
                            
                        }
                       }
                   }
               })
           )
           
           
           }
           
       }
    
    @IBAction func userCurrentLocationTapped(_ sender: Any) {
        self.strCity = ""
        self.strState =  ""
        self.lat = 0.0
        self.log = 0.0
        self.lblLocationName.text = " "
        postalCodeTextField.text = ""
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count > 0 {
             locationManager.stopUpdatingLocation()
        }
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in

            if (error != nil) {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }

            if (placemarks?.count)! > 0 {
                let pm = placemarks?[0]
                self.displayLocationInfo(pm)
                print (self.displayLocationInfo(pm))
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(_ placemark: CLPlacemark?) {
    if let containsPlacemark = placemark {
      //stop updating location to save battery life
       
        
        let postalCode = ((containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : "") ?? ""
        if postalCode != ""{
         self.GetCityViaZipCode(zipcode: postalCode)
        }
        }
 
 }
    
    @IBAction func btnSetTapped(_ sender: Any) {
        
        if self.log == 0.0 && self.lat == 0.0 {
            showAlert(withTitle: "Error", message: "Please enter postal code.")
        } else {
            Defaults.retrieveDefaults.isUserLocationSet(isLocationSet: true)
            Defaults.retrieveDefaults.setPostalCode(code: postalCodeTextField.text ?? "")
            Defaults.retrieveDefaults.setLocationName(locationName: self.strCity + ", " + self.strState)
            delegate?.searchProductsBasedOnZipCode(zipCode: postalCodeTextField.text ?? "",strcity: self.strCity, strState: self.strState,latitude: self.lat, longitude: self.log)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        delegate?.closeLocationSearchPopOver()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
