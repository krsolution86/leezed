//
//  ContactUSVC.swift
//  Leezed
//
//  Created by shivam tripathi on 23/03/20.
//  Copyright © 2020 Shertech. All rights reserved.
//

import UIKit
import MMText
import IQKeyboardManagerSwift

class ContactUSVC: UIViewController ,UITextViewDelegate,UITextFieldDelegate{

    @IBOutlet weak var txt_counter: UILabel!
    @IBOutlet weak var txtMessage: MMTextView!
    @IBOutlet weak var txtEmail: MMTextField!
    @IBOutlet weak var txt_subject: MMTextField!
    @IBOutlet weak var txtName: MMTextField!
     @IBOutlet weak var btnSubmit: UIButton!
    var networkManager = NetworkManager.retrieveManager
    override func viewDidLoad() {
        super.viewDidLoad()
        txtName.textColor = .white
        txtEmail.textColor = .white
        txt_subject.textColor = .white
        txtMessage.textColor = .white
        IQKeyboardManager.shared.enable = true
        // Do any additional setup after loading the view.
    }

    @IBAction func actbtn_submitbtnClicked(_ sender: Any) {
        self.view.endEditing(true)
        
        if self.txtName.text == "" {
        self.showAlert(withTitle: NSLocalizedString(KMissingData, comment: ""), message:  NSLocalizedString("Please enter Name.", comment: ""))
            
        }else if self.txtEmail.text == "" {
           self.showAlert(withTitle: NSLocalizedString(KMissingData, comment: ""), message:  NSLocalizedString("Please enter Email ID.", comment: ""))
            
            
        }else if self.txt_subject.text == "" {
            
             self.showAlert(withTitle: NSLocalizedString(KMissingData, comment: ""), message:  NSLocalizedString("Please enter subject.", comment: ""))
        }else if self.txtMessage.text == "" {
             self.showAlert(withTitle: NSLocalizedString(KMissingData, comment: ""), message:  NSLocalizedString("Please enter message.", comment: ""))
            
        }else{
           
                showHUD()
            let contactUSForm: [String: Any] = ["contactFormName": txtName.text ?? "", "contactFormEmail":txtEmail.text ?? "", "subject": txt_subject.text ?? "","contactFormMessage":txtMessage.text ?? "","contactFormCopy":""]
                
                DispatchQueue.global(qos: .userInteractive).async {
                    self.networkManager.ContactFormSubmit(contactUsDict: contactUSForm, completion: { (resultDictionary, error) in
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
                                                   self.txtName.text = ""
                                                   self.txtEmail.text = ""
                                                   self.txt_subject.text = ""
                                                   self.txtMessage.text = ""
                                        self.txt_counter.text = "0\\250"
                                        let okAction = UIAlertAction(title: NSLocalizedString(KAlertOkButtonTitle, comment: ""), style: .default, handler: { action in
                                            
                                        })
                                        self.showConfirmationAlert(alertTitle: "", alertMessage: "Email has been sent!", actionsArray: [okAction])
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
    
    @IBAction func actbtn_itemLendbtnClciked(_ sender: Any) {
        let obj_addRent = AddRentItemsViewController()
        obj_addRent.isCalledFromview = true
        self.navigationController?.pushViewController(obj_addRent, animated: true)
        
    }
    
    
    @IBAction func actbtn_MenuBtnClicked(_ sender: Any) {
         self.slideMenuController()?.openLeft()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txtName {
            textField.resignFirstResponder()
            txtEmail.becomeFirstResponder()
        }
        else if textField == txtEmail {
            textField.resignFirstResponder()
            txt_subject.becomeFirstResponder()
           
        }
        else if textField == txt_subject {
            textField.resignFirstResponder()
            txtMessage.becomeFirstResponder()
           
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        if numberOfChars < 250{
            self.txt_counter.text = String(numberOfChars) + "\\250"
            
        }else{
            return false
        }
        
        
        return true
    }
    
}
