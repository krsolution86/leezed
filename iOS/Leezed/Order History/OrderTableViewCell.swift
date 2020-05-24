//
//  OrderTableViewCell.swift
//  Leezed
//
//  Created by Neha Gupta on 26/12/19.
//  Copyright © 2019 Shertech. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var expandableImageView: UIImageView!
    @IBOutlet weak var orderTypeImageView: UIImageView!
    
    @IBOutlet weak var detailView: UIView!
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
    @IBOutlet weak var xDetailViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var xDetailViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var xOrderNameTopConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
