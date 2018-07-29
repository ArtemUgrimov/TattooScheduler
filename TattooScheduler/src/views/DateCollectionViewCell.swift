//
//  DateCollectionViewCell.swift
//  TattooScheduler
//
//  Created by Artem on 09.07.2018.
//  Copyright © 2018 Artem. All rights reserved.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var indicator: Indicator!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    func sharedInit() {
        refreshCorners(value: cornerRadius)
    }
    
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }
    
    @IBInspectable var cornerRadius: CGFloat = 20 {
        didSet {
            refreshCorners(value: cornerRadius)
        }
    }
    
    func turnIndicator(withValue v: Bool) {
        indicator?.isHidden = !v
    }
}
