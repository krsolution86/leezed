//
//  ImageLoadCell.swift
//  Leezed
//
//  Created by shivam tripathi on 14/04/20.
//  Copyright © 2020 Shertech. All rights reserved.
//

import UIKit

@objc protocol EditProductitemCellDelegate : class
{
   @objc func actionbtnCancelBtnClicked(index: Int)
    
}


class ImageLoadCell: UICollectionViewCell {

    @IBOutlet weak var btn_Cancel: UIButton!
    @IBOutlet weak var img_background: UIImageView!
    @IBOutlet weak var imgItem: UIImageView!
    var delegate : EditProductitemCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func actbtn_CancelbtnClicked(_ sender: Any) {
    let btn = sender as! UIButton
            
            if self.delegate != nil{
                
                self.delegate?.actionbtnCancelBtnClicked(index: btn.tag)
            }
            
        }
}
