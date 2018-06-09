//
//  CustomField.swift
//  alper-social
//
//  Created by Alper on 8.06.2018.
//  Copyright © 2018 Alper. All rights reserved.
//

import UIKit

class CustomField: UITextField {

    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = UIColor(red: shadowGray, green: shadowGray, blue: shadowGray, alpha: shadowAlpha).cgColor
        layer.borderWidth = 2
        layer.cornerRadius = shadowRadius
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: boundX , dy: boundY)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
         return bounds.insetBy(dx: boundX , dy: boundY)
    }
}
