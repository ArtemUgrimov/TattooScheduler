//
//  NextViewController.swift
//  TattooScheduler
//
//  Created by Artem on 10.07.2018.
//  Copyright © 2018 Artem. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

    var vc: ViewController? = nil
    
    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var eventsStack: UIStackView!
    
    let listItem = EventListItem.instanceFromNib()
    
    let timeFormatter = DateFormatter()
    let dateFormatter = DateFormatter()
    var controllers: [EventListItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if vc != nil {
            titleBar.title = vc!.selectedDate
        }
        
        dateFormatter.dateFormat = "dd MM yyyy"
        timeFormatter.dateFormat = "HH:mm"
        
        fillScrollView()
    }
    
    private func add(listItem li: UIView) {
        eventsStack.addArrangedSubview(li)
    }
    
    private func remove(listItem li: UIView) {
        eventsStack.removeArrangedSubview(li)
    }
    
    func fillScrollView() {
        
        var events = vc?.storage.getEvents(for: dateFormatter.date(from: vc!.selectedDate)!)
        events = events?.sorted(by: { $0.date! < $1.date! })
        for event in events! {
            let listItem = EventListItem.instanceFromNib() as! EventListItem
            initListItem(listItem, event)
            controllers.append(listItem)
            add(listItem: listItem)
        }
    }
    
    func addEventToList() {
        var events = vc?.storage.getEvents(for: dateFormatter.date(from: vc!.selectedDate)!)
        events = events?.sorted(by: { $0.date! < $1.date! })
        
        let listItem = EventListItem.instanceFromNib() as! EventListItem
        initListItem(listItem, (events?.last)!)
        controllers.append(listItem)
        add(listItem: listItem)
    }
    
    func removeLastEvent() {
        remove(listItem: controllers.last!)
        controllers.removeLast()
    }
    
    @IBAction func AddEvent(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let eventEditViewController = mainStoryboard.instantiateViewController(withIdentifier: "EventEditViewController") as? EventEditViewController {
            eventEditViewController.titleBar.title = titleBar.title
            eventEditViewController.vc = vc
            eventEditViewController.evc = self
            if let navigator = navigationController {
                navigator.pushViewController(eventEditViewController, animated: true)
            }
        }
    }
    
    func edit(event ev: CalendarEvent) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let eventEditViewController = mainStoryboard.instantiateViewController(withIdentifier: "EventEditViewController") as? EventEditViewController {
            eventEditViewController.titleBar.title = titleBar.title
            eventEditViewController.vc = vc
            eventEditViewController.evc = self
            eventEditViewController.editingEvent = ev
            eventEditViewController.openMode = OpenMode.Edit
            if let navigator = navigationController {
                navigator.pushViewController(eventEditViewController, animated: true)
            }
        }
    }
    
    func initListItem(_ listItem: EventListItem, _ event: CalendarEvent) {
        listItem.eventTime = timeFormatter.string(from: event.date!)
        listItem.eventType = event.properties.eventType
        listItem.desc = event.properties.description
        listItem.event = event
        listItem.controller = self
    }
}
