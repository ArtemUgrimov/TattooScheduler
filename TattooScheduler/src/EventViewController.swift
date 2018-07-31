//
//  NextViewController.swift
//  TattooScheduler
//
//  Created by Artem on 10.07.2018.
//  Copyright © 2018 Artem. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

    var vc: MainViewController? = nil
    
    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let timeFormatter = DateFormatter()
    let dateFormatter = DateFormatter()
    var controllers: [EventListItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if vc != nil {
            titleBar.title = vc!.selectedDate
        }
        
        dateFormatter.dateFormat = "dd MMMM yyyy"
        timeFormatter.dateFormat = "HH:mm"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fillScrollView()
    }
    
    private func add(listItem li: UIView) {
        scrollView.addSubview(li)
    }
    
    private func remove(listItem li: UIView) {
        li.removeFromSuperview()
    }
    
    func fillScrollView() {
        for sub in scrollView.subviews {
            sub.removeFromSuperview()
        }
        
        var events = vc?.storage.getEvents(for: dateFormatter.date(from: vc!.selectedDate)!)
        events = events?.sorted(by: { $0.date! < $1.date! })
        var offset = (x: 0, y: 8, width: Int(scrollView.frame.width), height: 140)
        let spacing = 8
        
        for event in events! {
            let listItem = createListItem(offset)
            initListItem(listItem, event)
            controllers.append(listItem)
            add(listItem: listItem)
            offset.y += offset.height + spacing
        }
        scrollView.contentSize = CGSize(width: offset.width, height: offset.y)
    }
    
    private func createListItem(_ offset: (Int, Int, Int, Int)) -> EventListItem {
        let item = EventListItem(frame: CGRect(x: offset.0, y: offset.1, width: offset.2, height: offset.3))
        return item
    }
    
    func addEventToList() {
        fillScrollView()
    }
    
    func removeLastEvent() {
        fillScrollView()
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
        
        listItem.updateText()
    }
}
