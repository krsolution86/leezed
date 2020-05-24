//
//  AddRentItemsViewController.swift
//  Leezed
//
//  Created by Neha Gupta on 12/11/19.
//  Copyright © 2019 Shertech. All rights reserved.
//

import UIKit
import DropDown
import IQKeyboardManagerSwift

class AddRentItemsViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    var networkManager = NetworkManager.retrieveManager
    var categoryArray = [Categories]()
    
    @IBOutlet weak var tblview: UITableView!
    @IBOutlet var view_header: UIView!
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
    var imageArray = [UIImage]()
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
    var isCalledFromview = false
    
    @IBOutlet weak var btn_menu: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        tblview.tableHeaderView = self.view_header
        if isCalledFromview{
            btn_menu.setImage(UIImage.init(named: "Backbutton"), for: .normal)
            btn_menu.setImage(UIImage.init(named: "Backbutton"), for: .normal)
            btn_menu.setImage(UIImage.init(named: "Backbutton"), for: .normal)
            
        }else{
            //Hamburger Menu
            btn_menu.setImage(UIImage.init(named: "Hamburger Menu"), for: .normal)
            btn_menu.setImage(UIImage.init(named: "Hamburger Menu"), for: .highlighted)
            btn_menu.setImage(UIImage.init(named: "Hamburger Menu"), for: .selected)
        }
        
        showHUD()
        DispatchQueue.global(qos: .userInteractive).async {
            self.networkManager.getCategories({ (result, error) in
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
        
        imageCollectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "imageCell")
        imageCollectionView.layer.cornerRadius = 8.0
        imageCollectionView.layer.masksToBounds = true
        imageCollectionView.layer.borderWidth = 1.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        
        //for handling keyboard
        IQKeyboardManager.shared.enable = true
    }

    @IBAction func menuButtonTapped(_ sender: Any) {
        if isCalledFromview {
            self.navigationController?.popViewController(animated: true)
        }else{
            self.slideMenuController()?.openLeft()
        }
        
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
        let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
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
            dropDown.dataSource = ["Per Day", "Per Week","Per Hour"]
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
            }   //["Per Day", "Per Week","Per Hour"]
            var strDuration = ""
            if durationTextField.text == "Per Day"{
                strDuration = "DAY"
            }else if  durationTextField.text == "Per Week"{
                strDuration = "WEEK"
            }else{
                 strDuration = "HOUR"
            }
            
            let addProductDict: [String: Any] = ["productID": NSNull(), "name": nameTextField.text ?? "", "description": descriptionTextField.text ?? "", "categoryID": categoryID, "rentPrice": priceTextField.text ?? "","minRental":minimalRentalTextField.text ?? ""
                , "durationUnit": strDuration, "city": self.strCity, "state": self.strState, "location": locationTextField.text ?? "", "zipCode": zipTextField.text ?? "", "pickupInstructions": pickUpInstructionTextField.text ?? "", "availableFromDate": availableFromDate, "availableToDate": availableToDate,"imageUrls":""]
            
            DispatchQueue.global(qos: .userInteractive).async {
                self.networkManager.addProductRequest(addProductDict: addProductDict, completion: { (resultDictionary, error) in
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
                                let productIDtemp = resultDictionary["productID"] as? NSNumber ?? 0
                                let parameter = ["productID": productIDtemp.stringValue,"zipCode":self.zipTextField.text ?? ""]
                                self.networkManager.addProductImages(Productimages: self.imageArray, param: parameter) { (resultDictionary, error) in
                                self.hideHUD()
                                    
                                    if error != nil {
                                        DispatchQueue.main.async {
                                            self.hideHUD()
                                            let okAction = UIAlertAction(title: NSLocalizedString(KAlertOkButtonTitle, comment: ""), style: .default, handler: { action in
                                                self.networkManager.LoadLoginView()
                                            })
                                            self.showConfirmationAlert(alertTitle: kUnauthorizedError, alertMessage: "Please login again", actionsArray: [okAction])
                                        }
                                    } else if resultDictionary.keys.contains("message") {
                                //let message = resultDictionary["message"] as! String

                                 self.Makethisproductlive(zipcode: self.zipTextField.text ?? "", productID : productIDtemp.stringValue)
                                
                                    }else if resultDictionary.keys.contains("errorMsg") {
                                        let errorMessage = resultDictionary["errorMsg"] as! String
                                        self.showAlert(withTitle: kErrorTitle, message: errorMessage)
                                    } else {
                                        self.showAlert(withTitle: kErrorTitle, message: "Server Error")
                                    }
                        }
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        if((imageArray.count > 0 && (collectionView.numberOfItems(inSection: indexPath.section)) - 1 != indexPath.row) || (imageArray.count == 4))
        {
            cell.productImageView.image = imageArray[indexPath.row]
            
            // Initialization code
            UIGraphicsBeginImageContextWithOptions(cell.productImageView.bounds.size, _: false, _: 1.0)
            let mybezierpath = UIBezierPath(roundedRect: cell.productImageView.bounds, cornerRadius: cell.productImageView.frame.size.height / 2)
            // Add a clip before drawing anything, in the shape of an rounded rect
            mybezierpath.addClip()
            // Draw your image
            cell.productImageView.image?.draw(in: cell.productImageView.bounds)
            
            // Get the image, here setting the UIImageView image
            cell.productImageView.image = UIGraphicsGetImageFromCurrentImageContext()
            
            // Lets forget about that we were drawing
            UIGraphicsEndImageContext()
            let circle = CAShapeLayer()
            circle.path = mybezierpath.cgPath
            circle.bounds = circle.path?.boundingBox ?? CGRect()
            circle.strokeColor = UIColor(red: 54.0 / 255.0, green: 193.0 / 255.0, blue: 195.0 / 255.0, alpha: 1).cgColor
            circle.cornerRadius = cell.productImageView.frame.size.height / 2
            circle.fillColor = UIColor.clear.cgColor //if you just want lines
            circle.lineWidth = 3
            circle.position = CGPoint(x: cell.productImageView.frame.size.width / 2.0, y: cell.productImageView.frame.size.height / 2.0)
            circle.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            circle.masksToBounds = true
            
            cell.productImageView.layer.addSublayer(circle)
        }else{
            cell.productImageView.image = UIImage(named: "uploadImagePlaceholder")
        }
        return cell
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
            
            var alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
            let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default)
             {
                UIAlertAction in
                self.openCamera()
             }
            let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertAction.Style.default)
             {
                UIAlertAction in
                self.openGallary()
             }
            var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
             {
                UIAlertAction in
             }

            // Add the actions
             alert.addAction(cameraAction)
             alert.addAction(gallaryAction)
             alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            
            
            
            
            
            
        }
    }
    
    func openCamera()
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
    func openGallary()
    {
      let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary;
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if picker.sourceType == UIImagePickerController.SourceType.camera
        {
            var image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            image = self.rotateImage(image: image)!
            imageArray.append(image)
            picker.dismiss(animated: false) {
                self.imageCollectionView.reloadData()
            }
        }else{
            var image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            image = self.rotateImage(image: image)!
            imageArray.append(image)
            picker.dismiss(animated: false) {
                self.imageCollectionView.reloadData()
            }
            
        }
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
