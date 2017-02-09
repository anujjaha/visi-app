//
//  VIZIUITextField.swift
//  VIZI
//
//  Created by Bhavik on 14/12/16.
//  Copyright © 2016 GWBB. All rights reserved.
//

import UIKit

class VIZIUITextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }
}
