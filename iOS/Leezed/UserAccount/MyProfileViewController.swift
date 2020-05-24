//
//  MyProfileViewController.swift
//  Leezed
//
//  Created by Neha Gupta on 02/10/19.
//  Copyright © 2019 Shertech. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class MyProfileViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var lblName: UILabel!
    var networkManager = NetworkManager.retrieveManager
    private var gradient: CAGradientLayer!
    
    @IBOutlet weak var txtScreenName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhoneNo: UITextField!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var txtName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        txtScreenName.attributedPlaceholder = NSAttributedString(string: "placeholder text",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        txtEmail.attributedPlaceholder = NSAttributedString(string: "placeholder text",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        txtPhoneNo.attributedPlaceholder = NSAttributedString(string: "placeholder text",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        txtName.attributedPlaceholder = NSAttributedString(string: "placeholder text",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        self.loadUserProfile()
        
        
    }
    
    func loadUserProfile(){
        let userProfile = Defaults.retrieveDefaults.getUserProfile()
        var userID = ""
        if (userProfile["userID"] as? String) != nil{
            userID = userProfile["userID"] as! String
        }else{
            userID = String(userProfile["userID"] as! Int)
        }
        
        showHUD()
        DispatchQueue.global(qos: .userInteractive).async {
            
            self.networkManager.getUserProfile(userID:userID as! String,{ (userProfileDictionary, error) in
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
                        
                        Defaults.retrieveDefaults.setUserProfile(myDict: userProfileDictionary)
                        
                        if userProfileDictionary.keys.contains("screenName") {
                            self.lblName.text = " \(userProfileDictionary["screenName"] as? String ?? "")"
                            self.txtScreenName.text = "\(userProfileDictionary["screenName"] as? String ?? "")"
                            self.txtScreenName.isUserInteractionEnabled = false
                        } else {
                            self.lblName.text = "N/A"
                            self.txtScreenName.text = "N/A"
                            self.txtScreenName.isUserInteractionEnabled = true
                        }
                            
                        if userProfileDictionary.keys.contains("email") {
                            self.txtEmail.text = userProfileDictionary["email"] as? String
                             self.txtEmail.isUserInteractionEnabled = false
                        } else {
                            self.txtEmail.text = "N/A"
                             self.txtEmail.isUserInteractionEnabled = true
                        }
                        
                        if userProfileDictionary.keys.contains("phone") {
                            self.txtPhoneNo.text = userProfileDictionary["phone"] as? String
                        } else {
                            self.txtPhoneNo.text = "N/A"
                        }
                        
                        if userProfileDictionary.keys.contains("name") {
                            self.txtName.text = userProfileDictionary["name"] as? String
                        } else {
                            self.txtName.text = "N/A"
                        }
                        
                        // Change the cosmos view rating
                    
                    }
                }
            })
        }
        
        
    }
    
    @IBAction func actbtn_LenditembtnClicked(_ sender: Any) {
        let obj_addRent = AddRentItemsViewController()
        obj_addRent.isCalledFromview = true
        self.navigationController?.pushViewController(obj_addRent, animated: true)
    }
    
    
    @IBAction func logoHomeButtonTapped(_ sender: Any) {
        let homeViewController = UINavigationController(rootViewController: HomeViewController())
        self.slideMenuController()?.changeMainViewController(homeViewController, close: true)
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        self.slideMenuController()?.openLeft()
    }

   
    
    //MARK:- UITextField Methods
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtEmail
        {
            textField.resignFirstResponder()
        }
        else if textField == txtName
        {
            textField.resignFirstResponder()
        }
        else if textField == txtScreenName
        {
            textField.resignFirstResponder()
        }
        else if textField == txtPhoneNo
        {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
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
        
        //        if textField == phoneNoTextField {
        //            let expression = "^[0-9]*$"
        //            let regex = try? NSRegularExpression(pattern: expression, options: .caseInsensitive)
        //            let numberOfMatches = regex?.numberOfMatches(in: newString, options: [], range: NSRange(location: 0, length: newString.count)) ?? 0
        //            return numberOfMatches != 0
        //        }
        return true
    }
    
    //MARK:- UITextView Methods
    
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        /*
         https://www.leezed.com/api/v1/users/updateProfile
         {email: "abhishekdxt3@gmail.com"screenName: "testUser"phone: "9179821599"name: "testUser1"}
         */
        
         self.view.endEditing(true)
        if self.txtScreenName.text == "" {
            self.showAlert(withTitle: NSLocalizedString(KMissingData, comment: ""), message:  NSLocalizedString("Please enter screen name.", comment: ""))
                
            }else if self.txtEmail.text == "" {
               self.showAlert(withTitle: NSLocalizedString(KMissingData, comment: ""), message:  NSLocalizedString("Please enter Email ID.", comment: ""))
                
                
            }else if self.txtPhoneNo.text == "" {
                
                 self.showAlert(withTitle: NSLocalizedString(KMissingData, comment: ""), message:  NSLocalizedString("Please enter phone number.", comment: ""))
            }else if self.txtName.text == "" {
                 self.showAlert(withTitle: NSLocalizedString(KMissingData, comment: ""), message:  NSLocalizedString("Please enter name.", comment: ""))
                
            }else{
               
                    showHUD()
                let profile: [String: Any] = ["email": txtEmail.text ?? "", "screenName":txtScreenName.text ?? "", "phone": txtPhoneNo.text ?? "","name":txtName.text ?? ""]
                    
                    DispatchQueue.global(qos: .userInteractive).async {
                        self.networkManager.SubmitProfileRequest(profileDict: profile, completion: { (resultDictionary, error) in
                            if error != nil {
                                DispatchQueue.main.async {
                                    self.hideHUD()
                                    self.showAlert(withTitle: kErrorTitle, message: error?.localizedDescription ?? "Service Error")
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.hideHUD()

                                    if resultDictionary.keys.contains("message") {
                                        let message = resultDictionary["message"] as! String
                                        
                                            let okAction = UIAlertAction(title: NSLocalizedString(KAlertOkButtonTitle, comment: ""), style: .default, handler: { action in
                                                 self.loadUserProfile()
                                            })
                                            self.showConfirmationAlert(alertTitle: "", alertMessage: message, actionsArray: [okAction])
                                    } else if resultDictionary.keys.contains("errorMsg") {
                                        let errorMessage = resultDictionary["errorMsg"] as! String
                                        self.showAlert(withTitle: kErrorTitle, message: errorMessage)
                                    } else {
                                        self.showAlert(withTitle: kErrorTitle, message: "Server Error")
                                    }
                                }
                            }
                        })
                    }
            }
    }
    

}
