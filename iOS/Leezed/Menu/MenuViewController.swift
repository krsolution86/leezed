//
//  MenuViewController.swift
//  Leezed
//
//  Created by Neha Gupta on 31/08/19.
//  Copyright © 2019 Shertech. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    

    @IBOutlet weak var tblview: UITableView!
    var menus = ["Home", "Lend Items", "Pending Approvals", "My Products", "Transactions","Profile","How it works?","Contact Us","Logout"]
    var images = ["house", "cart", "lock.fill","square.grid.3x2" ,"pencil.circle", "person.circle","questionmark.square","message","arrow.counterclockwise.circle"]
    var index = -1
    var homeViewController: UIViewController!
    
    @IBOutlet weak var llb_name: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        tblview.register(UINib(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userProfile = Defaults.retrieveDefaults.getUserProfile()
        let userName = userProfile["screenName"]
        if userName != nil{
        self.llb_name.text = userName as? String
        }
    }
    
     func profileButtonTapped(_ sender: Any) {
        let authToken = Defaults.retrieveDefaults.getAuthToken()
        if String.isEmpty(str: authToken) {
            let loginViewController = UINavigationController(rootViewController: LoginViewController())
            self.slideMenuController()?.changeMainViewController(loginViewController, close: true)
        } else {
            let profileViewController = UINavigationController(rootViewController: MyProfileViewController())
            self.slideMenuController()?.changeMainViewController(profileViewController, close: true)
        }
    }
    
     func menuButtonTapped() {
        self.slideMenuController()?.closeLeft()
    }
    
     func addProductViewTapped() {
        let addProductViewController = UINavigationController(rootViewController: AddRentItemsViewController())
        self.slideMenuController()?.changeMainViewController(addProductViewController, close: true)
    }
    
    func MyProductViewTapped() {
        let objMyProductVC = UINavigationController(rootViewController: MyProductVC())
        self.slideMenuController()?.changeMainViewController(objMyProductVC, close: true)
    }

    
     func pendingApprovalsViewTapped() {
        let pendingApprovalsViewController = UINavigationController(rootViewController: PendingApprovalsViewController())
        self.slideMenuController()?.changeMainViewController(pendingApprovalsViewController, close: true)
    }
    
     func orderDetailViewTapped() {
        let ordersViewController = UINavigationController(rootViewController: OrdersViewController())
        self.slideMenuController()?.changeMainViewController(ordersViewController, close: true)
    }
    
     func myProfileViewTapped() {
        let myProfileViewController = UINavigationController(rootViewController: MyProfileViewController())
        self.slideMenuController()?.changeMainViewController(myProfileViewController, close: true)
    }
    
     func logoutViewTapped() {
        Defaults.retrieveDefaults.setAuthToken(token: "")
        
         let appdel = UIApplication.shared.delegate as? AppDelegate
        appdel?.LoadMenuWithoutLogin()
        //self.slideMenuController()?.changeMainViewController(loginViewController, close: true)
    }
    
    @IBAction func logoHomeButtonTapped(_ sender: Any) {
        let homeViewController = UINavigationController(rootViewController: HomeViewController())
        self.slideMenuController()?.changeMainViewController(homeViewController, close: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as? MenuCell
        cell?.llb_name.text = menus[indexPath.row]
        if #available(iOS 13.0, *) {
            //UIImage(named: images[indexPath.row])
            cell?.img_icon.image = UIImage(systemName: images[indexPath.row])
        } else {
            // Fallback on earlier versions
        }
        cell?.backgroundColor = UIColor.clear
        cell?.selectionStyle = .none
        if index == indexPath.row{
            cell?.img_backgrounfd.isHidden = false
        }else{
            cell?.img_backgrounfd.isHidden = true
        }
        return cell ?? MenuCell()
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        index = indexPath.row
        tblview.reloadData()
        switch indexPath.row {
        case 0:
            self.logoHomeButtonTapped(UIButton())
       case 1:
           print("Lend items")
            self.addProductViewTapped()
       case 2:
        self.pendingApprovalsViewTapped()
       case 3:
        print("Product")
        self.MyProductViewTapped()
       case 4:
      print("Transaction")
      self.orderDetailViewTapped() 
       case 5:
        self.profileButtonTapped(UIButton())
       case 6:
        print("How it works")
            if let url = URL(string: "https://www.leezed.com/how-it-works") {
                UIApplication.shared.open(url)
            }
       case 7:
        print("Contact Us")
            let Contactus = UINavigationController(rootViewController: ContactUSVC())
            Contactus.setNavigationBarHidden(true, animated: true)
            self.slideMenuController()?.changeMainViewController(Contactus, close: true)
            
       case 8:
        self.logoutViewTapped()

        default:
          self.logoHomeButtonTapped(UIButton())
        }
        
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
