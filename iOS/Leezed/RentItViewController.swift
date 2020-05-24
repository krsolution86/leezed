//
//  RentItViewController.swift
//  Leezed
//
//  Created by Neha Gupta on 30/10/19.
//  Copyright © 2019 Shertech. All rights reserved.
//

import UIKit

class RentItViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblItemNameWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblItemNameHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var txtStartDatePicker: UITextField!
    @IBOutlet weak var txtEndDatePicker: UITextField!
    @IBOutlet weak var lblCost: UILabel!
    
    var selectedProduct = Products()
    let datePicker = UIDatePicker()
    var selectedTextField = UITextField()
    var networkManager = NetworkManager.retrieveManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        
        lblItemName.layer.cornerRadius = 8
        lblItemName.layer.masksToBounds = true
        lblItemName.textColor = LeezedColors().kOrangeBaseColor
        lblItemName.backgroundColor = LeezedColors().kBlackBaseColor
        lblItemName.font = LeezedFont.KGothicBoldFontWithSize(size: 16)
        LoadImage().load(imageView: productImageView, url: selectedProduct.ThumbnailUrl)
       // productImageView.downloadImageFrom(link: selectedProduct.ThumbnailUrl, contentMode: UIView.ContentMode.scaleAspectFit)
        lblItemName.text = selectedProduct.Name
        let size = selectedProduct.Name.size(withAttributes:[.font: LeezedFont.KGothicBoldFontWithSize(size: 16)])
        if size.width + 10 > (self.view.frame.width-60) {
            lblItemNameWidthConstraint.constant = (self.view.frame.width-60)
            lblItemNameHeightConstraint.constant = 50
        } else {
            lblItemNameWidthConstraint.constant = size.width + 20
            lblItemNameHeightConstraint.constant = 25
        }
        
        self.txtStartDatePicker.tintColor = .clear
        self.txtEndDatePicker.tintColor = .clear
        self.lblCost.text = String(format: "$%.2f ", selectedProduct.RentPrice).appending(selectedProduct.DurationUnitDesc)
       
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logoHomeButtonTapped(_ sender: Any) {
        let homeViewController = UINavigationController(rootViewController: HomeViewController())
        self.slideMenuController()?.changeMainViewController(homeViewController, close: true)
    }
    
    @IBAction func rentItButtonTapped(_ sender: Any) {
        self.view.endEditing(true)
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM dd, yyyy"
        let startDate = dateformatter.date(from: txtStartDatePicker.text ?? "")
        let endDate = dateformatter.date(from: txtEndDatePicker.text ?? "")
        
        let calendar = Calendar.current
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: startDate ?? Date())
        let date2 = calendar.startOfDay(for: endDate ?? Date())
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        if (components.day ?? 0) < 0 {
            showAlert(withTitle: "Error", message: String(format: "Invalide End date selected."))
        } else {
            
            let rentalStartDate = String.refineDateFormat(sourceFormat: "MMM dd, yyyy", destinationFormat: "yyyy-MM-dd'T'HH:mm:ssZ", sourceString: txtStartDatePicker.text ?? "")
            let rentalEndDate = String.refineDateFormat(sourceFormat: "MMM dd, yyyy", destinationFormat: "yyyy-MM-dd'T'HH:mm:ssZ", sourceString: txtEndDatePicker.text ?? "")
            
            let rentUnitCount = 2.0
            let unitCost = selectedProduct.RentPrice
            let rentPrice = Double(rentUnitCount * unitCost)
            showHUD()
            let placeRentDict: [String: Any] = ["rentalStartDate": rentalStartDate, "rentalEndDate": rentalEndDate, "productID": selectedProduct.ProductID, "rentPrice": String(rentPrice), "rentUnit": selectedProduct.DurationUnit, "rentUnitCount": rentUnitCount, "unitCost": unitCost]
            
            DispatchQueue.global(qos: .userInteractive).async {
                self.networkManager.placeRentRequest(placeRentDict: placeRentDict, completion: { (resultDictionary, error) in
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
                            
                            if resultDictionary.keys.contains("message") {
                                let message = resultDictionary["message"] as! String
                                
                                let okAction = UIAlertAction(title: NSLocalizedString(KAlertOkButtonTitle, comment: ""), style: .default, handler: { action in
                                    let homeViewController = UINavigationController(rootViewController: HomeViewController())
                                    self.slideMenuController()?.changeMainViewController(homeViewController, close: true)
                                })
                                self.showConfirmationAlert(alertTitle: "Success", alertMessage: message, actionsArray: [okAction])
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

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        selectedTextField = textField
        showDatePicker()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        //let rentalStartDate = formatter.date(from: selectedProduct.AvailableFromDate)
       // let rentalEndDate = formatter.date(from: selectedProduct.AvailableToDate)
        
        datePicker.minimumDate = Date()
        //datePicker.maximumDate = rentalEndDate
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        selectedTextField.inputAccessoryView = toolbar
        selectedTextField.inputView = datePicker
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        selectedTextField.text = formatter.string(from: datePicker.date)
        if (txtStartDatePicker.text != "") && (txtEndDatePicker.text != ""){
            self.calculatePrice()
        }
        self.view.endEditing(true)
    }
    
    
    func calculatePrice(){
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM dd, yyyy"
        let startDate = dateformatter.date(from: txtStartDatePicker.text ?? "")
        let endDate = dateformatter.date(from: txtEndDatePicker.text ?? "")
        
        let calendar = Calendar.current
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: startDate ?? Date())
        let date2 = calendar.startOfDay(for: endDate ?? Date())
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        if (components.day ?? 0) < 0 {
            showAlert(withTitle: "Error", message: String(format: "Invalide end date selected."))
            txtEndDatePicker.text = ""
        } else {
            if (components.day ?? 0 ) == 0{
                let price = 1 * selectedProduct.RentPrice
                lblCost.text = "$\(price)"
            }
            let price = Double(components.day ?? 0) * selectedProduct.RentPrice
             lblCost.text = "$\(price)"
            
        }
        
        
        
        
        
        
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
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
