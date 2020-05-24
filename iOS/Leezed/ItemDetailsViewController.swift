//
//  ItemDetailsViewController.swift
//  Leezed
//
//  Created by Neha Gupta on 19/10/19.
//  Copyright © 2019 Shertech. All rights reserved.
//

import UIKit
import Cosmos

class ItemDetailsViewController: UIViewController {

    @IBOutlet weak var lblAvailableTill: UILabel!
    @IBOutlet weak var lblAvailablefrom: UILabel!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblItemNameWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblItemNameHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var btnRentNow: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblMinimumRental: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblOfferedBy: UILabel!
    @IBOutlet weak var srcValues: UIScrollView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnFrontarrow: UIButton!
    var selectedIndex = 0
    var selectedProduct = Products()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        self.srcValues.contentSize = CGSize(width: 0, height: 500)
        lblItemName.layer.cornerRadius = 8
        lblItemName.layer.masksToBounds = true
        lblItemName.textColor = LeezedColors().kOrangeBaseColor
        lblItemName.backgroundColor = LeezedColors().kBlackBaseColor
        lblItemName.font = LeezedFont.KGothicBoldFontWithSize(size: 16)
        
        //unarchive
        let newData = UserDefaults.standard.object(forKey: "key") as? Data
        var newDict: [AnyHashable : Any]? = nil
        if let newData = newData {
            newDict = NSKeyedUnarchiver.unarchiveObject(with: newData) as? [AnyHashable : Any]
        }
        
        let userProfile = Defaults.retrieveDefaults.getUserProfile()
        var userID = ""
        if userProfile.keys.contains("userID"){
        if (userProfile["userID"] as? String) != nil{
            userID = userProfile["userID"] as! String
        }else{
            userID = String(userProfile["userID"] as! Int)
        }
        }
        if self.selectedProduct.userID == Int(userID){
            self.btnRentNow.isHidden = true
        }

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
        
        lblPrice.text = String(format: "$%.2f ", selectedProduct.RentPrice).appending(selectedProduct.DurationUnitDesc)
        if selectedProduct.MinRental > 0 {
            lblMinimumRental.text = String(format: "$%.2f ",selectedProduct.MinRental)
        } else {
            lblMinimumRental.text = "N/A"
        }
        lblDescription.text = selectedProduct.Description
        lblCategory.text = selectedProduct.Category
        lblLocation.text = selectedProduct.Location
        lblOfferedBy.text = selectedProduct.userName
        lblAvailablefrom.text = self.ConvertStringToDate(ServerDate: selectedProduct.AvailableFromDate)
        lblAvailableTill.text = self.ConvertStringToDate(ServerDate: selectedProduct.AvailableToDate)
        if selectedProduct.imageURLS.count == 0{
            self.btnBack.isHidden = true
            self.btnFrontarrow.isHidden = true
        }
        
    }
    
    @IBAction func actbtn_arrowBackPressed(_ sender: Any) {
        if selectedIndex > 0 {
            selectedIndex = selectedIndex - 1
            self.loadImage(index: selectedIndex)
        }
        
    }
    @IBAction func actbtn_ArrowFrontBtnPressed(_ sender: Any) {
        if selectedIndex < selectedProduct.imageURLS.count-1 {
        selectedIndex = selectedIndex + 1
        self.loadImage(index: selectedIndex)
        }
    }
    
    func loadImage(index: Int){
        let URL = selectedProduct.imageURLS[index]
        LoadImage().load(imageView: productImageView, url: URL)
        
    }

    @IBAction func menuButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logoHomeButtonTapped(_ sender: Any) {
        let homeViewController = UINavigationController(rootViewController: HomeViewController())
        self.slideMenuController()?.changeMainViewController(homeViewController, close: true)
    }
    
    @IBAction func rentNowButtonTapped(_ sender: Any) {
        
        let authToken = Defaults.retrieveDefaults.getAuthToken()
        
        if String.isEmpty(str: authToken) {
            let signInVC = LoginViewController()
            self.navigationController?.pushViewController(signInVC, animated: true)
        } else {
            let rentItVC = RentItViewController()
            rentItVC.selectedProduct = selectedProduct
            self.navigationController?.pushViewController(rentItVC, animated: true)
        }
    }
    
    func ConvertStringToDate(ServerDate: String)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from:ServerDate)!
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: date)
        
        
        
    }

}
