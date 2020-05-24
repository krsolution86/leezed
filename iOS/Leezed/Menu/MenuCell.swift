//
//  MenuCell.swift
//  Leezed
//
//  Created by shivam tripathi on 22/03/20.
//  Copyright © 2020 Shertech. All rights reserved.
// house, cart, lock.fill,square.grid.3x2,pencil.circle, person.circle,questionmark.square,message,arrow.counterclockwise.circle

import UIKit

class MenuCell: UITableViewCell {
    
    
    @IBOutlet weak var img_backgrounfd: UIImageView!
    @IBOutlet weak var img_icon: UIImageView!
    
    @IBOutlet weak var llb_name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
