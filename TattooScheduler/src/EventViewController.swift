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
    
    let timeFormatter = DateFormatter()
    let dateFormatter = DateFormatter()
    var controllers: [EventListItem] = []
    var events: [CalendarEvent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if vc != nil {
            titleBar.title = vc!.selectedDate
        }
        
        dateFormatter.dateFormat = "dd MMMM yyyy"
        timeFormatter.dateFormat = "HH:mm"
        fillScrollView()
    }
    
    private func remove(listItem li: UIView) {
        li.removeFromSuperview()
    }
    
    func fillScrollView() {
//        for sub in scrollView.subviews {
//            sub.removeFromSuperview()
//        }
//        
//        var events = vc?.storage.getEvents(for: dateFormatter.date(from: vc!.selectedDate)!)
//        events = events?.sorted(by: { $0.date! < $1.date! })
//        var offset = (x: 0, y: 8, width: Int(MainViewController.screenWidth * 0.91), height: 140)
//        let spacing = 8
//        
//        for event in events! {
//            let listItem = createListItem(offset)
//            initListItem(listItem, event)
//            controllers.append(listItem)
//            self.scrollView.addSubview(listItem)
//            offset.y += offset.height + spacing
//        }
//        scrollView.contentSize = CGSize(width: offset.width, height: offset.y)
//        vc?.selectedCell?.updateIndicator()
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
}
