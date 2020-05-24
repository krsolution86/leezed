//
//  OrdersViewController.swift
//  Leezed
//
//  Created by Neha Gupta on 15/01/20.
//  Copyright © 2020 Shertech. All rights reserved.
//

import UIKit

class OrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
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
        
        ordersTableView.register(UINib.init(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "headerCell")
        let userProfile = Defaults.retrieveDefaults.getUserProfile()
        if (userProfile["userID"] as? String) != nil{
            userID = userProfile["userID"] as! String
        }else{
            userID = String(userProfile["userID"] as! Int)
        }
        self.loadOrder()
    }
    
    
    
    @IBAction func actbtn_itemLendbtnClciked(_ sender: Any) {
        let obj_addRent = AddRentItemsViewController()
        obj_addRent.isCalledFromview = true
        self.navigationController?.pushViewController(obj_addRent, animated: true)
        
    }
    
    func loadOrder()  {
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
                    self.arrOrderList = tempOrders.filter{$0.IsApproved == 1}
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
                return 460.0
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
        
        let cell : OrderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! OrderTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        cell.backgroundColor = UIColor.clear
        cell.layer.cornerRadius = 4
        cell.layer.borderColor = LeezedColors().kOrangeBaseColor.cgColor
        cell.layer.borderWidth = 2
        cell.layer.masksToBounds = true
        
        
        let currentOrder = arrOrderList[indexPath.section]
        cell.lblOrderNo.text = "#\(String(currentOrder.OrderID))"
        
        if String(currentOrder.UserID) == self.userID{
           //Borrowed_Btn
            cell.orderTypeImageView.image = UIImage(named: "Borrowed_Btn")
        }else{
          cell.orderTypeImageView.image = UIImage(named: "Lent_Btn")
        }
        //cell.orderTypeImageView.image = UIImage(named: "Lent_Btn")
        
        cell.lblProductName.text = currentOrder.ProductName
        cell.lblProductPrice.text = "\(String(format: "%.2f",currentOrder.RentPrice))"
        cell.lblRentedFrom.text = currentOrder.RentedFrom
        cell.lblRequestedBy.text = currentOrder.RequestedBy
        cell.lblRentalStart.text = String.refineDateFormat(sourceFormat: "yyyy-MM-dd'T'HH:mm:ss.000Z", destinationFormat: "MMM dd, yyyy", sourceString: currentOrder.RentalStartDate)
        cell.lblRentalEnd.text = String.refineDateFormat(sourceFormat: "yyyy-MM-dd'T'HH:mm:ss.000Z", destinationFormat: "MMM dd, yyyy", sourceString: currentOrder.RentalEndDate)
        cell.lblAddress.text = currentOrder.Location
        cell.lblPickupInstructions.text = currentOrder.PickupInstructions
        cell.lblComments.text = currentOrder.ApprovalComments
        cell.textFieldMessage.text = ""
        cell.textFieldMessage.tag = indexPath.section
        cell.textFieldMessage.delegate = self
        
      
        cell.btnSubmit.tag = indexPath.section
        cell.btnSubmit.addTarget(self, action: #selector(self.btnSubmitTapped(_:)), for: .touchUpInside)
        
        if selectedRowIndex == indexPath.section {
            cell.expandableImageView.image = UIImage(named: "expand")
            cell.detailView.isHidden = false
            cell.xDetailViewHeightConstraint.constant = 400
            cell.xDetailViewTopConstraint.constant = 20
            cell.xOrderNameTopConstraint.constant = 20
        } else {
            cell.expandableImageView.image = UIImage(named: "collapse")
            cell.detailView.isHidden = true
            cell.xOrderNameTopConstraint.constant = 10
            cell.xDetailViewHeightConstraint.constant = 0
            cell.xDetailViewTopConstraint.constant = 0
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let currentOrder = arrOrderList[indexPath.section]
        let VC = OrderDetailViewController()
        VC.selectedOrder = currentOrder
        self.navigationController?.pushViewController(VC, animated: true)
        
//        if (selectedRowIndex == indexPath.section && selectedRowIndex != nil) {
//            selectedRowIndex = nil
//            tableView.reloadData()
//        } else {
//            selectedRowIndex = indexPath.section
//            tableView.reloadData()
//        }
    }
    
    @objc func btnSubmitTapped(_ Sender: Any?) {
        
        let tappedButton = Sender as? UIButton
        
        
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
