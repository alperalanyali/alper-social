//
//  CustomButton.swift
//  alper-social
//
//  Created by Alper on 8.06.2018.
//  Copyright © 2018 Alper. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor(red: shadowGray, green: shadowGray, blue: shadowGray, alpha: shadowAlpha).cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = CGSize(width: shadowWidth, height: shadowHeight)
    }
}
