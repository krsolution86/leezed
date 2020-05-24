//
//  MyProductitemCell.swift
//  Leezed
//
//  Created by shivam tripathi on 13/04/20.
//  Copyright © 2020 Shertech. All rights reserved.
//

import UIKit

@objc protocol MyProductitemCellDelegate : class
{
   @objc func actionEditBtnPressed(index: Int)
    
}

class MyProductitemCell: UITableViewCell {
    var delegate : MyProductitemCellDelegate?
    @IBOutlet weak var lbl_productName: UILabel!
    @IBOutlet weak var btn_Edit: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actbn_EditBtnClicked(_ sender: Any) {
        let btn = sender as! UIButton
        
        if self.delegate != nil{
            
            self.delegate?.actionEditBtnPressed(index: btn.tag)
        }
        
    }
}
