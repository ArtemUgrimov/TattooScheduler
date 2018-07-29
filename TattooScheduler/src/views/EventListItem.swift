//
//  EventListItem.swift
//  TattooScheduler
//
//  Created by Artem on 28.07.2018.
//  Copyright © 2018 Artem. All rights reserved.
//

import UIKit

class EventListItem: NibView {
    
    var event: CalendarEvent?
    var controller: EventViewController?
    
    var eventType: String = String()
    var eventTime: String = String()
    var desc: String = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        eventTypeText.text = eventType
//        eventTimeText.text = eventTime
//        descText.text = desc
        
        view.layer.cornerRadius = 20
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "EventListItem", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! UIView
    }
}
