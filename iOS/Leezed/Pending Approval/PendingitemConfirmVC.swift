//
//  PendingitemConfirmVC.swift
//  Leezed
//
//  Created by shivam tripathi on 01/04/20.
//  Copyright © 2020 Shertech. All rights reserved.
//

import UIKit

@objc protocol PendingConfrimationDelegate {
    
    @objc func Okbtnclicked(Comment: String, index: Int, isApproved:Bool)
    
}

class PendingitemConfirmVC: UIViewController {

    @IBOutlet weak var lbl_confirmation: UILabel!
    @IBOutlet weak var txtv_Comment: UITextView!
    var isApprovalbtnChoosed = false
    var OrderNumber = 0
    var index = -1
    var delegate : PendingConfrimationDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if self.isApprovalbtnChoosed{
            lbl_confirmation.text = "Do you want to " + "Approve the order no." + String(OrderNumber) + "?"
        }else{
            
          lbl_confirmation.text = "Do you want to " + "cancel the order no." + String(OrderNumber) + "?"
        }
        txtv_Comment.layer.cornerRadius = 8
        txtv_Comment.layer.borderWidth = 1
        txtv_Comment.layer.borderColor = UIColor.black.cgColor
        txtv_Comment.layer.masksToBounds = true
    }
    @IBAction func actbtn_CancelbtnClicked(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    
    }
    
    @IBAction func acbtn_OkbtnClicked(_ sender: Any) {
        
        if self.delegate != nil{
            self.delegate?.Okbtnclicked(Comment: txtv_Comment.text, index: index, isApproved: isApprovalbtnChoosed)
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    

}
