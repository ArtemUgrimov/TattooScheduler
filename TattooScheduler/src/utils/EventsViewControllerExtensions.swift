//
//  EventsViewControllerExtensions.swift
//  TattooScheduler
//
//  Created by Artem on 17.08.2018.
//  Copyright © 2018 Artem. All rights reserved.
//

import Foundation
import UIKit

extension EventViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        events = vc!.storage.getEvents(for: dateFormatter.date(from: vc!.selectedDate)!)
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EventListItem = tableView.dequeueReusableCell(withIdentifier: "EventListItem", for: indexPath) as! EventListItem
        
        initListItem(cell, events[indexPath.row])
        
        return cell
    }
    
    func initListItem(_ listItem: EventListItem, _ event: CalendarEvent) {
        listItem.eventTime = timeFormatter.string(from: event.date!)
        listItem.eventType = event.properties.eventType
        listItem.desc = event.properties.description
        listItem.event = event
        listItem.controller = self
        
        listItem.updateText()
    }
}
