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
    var vc: MainViewController?
    var date: Date? {
        didSet {
            updateIndicator()
        }
    }
    
    @IBOutlet weak var indicator: Indicator!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //layer.cornerRadius = 10

        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        self.addGestureRecognizer(gesture)
    }
    
    func updateIndicator() {
        if !(vc?.storage.getEvents(for: date!).isEmpty)! {
            turnIndicator(withValue: true)
        } else {
            turnIndicator(withValue: false)
        }
    }

    func turnIndicator(withValue v: Bool) {
        indicator?.isHidden = !v
    }
    
    @objc func onTap(_ sender: UITapGestureRecognizer) {
        vc?.goTo(date: date!)
    }
}
