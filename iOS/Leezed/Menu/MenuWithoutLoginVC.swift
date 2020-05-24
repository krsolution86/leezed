//
//  MenuWithoutLoginVC.swift
//  Leezed
//
//  Created by shivam tripathi on 25/04/20.
//  Copyright © 2020 Shertech. All rights reserved.
//

import UIKit

class MenuWithoutLoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func actbtn_HowitWorks(_ sender: Any) {
        if let url = URL(string: "https://www.leezed.com/how-it-works") {
        UIApplication.shared.open(url)
        
        }
    }
    
    @IBAction func actbtn_LoginBtnClicked(_ sender: Any) {
       let loginViewController = UINavigationController(rootViewController: LoginViewController())
        self.slideMenuController()?.changeMainViewController(loginViewController, close: true)
        
    }
    

    @IBAction func actbtn_RegisterbtnClicked(_ sender: Any) {
        let objRegister = UINavigationController(rootViewController: SignupViewController())
        self.slideMenuController()?.changeMainViewController(objRegister, close: true)
       
        
    }
    @IBAction func actbtn_ContactUS(_ sender: Any) {
        let Contactus = UINavigationController(rootViewController: ContactUSVC())
                   Contactus.setNavigationBarHidden(true, animated: true)
                   self.slideMenuController()?.changeMainViewController(Contactus, close: true)
        
    }
    @IBAction func actbtn_homeBtnClicked(_ sender: Any) {
        
        let homeViewController = UINavigationController(rootViewController: HomeViewController())
        self.slideMenuController()?.changeMainViewController(homeViewController, close: true)
        
    }
}
