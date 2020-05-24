//
//  HomeCollectionViewCell.swift
//  Leezed
//
//  Created by Neha Gupta on 17/09/19.
//  Copyright © 2019 Shertech. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {

    
    
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        lblCategoryName.textColor = .white
        lblCategoryName.font = LeezedFont.KGothicBoldFontWithSize(size: 16)
        categoryImageView.layer.cornerRadius = 8.0
        categoryImageView.clipsToBounds = true
    }
}
