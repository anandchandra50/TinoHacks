//
//  RoundedButton.swift
//  TinoHacks
//
//  Created by Anand Chandra on 4/15/17.
//  Copyright © 2017 AnandChandraMichaelWu. All rights reserved.
//

import UIKit

@IBDesignable class RoundedButton: UIButton
{
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
    }
}
