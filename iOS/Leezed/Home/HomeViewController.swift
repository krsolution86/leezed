//
//  HomeViewController.swift
//  Leezed
//
//  Created by Neha Gupta on 31/08/19.
//  Copyright © 2019 Shertech. All rights reserved.
//

import UIKit
import CoreLocation
import Kingfisher

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate,UITextFieldDelegate, SearchDelegate {
    
    

    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var lblNoresult: UILabel!

    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var locationView: UIView!
    
    
    var arrProducts = [Products]()
    var searchtemp = [Products]()
    var networkManager = NetworkManager.retrieveManager
    var gradientView:UIView = UIView()
    var latitude = 0.0
    var longitude = 0.0
    var postalCode = ""
    var strCity = ""
    var strState = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        self.lblNoresult.isHidden = true
        categoryCollectionView.register(UINib.init(nibName: "HomeCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "homeCell")
        categoryCollectionView.isPagingEnabled = false
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 220, height: 180)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        searchView.layer.cornerRadius = 4
        searchView.layer.masksToBounds = true
        
        locationView.layer.cornerRadius = 4
        locationView.layer.masksToBounds = true
        
        
        let postalCode = Defaults.retrieveDefaults.getPostalCode()
        
        if String.isEmpty(str: postalCode) {
            Defaults.retrieveDefaults.setPostalCode(code: "07652")
            self.GetCityViaZipCode(zipcode: "07652")
        }else{
            self.GetCityViaZipCode(zipcode: postalCode)
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
                            let lattemp = result["lat"] as? NSNumber ?? NSNumber()
                            let longtemp = result["lon"] as? NSNumber ?? NSNumber ()
                         self.latitude = lattemp.doubleValue
                         self.longitude = longtemp.doubleValue
                         self.locationTextField.text = self.strCity + ", " + self.strState
                        self.fetchProductsBasedOnZipCode(latitude: self.latitude, longitude: self.longitude)
                        }else if result.keys.contains("error"){
                         
                         let message = result["message"] as? String ?? ""
                         let okAction = UIAlertAction(title: NSLocalizedString(KAlertOkButtonTitle, comment: ""), style: .default, handler: { action in
                             self.strCity = ""
                             self.strState =  ""
                             self.latitude = 0.0
                             self.longitude = 0.0
                             self.locationTextField.text = " "
                         })
                         self.showConfirmationAlert(alertTitle: kUnauthorizedError, alertMessage: message, actionsArray: [okAction])
                         
                     }
                    }
                }
            })
        )
        
        
        }
        
    }
    
    

    func fetchProductsBasedOnZipCode(latitude : Double, longitude: Double) {
        showHUD()
     self.networkManager.getSearchProduct(String(format: "%.2f", latitude), long: String(format: "%.2f", longitude), completion: { (tempProducts, error) in
                        
                        if error != nil {
                            DispatchQueue.main.async {
                                self.hideHUD()
                                self.showAlert(withTitle: kErrorTitle, message: error?.localizedDescription ?? "Service Error")
                            }
                        } else {
                            self.arrProducts = tempProducts
                            self.searchtemp = tempProducts
                             DispatchQueue.main.async {
                            self.hideHUD()
                                if self.arrProducts.count == 0{
                                    self.lblNoresult.isHidden = false
                                    self.categoryCollectionView.isHidden = true
                                }else
                                {
                                  self.lblNoresult.isHidden = true
                                    self.categoryCollectionView.isHidden = false
                                }
                            self.categoryCollectionView.reloadData()
                            }
                        }
                    })
                }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        
    }
    
    @IBAction func actbtn_LenditembtnClicked(_ sender: Any) {
        
        let authToken = Defaults.retrieveDefaults.getAuthToken()
        if String.isEmpty(str: authToken) {
            let loginViewController = UINavigationController(rootViewController: LoginViewController())
            self.slideMenuController()?.changeMainViewController(loginViewController, close: true)
           
            
        }else{
            let obj_addRent = AddRentItemsViewController()
            obj_addRent.isCalledFromview = true
            self.navigationController?.pushViewController(obj_addRent, animated: true)
            
        }
        
        
        
        
        
    }
    
    
    
    // MARK: - UICollection View Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as! HomeCollectionViewCell
        
        let objProduct = arrProducts[indexPath.row]
        let temstr = objProduct.Name + "\n " + "$ " + String(objProduct.RentPrice) + " " + objProduct.DurationUnitDesc
        cell.lblCategoryName.text = temstr
        LoadImage().load(imageView: cell.categoryImageView, url: objProduct.ThumbnailUrl)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width/2)-32, height: ((self.view.frame.width/2)-32) + 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemDetailsVC = ItemDetailsViewController()
        itemDetailsVC.selectedProduct = arrProducts[indexPath.row]
        self.navigationController?.pushViewController(itemDetailsVC, animated: true)
    }
    
    @IBAction func profileButtonTapped(_ sender: Any) {
        
        let authToken = Defaults.retrieveDefaults.getAuthToken()
        
        if String.isEmpty(str: authToken) {
             self.networkManager.LoadLoginView()
        } else {
            let profileVC = UINavigationController(rootViewController: MyProfileViewController())
            self.slideMenuController()?.changeMainViewController(profileVC, close: true)
        }
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        self.slideMenuController()?.openLeft()
    }
    
//    let resultPredicate = NSPredicate(format: "name contains[cd] %@", searchText)
//
//    let filtered = allDatasource.filter {
//        resultPredicate.evaluate(with: $0)
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        if textField == searchTextField{
        let strtemp = (textField.text ?? "") + string
        
        if strtemp == ""{
            arrProducts = self.searchtemp

        }else{
        let resultPredicate = NSPredicate(format: "self contains[cd] %@", strtemp)
        
            arrProducts = arrProducts.filter {
                resultPredicate.evaluate(with: $0.Name)
            }
            self.categoryCollectionView.reloadData()
            
        }
            return true
        }else{
        return true
            
            
        }
        
       
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool{
        
        if textField == searchTextField{
            if searchTextField.text == ""{
            arrProducts = self.searchtemp
            }
            self.categoryCollectionView.reloadData()
            
        }
        
      return true
    }
    
    @IBAction func findButtonTapped(_ sender: Any) {
//        showHUD()
//        DispatchQueue.global(qos: .userInteractive).async {
//            self.networkManager.getSearchProduct("", completion: { (tempProducts, error) in
//
//                if error != nil {
//                    DispatchQueue.main.async {
//                        self.hideHUD()
//                        self.showAlert(withTitle: kErrorTitle, message: error?.localizedDescription ?? "Service Error")
//                    }
//                } else {
//                    self.arrProducts = tempProducts
//                    DispatchQueue.main.async {
//                        self.hideHUD()
//                        self.categoryCollectionView.reloadData()
//                    }
//                }
//            })
//        }
    }
    
    @IBAction func nearButtonTapped(_ sender: Any) {
        
        let objVC = SearchVC()
        objVC.delegate = self
        self.present(objVC, animated: true, completion: nil)
    }
    
    
    func searchCityFromSearchView(zipCode: String, strcity: String, strState: String, latitude: String, longitude: String) {
        self.strCity = strcity
         self.strState = strState
        self.latitude = Double(latitude) ?? 0.00
        self.longitude = Double(longitude) ?? 0.00
         self.locationTextField.text = self.strCity + ", " + self.strState
        
        self.fetchProductsBasedOnZipCode(latitude: self.latitude, longitude: self.longitude)
        
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return false
    }
    
    func showGradiedntViewForPopOver()
    {
        gradientView = UIView(frame: (self.navigationController?.view.bounds)!)
        gradientView.backgroundColor = LeezedColors().popoverViewGradientColor
        gradientView.layer.opacity = 0.5
        self.navigationController?.view.addSubview(gradientView)
    }
    func hideGradientViewForPopOver()  {
        gradientView.removeFromSuperview()
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

extension HomeViewController : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
//        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
//        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
//        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
//        print("SlideMenuControllerDelegate: leftDidClose")
    }
}

extension HomeViewController:locationSearchDelegate {
    func searchProductsBasedOnZipCode(zipCode: String, strcity: String, strState: String, latitude: Double, longitude: Double) {
        hideGradientViewForPopOver()
        self.strCity = strcity
        self.strState = strState
        self.latitude = latitude
        self.longitude = longitude
        self.locationTextField.text = self.strCity + ", " + self.strState
       self.fetchProductsBasedOnZipCode(latitude: latitude, longitude: longitude)
    }
    
    func closeLocationSearchPopOver() {
        hideGradientViewForPopOver()
    }
    
}
