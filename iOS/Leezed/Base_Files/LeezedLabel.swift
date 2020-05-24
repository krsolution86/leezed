//
//  LeezedLabel.swift
//  Leezed
//
//  Created by Neha Gupta on 31/08/19.
//  Copyright © 2019 Shertech. All rights reserved.
//


import Foundation
import UIKit

class LeezedTitleLabel: UILabel {
   
    override func awakeFromNib() {
        super.awakeFromNib()
        changeFontName()
    }
   
    func changeFontName()
    {
        self.textColor = LeezedColors().kTitleLabelColor
        self.font = LeezedFont.KGothicBoldFontWithSize(size: 16)
        self.text = super.text
    }
}

class LeezedTitleLabelOrange: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        changeFontName()
    }
    
    func changeFontName()
    {
        self.textColor = LeezedColors().kOrangeBaseColor
        self.font = LeezedFont.KGothicBoldFontWithSize(size: 16)
        self.text = super.text
    }
}

