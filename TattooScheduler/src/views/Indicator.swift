//
//  Indicator.swift
//  TattooScheduler
//
//  Created by Artem on 29.07.2018.
//  Copyright © 2018 Artem. All rights reserved.
//

import UIKit

@IBDesignable class Indicator: UIView {

    var color: UIColor = UIColor.red {
        didSet {
            backgroundColor = color
        }
    }
    
    override func awakeFromNib() {
        layer.cornerRadius = layer.frame.width * 0.5
    }
}
