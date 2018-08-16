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
    
    var year: Int = 0
    var month: Int = 0
    var day: Int = 0
    
    @IBOutlet weak var indicator: Indicator!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        self.addGestureRecognizer(gesture)
    }
    
    func updateIndicator() {
        if vc == nil || date == nil {
            return
        }
        
        let eventId = "\(year)_\(month)_\(day)"
        let todayEvents = vc?.eventsCache[eventId]
        
        if todayEvents != nil && !(todayEvents?.isEmpty)! {
            turnIndicator(withValue: true)
        } else {
            turnIndicator(withValue: false)
        }
        if vc?.year == year && vc?.month == month && vc?.day == day {
            self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            layer.cornerRadius = self.frame.width / 2
        } else {
            self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            layer.cornerRadius = 0
        }
    }

    func turnIndicator(withValue v: Bool) {
        indicator?.isHidden = !v
    }
    
    @objc func onTap(_ sender: UITapGestureRecognizer) {
        vc?.selectedCell = self
        vc?.goTo(date: date!)
    }
}
