//
//  CollectionViewCell.swift
//  TattooScheduler
//
//  Created by Artem on 29.07.2018.
//  Copyright © 2018 Artem. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    static let height: CGFloat = 60
    
    @IBOutlet weak var indicator: Indicator!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        // Initialization code
    }

    func turnIndicator(withValue v: Bool) {
        indicator?.isHidden = !v
    }
}
