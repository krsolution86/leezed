//
//  PendingApprovalsViewController.swift
//  Leezed
//
//  Created by Neha Gupta on 21/12/19.
//  Copyright © 2019 Shertech. All rights reserved.
//

import UIKit

class PendingApprovalsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PendingConfrimationDelegate {
    
    

    @IBOutlet weak var ordersTableView: UITableView!
    @IBOutlet weak var lblMessage: UILabel!
    
    var arrOrderList  = [OrderList]()
    var networkManager = NetworkManager.retrieveManager

    var selectedRowIndex: Int? = nil
    var userID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        
        ordersTableView.register(UINib.init(nibName: "PendingApprovalTableViewCell", bundle: nil), forCellReuseIdentifier:"headerCell")
        let userProfile = Defaults.retrieveDefaults.getUserProfile()
        
        if (userProfile["userID"] as? String) != nil{
            self.userID = userProfile["userID"] as! String
        }else{
            self.userID = String(userProfile["userID"] as! Int)
        }
        self.LoadCurrentOrder()
       
    }
    
    func  LoadCurrentOrder() {
        showHUD()
               DispatchQueue.global(qos: .userInteractive).async {
                   self.networkManager.getMyOrderList({ (tempOrders, error) in
                       
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
                        self.arrOrderList.removeAll()
                           self.arrOrderList = tempOrders.filter{$0.IsApproved == 0}
                           DispatchQueue.main.async {
                               self.hideHUD()
                               
                               if self.arrOrderList.count > 0 {
                                   self.ordersTableView.isHidden = false
                                   self.lblMessage.isHidden = true
                                   self.ordersTableView.reloadData()
                               } else {
                                   self.ordersTableView.isHidden = true
                                   self.lblMessage.isHidden = false
                               }
                           }
                       }
                   })
               }
    }

    // MARK: - UITableView Methods
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = .zero
        }
        
        // Prevent the cell from inheriting the Table View's margin settings
        if cell.responds(to: #selector(setter: UITableViewCell.preservesSuperviewLayoutMargins)) {
            cell.preservesSuperviewLayoutMargins = false
        }
        
        // Explictly set your cell's layout margins
        if cell.responds(to: #selector(setter: UITableViewCell.layoutMargins)) {
            cell.layoutMargins = .zero
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            
            if indexPath.section == selectedRowIndex {
                return 530.0
            }
            return 60.0
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 1))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrOrderList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : PendingApprovalTableViewCell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! PendingApprovalTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.detailView.backgroundColor = UIColor.clear
        cell.detailView.layer.cornerRadius = 4
        cell.detailView.layer.borderColor = LeezedColors().kOrangeBaseColor.cgColor
        cell.detailView.layer.borderWidth = 2
        cell.detailView.layer.masksToBounds = true
        
        let currentOrder = arrOrderList[indexPath.section]
        cell.lblOrderNo.text = "#\(String(currentOrder.OrderID))"
        
        cell.lblProductName.text = currentOrder.ProductName
        cell.lblProductPrice.text = "$\(String(currentOrder.RentPrice))"
        cell.lblRentedFrom.text = currentOrder.RentedFrom
        cell.lblRequestedBy.text = currentOrder.RequestedBy
        cell.lblRentalStart.text = String.refineDateFormat(sourceFormat: "yyyy-MM-dd'T'HH:mm:ss.000Z", destinationFormat: "MMM dd, yyyy", sourceString: currentOrder.RentalStartDate)
        cell.lblRentalEnd.text = String.refineDateFormat(sourceFormat: "yyyy-MM-dd'T'HH:mm:ss.000Z", destinationFormat: "MMM dd, yyyy", sourceString: currentOrder.RentalEndDate)
        cell.lblAddress.text = currentOrder.Location
        cell.lblPickupInstructions.text = currentOrder.PickupInstructions
        cell.lblComments.text = currentOrder.ApprovalComments
      
        if self.userID == String(currentOrder.UserID){
            cell.btnApprove.isHidden = true
            cell.btnDecline.isHidden = true
            
        }else{
            cell.btnApprove.isHidden = false
            cell.btnDecline.isHidden = false
            cell.btnApprove.tag = indexPath.section
            cell.btnApprove.addTarget(self, action: #selector(self.btnApproveTapped(_:)), for: .touchUpInside)
                   
            cell.btnDecline.tag = indexPath.section
            cell.btnDecline.addTarget(self, action: #selector(self.btnDeclineTapped(_:)), for: .touchUpInside)
        }
       
        
        
        if selectedRowIndex == indexPath.section {
           // cell.expandableImageView.image = UIImage(named: "expand")
            cell.detailView.isHidden = false
            cell.xDetailViewHeightConstraint.constant = 460
        } else {
            //cell.expandableImageView.image = UIImage(named: "collapse")
            cell.detailView.isHidden = true

            cell.xDetailViewHeightConstraint.constant = 0

        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (selectedRowIndex == indexPath.section && selectedRowIndex != nil) {
            selectedRowIndex = nil
            tableView.reloadData()
        } else {
            selectedRowIndex = indexPath.section
            tableView.reloadData()
        }
        
//        var cell = tableView.cellForRow(at: indexPath) as? OrderTableViewCell
    }
    
    @objc func btnApproveTapped(_ Sender: Any?) {
        
        let tappedButton = Sender as? UIButton
        let currentOrder = arrOrderList[tappedButton?.tag ?? 0]
        
        let obj = PendingitemConfirmVC()
        obj.delegate = self
        obj.index = tappedButton?.tag ?? 0
        obj.OrderNumber = currentOrder.OrderID
        obj.isApprovalbtnChoosed = true
        self.present(obj, animated: true, completion: nil)
        
        
        
        
    }
    func Okbtnclicked(Comment: String, index: Int, isApproved:Bool) {
            let currentOrder = self.arrOrderList[index]
        self.showHUD()
            let ProductDict: [String: Any] = ["productID": currentOrder.ProductID, "orderID": currentOrder.OrderID, "isApproved": isApproved, "approvalComments": Comment]
            
            DispatchQueue.global(qos: .userInteractive).async {
                self.networkManager.productOrderApproval(ProductApprovalDict: ProductDict, completion: { (resultDictionary, error) in
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
                                    let okAction = UIAlertAction(title: NSLocalizedString(KAlertOkButtonTitle, comment: ""), style: .default, handler: { action in
                                        self.LoadCurrentOrder()
                                    })
                                    self.showConfirmationAlert(alertTitle: "", alertMessage:message, actionsArray: [okAction])
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
        
    
    @objc func btnDeclineTapped(_ Sender: Any?) {
        
        let tappedButton = Sender as? UIButton
        let currentOrder = arrOrderList[tappedButton?.tag ?? 0]
        
        let obj = PendingitemConfirmVC()
        obj.delegate = self
        obj.index = tappedButton?.tag ?? 0
        obj.OrderNumber = currentOrder.OrderID
        obj.isApprovalbtnChoosed = false
        self.present(obj, animated: true, completion: nil)
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
    
    @IBAction func actbtn_itemLendbtnClciked(_ sender: Any) {
        let obj_addRent = AddRentItemsViewController()
        obj_addRent.isCalledFromview = true
        self.navigationController?.pushViewController(obj_addRent, animated: true)
        
    }
    @IBAction func logoHomeButtonTapped(_ sender: Any) {
        let homeViewController = UINavigationController(rootViewController: HomeViewController())
        self.slideMenuController()?.changeMainViewController(homeViewController, close: true)
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
