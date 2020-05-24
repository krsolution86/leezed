//
//  LoginViewController.swift
//  Leezed
//
//  Created by Neha Gupta on 31/08/19.
//  Copyright © 2019 Shertech. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FBSDKLoginKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtEmailOrMobileNo: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    var isRemebermeON = false
    @IBOutlet weak var btn_remeberme: UIButton!
    
    var networkManager = NetworkManager.retrieveManager
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        isRemebermeON = false
        let emailID = UserDefaults.standard.string(forKey: "userEmail")
        let Password = UserDefaults.standard.string(forKey: "userPassword")
        
        if (emailID != nil){
            txtEmailOrMobileNo.text = emailID
            self.isRemebermeON = true
            btn_remeberme.isSelected = true
        }
        if (Password != nil){
             txtPassword.text = Password
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        
        //for handling keyboard
        IQKeyboardManager.shared.enable = true
    }
    
    //MARK: TEXT FILED DELEGATE METHODS
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txtEmailOrMobileNo {
            textField.resignFirstResponder()
            txtPassword.becomeFirstResponder()
        }
        else if textField == txtPassword {
            textField.resignFirstResponder()
            return true
        }
        return true
    }
    
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
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtEmailOrMobileNo {
            txtEmailOrMobileNo.text = txtEmailOrMobileNo.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        else if textField == txtPassword {
            txtPassword.text = txtPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    @IBAction func actbtn_RemeberMebtnClicked(_ sender: Any) {
        var btn = sender as! UIButton
        
        if btn.isSelected{
            
            btn.isSelected = false
            self.isRemebermeON = false
            UserDefaults.standard.removeObject(forKey: "userEmail")
            UserDefaults.standard.removeObject(forKey: "userPassword")
            self.txtPassword.text = ""
            self.txtEmailOrMobileNo.text = ""
            
        }else{
            
            btn.isSelected = true
            self.isRemebermeON = true
        }
        
    }
    @IBAction func actbtn_loginWithFacebookClicked(_ sender: Any) {
        
        let login = LoginManager()
        login.logIn(permissions: ["email","public_profile"], from: self) { (result, error) in
            if ((error) != nil) {
              print("Process error");
            } else if (result?.isCancelled ?? false) {
              print("Cancelled");
            } else {
              print("Logged in");
                self.showHUD()
                let signInDict: [String: Any] = ["access_token": result?.token?.tokenString ?? ""]
                    
                    DispatchQueue.global(qos: .userInteractive).async {
                        self.networkManager.LoginViaFB(FacebookToken: signInDict, completion: { (resultDictionary, error) in
                            if error != nil {
                                DispatchQueue.main.async {
                                    self.hideHUD()
                                    self.showAlert(withTitle: kErrorTitle, message: error?.localizedDescription ?? "Service Error")
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.hideHUD()
                                    
                                    if resultDictionary.keys.contains("authToken") {
                                        let authToken = resultDictionary["authToken"] as! String
                                        Defaults.retrieveDefaults.setAuthToken(token: authToken)
                                        
                                        let decryptData = Defaults.retrieveDefaults.decodeJWTToken(authToken)
                                        let userDict = decryptData?["sub"] as! [String : Any]
                                        Defaults.retrieveDefaults.setUserProfile(myDict: userDict)
                                        
                                    let appdel = UIApplication.shared.delegate as? AppDelegate
                                        appdel?.LoadSliderView()
                                    }
                                    else if resultDictionary.keys.contains("errorMsg") {
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
    
    @IBAction func signInButtonTapped(_ sender: Any) {

        self.view.endEditing(true)
        var errorMessageString = ""
        
        if txtEmailOrMobileNo.text?.count == 0 {
            errorMessageString = "Please enter email/mobile no and try again"
        }
        else if txtPassword.text?.count == 0 {
            errorMessageString = "Please enter password and try again"
        }
        
        if errorMessageString.count > 0 {
            self.showAlert(withTitle: NSLocalizedString(KMissingData, comment: ""), message:  NSLocalizedString(errorMessageString, comment: ""))
        } else {
            if isRemebermeON{
                UserDefaults.standard.set(txtEmailOrMobileNo.text ?? "", forKey: "userEmail")
                UserDefaults.standard.set(txtPassword.text ?? "", forKey: "userPassword")
                       UserDefaults.standard.synchronize()
                
            }
            
            showHUD()
            let signInDict: [String: Any] = ["email": txtEmailOrMobileNo.text ?? "", "password": txtPassword.text ?? ""]
            
            DispatchQueue.global(qos: .userInteractive).async {
                self.networkManager.postSignIn(signInDict: signInDict, completion: { (resultDictionary, error) in
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
                                let authToken = resultDictionary["authToken"] as! String
                                Defaults.retrieveDefaults.setAuthToken(token: authToken)
                                
                                let decryptData = Defaults.retrieveDefaults.decodeJWTToken(authToken)
                                let userDict = decryptData?["sub"] as! [String : Any]
                                Defaults.retrieveDefaults.setUserProfile(myDict: userDict)
                                let appdel = UIApplication.shared.delegate as? AppDelegate
                                appdel?.LoadSliderView()
                                
                                
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
    
    @IBAction func rememberMeViewTapped(_ sender: Any) {
        
        
        
        
    }
    
    
    
    @IBAction func dontHaveAccountButtonTapped(_ sender: Any) {
        let objSignup = UINavigationController(rootViewController: SignupViewController())
        self.slideMenuController()?.changeMainViewController(objSignup, close: true)
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: Any) {
        
        let forgetPassViewController = UINavigationController(rootViewController: ForgotPasswordViewController())
        forgetPassViewController.isNavigationBarHidden = true
               self.slideMenuController()?.changeMainViewController(forgetPassViewController, close: true)
        
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        self.slideMenuController()?.openLeft()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.shared.enable = false
    }
    

}
