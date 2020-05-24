//
//  ForgotPasswordViewController.swift
//  Leezed
//
//  Created by UshyakuMB2 on 27/01/20.
//  Copyright © 2020 Shertech. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    var networkManager = NetworkManager.retrieveManager
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //MARK: TEXT FILED DELEGATE METHODS
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
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
        emailTextField.text = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    @IBAction func btnSubmitTapped(_ sender: Any) {
        self.view.endEditing(true)
        
        if emailTextField.text?.count == 0 {
            self.showAlert(withTitle: NSLocalizedString(KMissingData, comment: ""), message:  NSLocalizedString("Please enter email", comment: ""))
        } else {
            showHUD()
            let resetPasswordDict: [String: Any] = ["email": emailTextField.text ?? "", "newPassword": "", "confirmPassword": ""]
            
            DispatchQueue.global(qos: .userInteractive).async {
                self.networkManager.ForgotPassword(resetPasswordDict: resetPasswordDict, completion: { (resultDictionary, error) in
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
                                if message == "sent"
                                {
                                    let okAction = UIAlertAction(title: NSLocalizedString(KAlertOkButtonTitle, comment: ""), style: .default, handler: { action in
                                        let loginVC = UINavigationController(rootViewController: LoginViewController())
                                        loginVC.setNavigationBarHidden(true, animated: true)
                                        let appdel = UIApplication.shared.delegate as? AppDelegate
                                        appdel?.window?.rootViewController = loginVC
                                    })
                                    self.showConfirmationAlert(alertTitle: "", alertMessage: "Email with password reset link sent to your email address!", actionsArray: [okAction])
                                }
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
    
    @IBAction func btnBackToSignInTapped(_ sender: Any) {
        let objLoginVC = UINavigationController(rootViewController: LoginViewController())
               self.slideMenuController()?.changeMainViewController(objLoginVC, close: true)
        
//        let loginVC = UINavigationController(rootViewController: LoginViewController())
//        loginVC.setNavigationBarHidden(true, animated: true)
//        let appdel = UIApplication.shared.delegate as? AppDelegate
//        appdel?.window?.rootViewController = loginVC
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        self.slideMenuController()?.openLeft()
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
