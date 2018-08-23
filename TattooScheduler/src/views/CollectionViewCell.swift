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
    
    let indicatorColors:[Int: UIColor] = [1:#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), 2:#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), 3:#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), 4:#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)]
    
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
            var color = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            let eventCount = todayEvents!.count
            switch (eventCount) {
            case 1:
                color = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                break
            case 2:
                color = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                break
            case 3:
                color = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
                break
            default:
                break
            }
            
            indicator.color = color
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
