//
//  PendingApprovalTableViewCell.swift
//  Leezed
//
//  Created by UshyakuMB2 on 25/01/20.
//  Copyright © 2020 Shertech. All rights reserved.
//

import UIKit
import Cosmos

class PendingApprovalTableViewCell: UITableViewCell {

    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var expandableImageView: UIImageView!
    
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var lblRentedFrom: UILabel!
    @IBOutlet weak var lblRequestedBy: UILabel!
    @IBOutlet weak var lblRentalStart: UILabel!
    @IBOutlet weak var lblRentalEnd: UILabel!
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPickupInstructions: UILabel!
    @IBOutlet weak var lblComments: UILabel!
    @IBOutlet weak var btnApprove: UIButton!
    @IBOutlet weak var btnDecline: UIButton!
    @IBOutlet weak var xDetailViewHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var xDetailViewTopConstraint: NSLayoutConstraint!
//    @IBOutlet weak var xOrderNameTopConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}




