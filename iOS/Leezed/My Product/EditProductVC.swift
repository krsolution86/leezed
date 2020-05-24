//
//  EditProductVC.swift
//  Leezed
//
//  Created by shivam tripathi on 13/04/20.
//  Copyright © 2020 Shertech. All rights reserved.
//

import UIKit
import DropDown
import IQKeyboardManagerSwift


class EditProductVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, EditProductitemCellDelegate {
    
    

    var networkManager = NetworkManager.retrieveManager
    var categoryArray = [Categories]()
    var objitem: MyproductItem!
    @IBOutlet weak var src_view: UIScrollView!
    @IBOutlet weak var nameTextField: LeezedEditableTextField!
    @IBOutlet weak var categoryTextField: LeezedTextField!
    @IBOutlet weak var priceTextField: LeezedEditableTextField!
    @IBOutlet weak var durationTextField: LeezedTextField!
    @IBOutlet weak var minimalRentalTextField: LeezedEditableTextField!
    @IBOutlet weak var descriptionTextField: LeezedEditableTextField!
    @IBOutlet weak var pickUpInstructionTextField: LeezedEditableTextField!
    @IBOutlet weak var availableFromTextField: LeezedEditableTextField!
    @IBOutlet weak var availableTillTextField: LeezedEditableTextField!
    @IBOutlet weak var locationTextField: LeezedEditableTextField!
    @IBOutlet weak var zipTextField: LeezedEditableTextField!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    var imageArray = [[String: Any]]()
    var gradientView:UIView = UIView()
    var strCity = ""
    var strState = ""
    
    
    enum addItemTextFields:String {
        case Default
        case Category
        case Duration
        case availableFrom
        case availableTill
    }
    var selectedTextField = addItemTextFields.Default
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        
        showHUD()
        DispatchQueue.global(qos: .userInteractive).async {
            self.networkManager.getCategories({ (result, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.hideHUD()
                        let okAction = UIAlertAction(title: NSLocalizedString(KAlertOkButtonTitle, comment: ""), style: .default, handler: { action in
                            
//                            let loginVC = UINavigationController(rootViewController: LoginViewController())
//                            self.slideMenuController()?.changeMainViewController(loginVC, close: true)
                            self.networkManager.LoadLoginView()
                            
                        })
                        self.showConfirmationAlert(alertTitle: kUnauthorizedError, alertMessage: "Please login again", actionsArray: [okAction])
                    }
                } else {
                    DispatchQueue.main.async {
                        self.hideHUD()
                        
                        let tempCategoryArray = result["categories"] as? [[String : Any]] ?? [["" : ""]]
                        for obj in tempCategoryArray {
                            let objCategory = Categories()
                            objCategory.categoryID = obj["categoryID"] as? Int ?? 0
                            objCategory.categoryName = String.getValidStringValue(string: obj["name"] as? String ?? "")
                            objCategory.categoryDescription = String.getValidStringValue(string: obj["description"] as? String ?? "")
                            
                            self.categoryArray.append(objCategory)
                        }
                    }
                }
            })
        }
        
        imageCollectionView.register(UINib(nibName: "ImageLoadCell", bundle: nil), forCellWithReuseIdentifier: "ImageLoadCell")
        imageCollectionView.layer.cornerRadius = 8.0
        imageCollectionView.layer.masksToBounds = true
        imageCollectionView.layer.borderWidth = 1.0
        self.LoadPrefieldView()
        self.loadProductImages()
        
    }
    override func viewWillLayoutSubviews() {
        self.src_view.contentSize = CGSize(width: 0, height: 600)
    }
    
    @IBAction func actbtn_BackbtnCLicked(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func  LoadPrefieldView() {
        
        self.nameTextField.text = objitem.name
        self.priceTextField.text = "$" + String(objitem.rentPrice)
        self.descriptionTextField.text = objitem.productDesc
        self.categoryTextField.text = objitem.categoryName
        self.minimalRentalTextField.text = "$" + String(objitem.minRental)
        self.availableFromTextField.text = String.refineDateFormat(sourceFormat: "yyyy-MM-dd'T'HH:mm:ss.000Z", destinationFormat: "MMM dd, yyyy", sourceString: objitem.availableFromDate)
        self.availableTillTextField.text = String.refineDateFormat(sourceFormat: "yyyy-MM-dd'T'HH:mm:ss.000Z", destinationFormat: "MMM dd, yyyy", sourceString: objitem.availableToDate)
            
        self.locationTextField.text = objitem.location
        self.zipTextField.text = String(objitem.zipCode)
        self.pickUpInstructionTextField.text = objitem.pickupInstructions
        
        
        
        
    }
    
    
    func loadProductImages(){

        let StrURL = "/images/getProductImages?productID=" + String (objitem.productID)
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
                        self.imageArray.removeAll()
                        let value = result["Images"]
                        
                        for item in value as? [[String : Any]] ?? [[String : Any]]()
                        {
                            
                          let strImageUrl = item["Url"] as? String ?? ""
                            let dicttemp = ["kind": "URL", "image": strImageUrl]
                            self.imageArray.append(dicttemp)
                        }
                        self.imageCollectionView.reloadData()
                    }
                }
            })
        )
        
        
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        
        //for handling keyboard
        IQKeyboardManager.shared.enable = true
    }

    @IBAction func menuButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logoHomeButtonTapped(_ sender: Any) {
        let homeViewController = UINavigationController(rootViewController: HomeViewController())
        self.slideMenuController()?.changeMainViewController(homeViewController, close: true)
    }
    
    //MARK:- TextField Delegates
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == nameTextField {

        } else if textField == categoryTextField {
            
            selectedTextField = addItemTextFields.Category
            showDropDownVC()
            return false
            
        } else if textField == priceTextField {
            
        } else if textField == durationTextField {
            
            selectedTextField = addItemTextFields.Duration
            showDropDownVC()
            return false
        } else if textField == minimalRentalTextField {
            
        } else if textField == descriptionTextField {
            
        } else if textField == pickUpInstructionTextField {
            
        } else if textField == availableFromTextField {
            selectedTextField = addItemTextFields.availableFrom
            showDatePicker()
        } else if textField == availableTillTextField {
            selectedTextField = addItemTextFields.availableTill
            showDatePicker()
        } else if textField == locationTextField {
            
        } else if textField == zipTextField {
            
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        result =  result.replacingOccurrences(of: "$", with: "")
        if result.count == 0 {
            if (textField.text?.count) != 0{
                return true
            }else{
                return false
            }
        }
        if ((textField.text?.count == 0) && (string == "")){
            return false
        }
        
        if textField == priceTextField || textField == minimalRentalTextField || textField == zipTextField {
            
            if string == ""{
                
                return true
            }
            let expression = "^[0-9]{0,6}(\\.[0-9]{0,2})?%?$"
            var regex: NSRegularExpression? = nil
            do {
                regex = try NSRegularExpression(pattern: expression, options: .caseInsensitive)
            } catch {
            }
            let numberOfMatches: Int? = regex?.numberOfMatches(in: result, options: [], range: NSRange(location: 0, length: result.count))
            if textField == zipTextField{
                
                if result.count > 4{
                    
                    self.GetCityViaZipCode(zipcode: result)
                    
                }
                
            }
            
            return numberOfMatches != 0
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
                            self.strCity = result["City"] as? String ?? ""
                            self.strState = result["State"] as? String ?? ""
                            self.locationTextField.text = self.strCity + ", " + self.strState
                        }
                    }
                }
            })
        )
        
        
        }
        
    }
    
    func showDropDownVC() {
        if selectedTextField == .Category {
            
            if categoryArray.count > 0 {
                
                let dropDown = DropDown()
                // The view to which the drop down will appear on
                dropDown.anchorView = categoryTextField.rightView // UIView or UIBarButtonItem
                
                // The list of items to display. Can be changed dynamically
                let categoryNameArray = categoryArray.map { $0.categoryName }.sorted(by: <)
                dropDown.dataSource = categoryNameArray
                // Will set a custom width instead of the anchor view width
                dropDown.width = 200
                
                
                // Action triggered on selection
                dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                    print("Selected item: \(item) at index: \(index)")
                    self.categoryTextField.text = item
                }
                dropDown.show()
            }else{
                self.showAlert(withTitle: "Missing Data", message: "No category found")
            }
        }
        else if selectedTextField == .Duration {
            
            let dropDown = DropDown()
            // The view to which the drop down will appear on
            dropDown.anchorView = durationTextField.rightView // UIView or UIBarButtonItem
            
            // The list of items to display. Can be changed dynamically
            dropDown.dataSource = ["Per Hour", "Per Day", "Per Week"]
            // Will set a custom width instead of the anchor view width
            dropDown.width = 200
            
            
            // Action triggered on selection
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                print("Selected item: \(item) at index: \(index)")
                self.durationTextField.text = item
            }
            dropDown.show()
        }
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date.init()
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        if selectedTextField == .availableFrom {
            availableFromTextField.inputAccessoryView = toolbar
            availableFromTextField.inputView = datePicker
        } else {
            availableTillTextField.inputAccessoryView = toolbar
            availableTillTextField.inputView = datePicker
        }
    }
    
    @objc func donedatePicker(){
        
        self.view.endEditing(true)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        if selectedTextField == .availableFrom {
            availableFromTextField.text = formatter.string(from: datePicker.date)
        } else {
            availableTillTextField.text = formatter.string(from: datePicker.date)
        }
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.shared.enable = false
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        self.view.endEditing(true)
        
        var errorMessage = ""
        if String.isEmpty(str: nameTextField.text ?? "")
        {
            errorMessage = "Please enter name"
        }
        else if String.isEmpty(str: categoryTextField.text ?? "")
        {
            errorMessage = "Please selecte category"
        }
        else if String.isEmpty(str: priceTextField.text ?? "")
        {
            errorMessage = "Please enter price"
        }
        else if String.isEmpty(str: minimalRentalTextField.text ?? "")
        {
            errorMessage = "Please enter minimal rental"
        }
        else if String.isEmpty(str: descriptionTextField.text ?? "")
        {
            errorMessage = "Please enter description"
        }
        else if String.isEmpty(str: locationTextField.text ?? "")
        {
            errorMessage = "Please enter location"
        }
        else if String.isEmpty(str: zipTextField.text ?? "")
        {
            errorMessage = "Please enter zipcode"
        }
        else if imageArray.count == 0
        {
            errorMessage = "Please add images of your item."
        }
        
        if String.isEmpty(str: errorMessage) {
            showHUD()
            
            let availableFromDate = String.refineDateFormat(sourceFormat: "MMM dd, yyyy", destinationFormat: "yyyy-MM-dd", sourceString: availableFromTextField.text ?? "")
            let availableToDate = String.refineDateFormat(sourceFormat: "MMM dd, yyyy", destinationFormat: "yyyy-MM-dd", sourceString: availableTillTextField.text ?? "")
            
            let selectedCategory = categoryArray.filter{$0.categoryName == categoryTextField.text}
            var categoryID = ""
            if selectedCategory.count > 0 {
                categoryID = String(selectedCategory[0].categoryID)
            }
            
            var strDuration = ""
            if durationTextField.text == "Per Day"{
                strDuration = "DAY"
            }else if  durationTextField.text == "Per Week"{
                strDuration = "WEEK"
            }else{
                 strDuration = "HOUR"
            }
            
            let Rentprice = (priceTextField.text ?? "").replacingOccurrences(of: "$", with: "")
            let miniRent = (minimalRentalTextField.text ?? "").replacingOccurrences(of: "$", with: "")
            
            let addProductDict: [String: Any] = ["productID": objitem.productID, "name": nameTextField.text ?? "", "description": descriptionTextField.text ?? "", "categoryID": categoryID, "rentPrice": Rentprice,"minRental":miniRent
            , "durationUnit": strDuration, "city": self.strCity, "state": self.strState, "location": locationTextField.text ?? "", "zipCode": zipTextField.text ?? "", "pickupInstructions": pickUpInstructionTextField.text ?? "", "availableFromDate": availableFromDate, "availableToDate": availableToDate,"imageUrls":""]
            DispatchQueue.global(qos: .userInteractive).async {
                self.networkManager.updateProductRequest(addProductDict: addProductDict, completion: { (resultDictionary, error) in
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
                            
                            
                            if resultDictionary.keys.contains("message") {
                                let productIDtemp = resultDictionary["productID"] as! NSNumber
                                let parameter = ["productID": productIDtemp.stringValue,"zipCode":self.zipTextField.text ?? ""]
                                
                                var arrImage = [UIImage]()
                                
                                for item in self.imageArray{
                                    
                                    if (item["kind"] as? String) == "image"{
                                        arrImage.append(item["image"] as! UIImage)
                                        
                                    }
                                    
                                }
                                if arrImage.count > 0{
                                self.networkManager.addProductImages(Productimages: arrImage, param: parameter) { (resultDictionary, error) in
                                    self.hideHUD()
                                    if resultDictionary.keys.contains("message") {
                                    //let message = resultDictionary["message"] as! String
                                     self.Makethisproductlive(zipcode: self.zipTextField.text ?? "", productID : productIDtemp.stringValue)
                                    
                                        }
                                    }
                                }else{
                                   self.hideHUD()
                                     self.Makethisproductlive(zipcode: self.zipTextField.text ?? "", productID : productIDtemp.stringValue)
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
        } else {
            showAlert(withTitle: "Missing Data", message: errorMessage)
        }
    }
    
    func Makethisproductlive(zipcode : String, productID : String) {
        self.showHUD()
        self.networkManager.ServiceWithPOSTMethod(URLStr: "/products/makeLive", addProductDict: ["productID" : productID, "zipCode":zipcode ]) { (resultDictionary, error) in
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
            
        }
        
        
        
    }
    
    // MARK: - UICollection View Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imageArray.count == 4 {
            return imageArray.count
        }
        else{
            return imageArray.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageLoadCell", for: indexPath) as! ImageLoadCell
        if((imageArray.count > 0 && (collectionView.numberOfItems(inSection: indexPath.section)) - 1 != indexPath.row) || (imageArray.count == 4))
        {
            let dictselect = self.imageArray[indexPath.row]
            //["kind" : "image", "image":image]
           
            if (dictselect["kind"] as? String ?? "") == "image"{
                cell.imgItem.image = dictselect["image"] as? UIImage
            }else{
                LoadImage().load(imageView: cell.imgItem, url: dictselect["image"] as? String ?? "")
            }
            cell.imgItem.layer.cornerRadius = cell.imgItem.frame.height/2
            cell.imgItem.clipsToBounds = true
            cell.img_background.layer.cornerRadius = cell.img_background.frame.size.height/2
            cell.img_background.layer.borderColor = UIColor(red: 54.0 / 255.0, green: 193.0 / 255.0, blue: 195.0 / 255.0, alpha: 1).cgColor
            cell.img_background.layer.borderWidth = 1.0
            cell.img_background.clipsToBounds = true
            cell.delegate = self
            cell.btn_Cancel.isHidden = false
        }else{
            cell.imgItem.image = UIImage(named: "uploadImagePlaceholder")
            cell.btn_Cancel.isHidden = true
        }
        return cell
    }
    
    
    func actionbtnCancelBtnClicked(index: Int) {
        
        if self.imageArray.count == 1{
            
          self.showAlert(withTitle: kErrorTitle, message: "Please uplaod another image before deleting last image.")
        }else{
         let dictselect = self.imageArray[index]
        if (dictselect["kind"] as? String ?? "") == "image"{
            self.imageArray.remove(at: index)
            self.imageCollectionView.reloadData()
        }else{
          let imageURL = dictselect["image"] as? String ?? ""
            let imageURLLastComponent = (imageURL as NSString).lastPathComponent
            let parameter = ["productID" : objitem.productID, "imageName" : imageURLLastComponent, "deleteType": true] as [String : Any]
            self.showHUD()
                self.networkManager.ServiceWithPOSTMethod(URLStr: "/images/delete", addProductDict: parameter) { (resultDictionary, error) in
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
                                                                                                self.imageArray.remove(at: index)
                                                                                                self.imageCollectionView.reloadData()
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
                    
                }
            
            }
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if ((imageArray.count > 0 && (collectionView.numberOfItems(inSection: indexPath.section)) - 1 != indexPath.row) || (imageArray.count == 4))
        {
            let imageVC = AddProductImageViewController.init()
            imageVC.view.backgroundColor = UIColor(red: (0.0/255.0), green: (0.0/255.0), blue: (0.0/255.0), alpha: 0.5)
            imageVC.modalPresentationStyle = .overFullScreen
            self.present(imageVC, animated: true, completion: nil)
        }
        else
        {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera;
                imagePicker.allowsEditing = true
                imagePicker.cameraCaptureMode = UIImagePickerController.CameraCaptureMode.photo
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                self.showAlert(withTitle: kErrorTitle, message: "Device has no camera")
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if picker.sourceType == UIImagePickerController.SourceType.camera
        {
            var image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            image = self.rotateImage(image: image)!
            let dicttemp = ["kind" : "image", "image":image] as [String : Any]
            imageArray.append(dicttemp)
            picker.dismiss(animated: false) {
                self.imageCollectionView.reloadData()
            }
        }
    }
    
    func rotateImage(image: UIImage) -> UIImage? {
        if (image.imageOrientation == UIImage.Orientation.up ) {
            return image
        }
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return copy
    }
}
