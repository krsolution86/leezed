//
//  LeezedTextField.swift
//  Leezed
//
//  Created by Neha Gupta on 12/11/19.
//  Copyright © 2019 Shertech. All rights reserved.
//

import UIKit

@IBDesignable class LeezedTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 4.0
        self.autocorrectionType = .no
        self.font = LeezedFont.KGothicRegularFontWithSize(size: 15)
        self.textColor = LeezedColors().kBlackBaseColor
        self.backgroundColor = LeezedColors().kTextFieldBackgroundColor

        let dropDownView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 10))
        let dropDownImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 10))
        dropDownImageView.image = UIImage(named: "DropDownArrow")
        dropDownView.addSubview(dropDownImageView)
        dropDownView.isUserInteractionEnabled = false
        self.rightView = dropDownView
        self.rightViewMode = .always
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.size.height))
        leftPaddingView.isUserInteractionEnabled = false
        self.leftView = leftPaddingView
        self.leftViewMode = .always
                
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 1.0
    }
}

class LeezedEditableTextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 4.0
        self.autocorrectionType = .no
        self.font = LeezedFont.KGothicRegularFontWithSize(size: 15)
        self.textColor = LeezedColors().kBlackBaseColor
        self.backgroundColor = LeezedColors().kTextFieldBackgroundColor
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.size.height))
        leftPaddingView.isUserInteractionEnabled = false
        self.leftView = leftPaddingView
        self.leftViewMode = .always
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 1.0
    }
}
