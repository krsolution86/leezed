//
//  MyProductDetailVC.swift
//  Leezed
//
//  Created by shivam tripathi on 08/04/20.
//  Copyright © 2020 Shertech. All rights reserved.
//

import UIKit

class MyProductDetailVC: UIViewController {
    
    @IBOutlet weak var tblview: UITableView!
    @IBOutlet var view_header: UIView!
    
    @IBOutlet weak var imgthumbNail: UIImageView!
    
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_description: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lbldeposit: UILabel!
    @IBOutlet weak var lblavailableFrom: UILabel!
    @IBOutlet weak var lblAvailableTill: UILabel!
    @IBOutlet weak var lbl_city: UILabel!
    @IBOutlet weak var lbl_zipcode: UILabel!
    @IBOutlet weak var lbl_PickupInstruction: UILabel!
    var objitem: MyproductItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tblview.tableHeaderView = view_header
        self.LoadHeaderview()
    }
    
    func LoadHeaderview() {
        
        self.lbl_name.text = objitem.name
        self.lbl_price.text = "$" + String(objitem.rentPrice) + " " + objitem.durationUnitDesc
        self.lbl_description.text = objitem.productDesc
        self.lblCategory.text = objitem.categoryName
        self.lbldeposit.text = "$" + String(objitem.minRental)
        self.lblavailableFrom.text = String.refineDateFormat(sourceFormat: "yyyy-MM-dd'T'HH:mm:ss.000Z", destinationFormat: "MMM dd, yyyy", sourceString: objitem.availableFromDate)
        self.lblAvailableTill.text = String.refineDateFormat(sourceFormat: "yyyy-MM-dd'T'HH:mm:ss.000Z", destinationFormat: "MMM dd, yyyy", sourceString: objitem.availableToDate)
            
        self.lbl_city.text = objitem.location
        self.lbl_zipcode.text = String(objitem.zipCode)
        self.lbl_PickupInstruction.text = objitem.pickupInstructions
        LoadImage().load(imageView: self.imgthumbNail, url: objitem.thumbnailUrl)
    }

    @IBAction func actbtn_BackbtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actbtn_EditBtnClicked(_ sender: Any) {
        let objEditVC = EditProductVC()
        objEditVC.objitem = objitem
        self.navigationController?.pushViewController(objEditVC, animated: true)
        
        
    }
    

}
