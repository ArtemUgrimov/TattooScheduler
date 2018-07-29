//
//  Indicator.swift
//  TattooScheduler
//
//  Created by Artem on 29.07.2018.
//  Copyright © 2018 Artem. All rights reserved.
//

import UIKit

@IBDesignable class Indicator: UIView {

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        UIColor.red.setFill()
        path.fill()
    }
}
