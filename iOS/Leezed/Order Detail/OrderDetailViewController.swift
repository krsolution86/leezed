//
//  OrderDetailViewController.swift
//  Leezed
//
//  Created by Neha Gupta on 02/10/19.
//  Copyright © 2019 Shertech. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class OrderDetailViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {

    var selectedOrder = OrderList()
    var arrMessage = [[String : Any]]()
    @IBOutlet weak var tblOderDetail: UITableView!
    @IBOutlet var viewHeader: UIView!
    @IBOutlet weak var lblProductName: UILabel!
       @IBOutlet weak var lblProductPrice: UILabel!
       @IBOutlet weak var lblRentedFrom: UILabel!
       @IBOutlet weak var lblRequestedBy: UILabel!
       @IBOutlet weak var lblRentalStart: UILabel!
       @IBOutlet weak var lblRentalEnd: UILabel!
       @IBOutlet weak var lblAddress: UILabel!
       @IBOutlet weak var lblPickupInstructions: UILabel!
       @IBOutlet weak var lblComments: UILabel!
       @IBOutlet weak var textFieldMessage: UITextField!
       @IBOutlet weak var btnSubmit: UIButton!
    var networkManager = NetworkManager.retrieveManager
    var userID = ""
    var userScreenName = ""
    var otherUserID = ""
    var otherScreenName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
         tblOderDetail.register(UINib.init(nibName: "OrderDetailCell", bundle: nil), forCellReuseIdentifier: "OrderDetailCell")
        let userProfile = Defaults.retrieveDefaults.getUserProfile()
        if (userProfile["userID"] as? String) != nil{
            userID = userProfile["userID"] as! String
        }else{
            userID = String(userProfile["userID"] as! Int)
        }
        userScreenName = userProfile["screenName"] as! String
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        self.tblOderDetail.tableHeaderView = viewHeader
        tblOderDetail.estimatedRowHeight = 60.0
        tblOderDetail.rowHeight = UITableView.automaticDimension
        self.Loadheaderview()
        if self.userID == String(self.selectedOrder.UserID) {
            self.otherUserID = String(self.selectedOrder.RentedFromUserID)
        }else{
            self.otherUserID = String(self.selectedOrder.UserID)
        }
        self.loadOtherUserProfile()
    }
    
    func loadOtherUserProfile(){
           
           showHUD()
           DispatchQueue.global(qos: .userInteractive).async {
               
            self.networkManager.getUserProfile(userID:self.otherUserID ,{ (userProfileDictionary, error) in
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
                           if userProfileDictionary.keys.contains("screenName") {
                            self.otherScreenName = userProfileDictionary["screenName"] as! String
                            self.loadMessageForOrder()
                           }
                           
                           // Change the cosmos view rating
                       
                       }
                   }
               })
           }
           
           
       }
    
    
    
    func Loadheaderview() {
        self.lblProductName.text = self.selectedOrder.ProductName
               self.lblProductPrice.text = "\(String(self.selectedOrder.RentPrice))"
               self.lblRentedFrom.text = self.selectedOrder.RentedFrom
               self.lblRequestedBy.text = self.selectedOrder.RequestedBy
               self.lblRentalStart.text = String.refineDateFormat(sourceFormat: "yyyy-MM-dd'T'HH:mm:ss.000Z", destinationFormat: "MMM dd, yyyy", sourceString: self.selectedOrder.RentalStartDate)
               self.lblRentalEnd.text = String.refineDateFormat(sourceFormat: "yyyy-MM-dd'T'HH:mm:ss.000Z", destinationFormat: "MMM dd, yyyy", sourceString: self.selectedOrder.RentalEndDate)
               self.lblAddress.text = self.selectedOrder.Location
               self.lblPickupInstructions.text = self.selectedOrder.PickupInstructions
               self.lblComments.text = self.selectedOrder.ApprovalComments
               self.textFieldMessage.text = ""
               self.textFieldMessage.delegate = self
       
    }
    
    
    func loadMessageForOrder() {
               DispatchQueue.global(qos: .userInteractive).async {
                self.networkManager.getmessageFromOrder(orderID: String(self.selectedOrder.OrderID), { (tempOrders, error) in
                       
                       if error != nil {
                           DispatchQueue.main.async {
                               self.hideHUD()
                               self.showAlert(withTitle: kErrorTitle, message: error?.localizedDescription ?? "Service Error")
                           }
                       } else {
                        DispatchQueue.main.async {
                             self.hideHUD()
                        self.arrMessage.removeAll()
                        let history = tempOrders["chatHistory"] as? [[String : Any]] ?? [[String : Any]]()
                        
                        for value  in history {
                            self.arrMessage.append(value)
                        }
                        self.tblOderDetail.reloadData()
                        }
                           }
                       
                   })
               }
    }
    

    
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logoHomeButtonTapped(_ sender: Any) {
        let homeViewController = UINavigationController(rootViewController: HomeViewController())
        self.slideMenuController()?.changeMainViewController(homeViewController, close: true)
    }
    
    @IBAction func actbtn_submitbtnClicked(_ sender: Any) {
         
        let str = textFieldMessage.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if str == ""{
           self.showAlert(withTitle: kErrorTitle, message: "Please enter Message.")
            
        }else{
            showHUD()
            let placeRentDict: [String: Any] = ["orderID": String(self.selectedOrder.OrderID), "productID": String(self.selectedOrder.ProductID), "message": textFieldMessage.text ?? "","fromUserID":self.userID,"toUserID":self.otherUserID]
                       
                       DispatchQueue.global(qos: .userInteractive).async {
                           self.networkManager.PostMessge(placeRentDict: placeRentDict, completion: { (resultDictionary, error) in
                               if error != nil {
                                   DispatchQueue.main.async {
                                       self.hideHUD()
                                       let okAction = UIAlertAction(title: NSLocalizedString(KAlertOkButtonTitle, comment: ""), style: .default, handler: { action in
                                           
                                       })
                                    self.showConfirmationAlert(alertTitle: kUnauthorizedError, alertMessage: error?.localizedDescription ?? "", actionsArray: [okAction])
                                   }
                               } else {
                                   DispatchQueue.main.async {
                                    self.textFieldMessage.text = ""
                                       self.hideHUD()
                                       
                                       if resultDictionary.keys.contains("message") {
                                        self.loadMessageForOrder()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : OrderDetailCell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailCell", for: indexPath) as! OrderDetailCell
               cell.selectionStyle = UITableViewCell.SelectionStyle.none
               cell.backgroundColor = UIColor.clear
               cell.layer.cornerRadius = 4
               cell.layer.borderColor = LeezedColors().kOrangeBaseColor.cgColor
               cell.layer.borderWidth = 2
               cell.layer.masksToBounds = true
        
        let dicttemp = self.arrMessage[indexPath.row]
        let userSentmessage = dicttemp["fromUserID"] as? Int ?? 0
        let userMessage = dicttemp["message"] as? String ?? ""
        let time = dicttemp["createdAt"] as? String ?? ""
        if self.userID == String(userSentmessage){
            cell.lbl_userName.text = self.userScreenName
        }else{
            cell.lbl_userName.text = self.otherScreenName
            
        }
        cell.lbl_message.text = userMessage
        cell.lbl_time.text = String.refineDateFormat(sourceFormat: "yyyy-MM-dd'T'HH:mm:ss.000Z", destinationFormat: "MMM dd, yyyy", sourceString: time)
        
        
        
        return cell
    }

    private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }
    
}
