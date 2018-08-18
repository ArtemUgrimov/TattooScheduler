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
    @IBOutlet weak var todayIndicator: TodayIndicator!
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
        todayIndicator?.isHidden = !(vc?.year == year && vc?.month == month && vc?.day == day)
    }

    func turnIndicator(withValue v: Bool) {
        indicator?.isHidden = !v
    }
    
    @objc func onTap(_ sender: UITapGestureRecognizer) {
        vc?.selectedCell = self
        vc?.goTo(date: date!)
    }
}
