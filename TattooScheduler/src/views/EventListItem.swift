//
//  EventListItem.swift
//  TattooScheduler
//
//  Created by Artem on 28.07.2018.
//  Copyright © 2018 Artem. All rights reserved.
//

import UIKit

@IBDesignable
class EventListItem: UITableViewCell {
    
    @IBOutlet weak var eventTypeLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var view: UIView!
    
    var event: CalendarEvent?
    var controller: EventViewController?
    
    var eventType: String = String()
    var eventTime: String = String()
    var desc: String = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        view.layer.cornerRadius = 20
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        self.addGestureRecognizer(gesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        let f = contentView.frame
//        let fr = UIEdgeInsetsInsetRect(f, UIEdgeInsetsMake(4, 0, 0, 0))
//        contentView.frame = fr
    }
    
    @objc func onTap(_ sender: Any) {
        controller!.edit(event: event!)
    }
    
    func updateText() {
        eventTypeLabel.text = eventType
        eventTimeLabel.text = eventTime
        descLabel.text = desc
        
        updateBackgroundColor()
    }
    
    func updateBackgroundColor() {
        switch eventType {
        case "Tattoo":
            eventTypeLabel.textColor = #colorLiteral(red: 0.9430051813, green: 0.2300890819, blue: 0.2300461844, alpha: 1)
            break
        case "Training":
            eventTypeLabel.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            break
        case "Massage":
            eventTypeLabel.textColor = #colorLiteral(red: 0.00193524558, green: 1, blue: 0.08592860449, alpha: 1)
            break
        case "Consult":
            eventTypeLabel.textColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        default:
            break
        }
        
//        switch eventType {
//        case "Tattoo":
//            view.backgroundColor = #colorLiteral(red: 0.9430051813, green: 0.2300890819, blue: 0.2300461844, alpha: 0.5)
//            break
//        case "Training":
//            view.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 0.5)
//            break
//        case "Massage":
//            view.backgroundColor = #colorLiteral(red: 0.00193524558, green: 1, blue: 0.08592860449, alpha: 0.5)
//            break
//        case "Consult":
//            view.backgroundColor = #colorLiteral(red: 1, green: 0.9663416273, blue: 0.1480508167, alpha: 0.5)
//        default:
//            break
//        }
    }
}
