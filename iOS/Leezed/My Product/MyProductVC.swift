//
//  MyProductVC.swift
//  Leezed
//
//  Created by shivam tripathi on 08/04/20.
//  Copyright © 2020 Shertech. All rights reserved.
//

import UIKit
 


class MyProductVC: UIViewController, UITableViewDelegate,UITableViewDataSource, MyProductitemCellDelegate {
    func actionEditBtnPressed(index: Int) {
        let objitem = self.arrProduct[index]
        let objEditVC = EditProductVC()
        objEditVC.objitem = objitem
        self.navigationController?.pushViewController(objEditVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let objcell = tableView.dequeueReusableCell(withIdentifier: "MyProductitemCell") as! MyProductitemCell
        let objProduct = self.arrProduct[indexPath.row]
        objcell.btn_Edit.tag  = indexPath.row
        objcell.lbl_productName.text = objProduct.name
        objcell.selectionStyle = UITableViewCell.SelectionStyle.none
        objcell.backgroundColor = UIColor.clear
        objcell.layer.cornerRadius = 4
        objcell.layer.borderColor = LeezedColors().kOrangeBaseColor.cgColor
        objcell.layer.borderWidth = 2
        objcell.layer.masksToBounds = true
        objcell.delegate = self
        objcell.btn_Edit.tag = indexPath.row
        
        
        return objcell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let objProductdetail = MyProductDetailVC()
        objProductdetail.objitem = self.arrProduct[indexPath.row]
        self.navigationController?.pushViewController(objProductdetail, animated: true)
    }
    
    
    @IBOutlet weak var tbl_product: UITableView!
    @IBOutlet weak var lblNoProduct: UILabel!
    var networkManager = NetworkManager.retrieveManager
    var arrProduct = [MyproductItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        tbl_product.register(UINib(nibName: "MyProductitemCell", bundle: nil), forCellReuseIdentifier: "MyProductitemCell")
        self.LoadMyProduct()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
    }
    @IBAction func actbtn_LenditembtnClicked(_ sender: Any) {
        let obj_addRent = AddRentItemsViewController()
                   obj_addRent.isCalledFromview = true
                   self.navigationController?.pushViewController(obj_addRent, animated: true)
        
    }
    
    func LoadMyProduct(){
        showHUD()
               DispatchQueue.global(qos: .userInteractive).async {
                   self.networkManager.getMyProductList({ (tempOrders, error) in
                       
                       if error != nil {
                           DispatchQueue.main.async {
                               self.hideHUD()
                               if error?.localizedDescription == "The data couldn’t be read because it isn’t in the correct format."{
                                   let okAction = UIAlertAction(title: NSLocalizedString(KAlertOkButtonTitle, comment: ""), style: .default, handler: { action in
                                                                   self.networkManager.LoadLoginView()
                                                              })
                                                              self.showConfirmationAlert(alertTitle: kUnauthorizedError, alertMessage: "Please login again", actionsArray: [okAction])
                                   
                                   
                               }else{
                                  self.showAlert(withTitle: kErrorTitle, message: error?.localizedDescription ?? "Service Error")
                               }
                           }
                       } else {
                        self.arrProduct.removeAll()
                          self.arrProduct = tempOrders
                           DispatchQueue.main.async {
                               self.hideHUD()
                               
                               if self.arrProduct.count > 0 {
                                   self.tbl_product.isHidden = false
                                   self.lblNoProduct.isHidden = true
                                   self.tbl_product.reloadData()
                               } else {
                                   self.tbl_product.isHidden = true
                                   self.lblNoProduct.isHidden = false
                               }
                           }
                       }
                   })
               }
    }
    
    @IBAction func actbtn_menubtnClicked(_ sender: Any) {
   self.slideMenuController()?.openLeft()
    
    
    }
}
