//
//  SignupViewController.swift
//  Leezed
//
//  Created by Neha Gupta on 31/08/19.
//  Copyright © 2019 Shertech. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import ActiveLabel
import Navajo_Swift

class SignupViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var screeNameTextField: UITextField!
    @IBOutlet weak var btn_eye: UIButton!
    @IBOutlet weak var lbl_termsAndCondition: ActiveLabel!
    @IBOutlet weak var lbl_passwordstrenth: UILabel!
    @IBOutlet weak var progress_strenth: UIProgressView!
    var IsCheckboxChecked = false
    
    let signUpObject = SignUp()
    var networkManager = NetworkManager.retrieveManager
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        let customType1 = ActiveType.custom(pattern: "\\sTerms of  use\\b") //Regex that looks for "with"
        let customType2 = ActiveType.custom(pattern: "\\sPrivacy Policy\\b")
        lbl_termsAndCondition.enabledTypes = [.mention, .hashtag, customType1, customType2]
        lbl_termsAndCondition.text = "By clicking on Singup, you agree to Terms of  use & Privacy Policy."
        lbl_termsAndCondition.customColor[customType1] = LeezedColors().kOrangeBaseColor
        lbl_termsAndCondition.customSelectedColor[customType1] = LeezedColors().kOrangeBaseColor
            lbl_termsAndCondition.customColor[customType2] = LeezedColors().kOrangeBaseColor
            lbl_termsAndCondition.customSelectedColor[customType2] = LeezedColors().kOrangeBaseColor
        lbl_termsAndCondition.handleCustomTap(for: customType1) { element in
            
            if let url = URL(string: "https://www.leezed.com/termsofuse") {
                UIApplication.shared.open(url)
            }
           // print("Custom type tapped: \(element)")
        }
        lbl_termsAndCondition.handleCustomTap(for: customType2) { element in
            
            if let url = URL(string: "https://www.leezed.com/privacypolicy") {
                UIApplication.shared.open(url)
            }
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        
        //for handling keyboard
        IQKeyboardManager.shared.enable = true
    }
    
    //MARK:- UITextField Methods
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == userEmailTextField {
            signUpObject.UserEmail = textField.text ?? ""
        } else if textField == passwordTextField {
            signUpObject.Password = textField.text ?? ""
        }

            else if textField == screeNameTextField {
            signUpObject.ScreenName = textField.text ?? ""
        }

    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userEmailTextField
        {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField
        {
            textField.resignFirstResponder()
            //confirmPasswordTextField.becomeFirstResponder()
        }

        else if textField == screeNameTextField
        {
            textField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func actbtn_eyeIconClicked(_ sender: Any) {
        let btntemp = sender as! UIButton
        if btntemp.isSelected{
            btntemp.isSelected = false
            passwordTextField.isSecureTextEntry = false
        }else{
            btntemp.isSelected = true
            passwordTextField.isSecureTextEntry = true
        }
        
        
        
        
    }
    
    @IBAction func actbtn_CheckboxBtnClicked(_ sender: Any) {
        
        let btntemp = sender as! UIButton
        if btntemp.isSelected{
            btntemp.isSelected = false
            IsCheckboxChecked = false
        }else{
            btntemp.isSelected = true
            IsCheckboxChecked = true
        }
        
        
    }
    
    
    
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        if textField == passwordTextField{
            
            let password = newString
            let strength = Navajo.strength(ofPassword: password)
            
            switch strength {
            case .veryWeak:
                lbl_passwordstrenth.text = "Very Weak"
                progress_strenth.progress = 0.2
                progress_strenth.progressTintColor = .red
                if password.count == 0{
                    lbl_passwordstrenth.text = ""
                    progress_strenth.progress = 0.0
                    progress_strenth.progressTintColor = .clear
                }
                
            case .weak:
                lbl_passwordstrenth.text = "Weak"
                progress_strenth.progress = 0.3
                progress_strenth.progressTintColor = .red
                
            case .reasonable:
               lbl_passwordstrenth.text = "Medium"
                progress_strenth.progress = 0.5
                progress_strenth.progressTintColor = .blue
                
            case .strong:
                lbl_passwordstrenth.text = "Strong"
                progress_strenth.progress = 0.7
                progress_strenth.progressTintColor = .green
                
            case .veryStrong:
                lbl_passwordstrenth.text = "Very Strong"
                progress_strenth.progress = 1.0
                progress_strenth.progressTintColor = .systemGreen
                
            default:
               lbl_passwordstrenth.text = ""
                progress_strenth.progress = 0.0
                progress_strenth.progressTintColor = .clear
            }
            
        }
        
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
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        self.slideMenuController()?.openLeft()
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        let passtext = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.view.endEditing(true)
        var errorMessageString = ""
        let strength = Navajo.strength(ofPassword: passwordTextField.text ?? "")
        if userEmailTextField.text?.count == 0 {
            errorMessageString = "Please enter username and try again"
        }
        else if passwordTextField.text?.count == 0 {
            errorMessageString = "Please enter password and try again"
        }
        else if passtext?.count ?? 0 > 5  {
            errorMessageString = "Password must contains 6 character."
        }
        else if screeNameTextField.text?.count == 0 {
            errorMessageString = "Please enter screen name and try again"
        }
        else if IsCheckboxChecked == false {
            errorMessageString = "Please agree to our terms of use and privacy policy."
        }
//        else if phoneNoTextField.text?.count == 0 {
//            errorMessageString = "Please enter phone no and try again"
//        }
        
        if errorMessageString.count > 0 {
            self.showAlert(withTitle: NSLocalizedString(KMissingData, comment: ""), message:  NSLocalizedString(errorMessageString, comment: ""))
        } else {
            showHUD()
            DispatchQueue.global(qos: .userInteractive).async {
                self.networkManager.postSignUp(signUpObject: self.signUpObject, completion: { (resultDictionary, error) in
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
                                    self.networkManager.LoadLoginView()
                                })
                                self.showConfirmationAlert(alertTitle: message, alertMessage: "", actionsArray: [okAction])
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
    
    @IBAction func AlreadyHaveAccountButtonTapped(_ sender: Any) {
       
        let objLoginVC = UINavigationController(rootViewController: LoginViewController())
        self.slideMenuController()?.changeMainViewController(objLoginVC, close: true)
        
        
//            let loginVC = UINavigationController(rootViewController: LoginViewController())
//            loginVC.setNavigationBarHidden(true, animated: true)
//            let appdel = UIApplication.shared.delegate as? AppDelegate
//            appdel?.window?.rootViewController = loginVC
    }
    
    @IBAction func logoHomeButtonTapped(_ sender: Any) {
//        pod
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.shared.enable = false
    }
    
    
}
