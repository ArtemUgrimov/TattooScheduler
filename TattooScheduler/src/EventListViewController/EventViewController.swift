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
    @IBOutlet weak var tableView: UITableView!
    
    let timeFormatter = DateFormatter()
    let dateFormatter = DateFormatter()
    var controllers: [EventListItem] = []
    var events: [CalendarEvent] = []
    var arrow: UIBezierPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if vc != nil {
            titleBar.title = vc!.selectedDate
        }
        
        dateFormatter.dateFormat = "dd MMMM yyyy"
        timeFormatter.dateFormat = "HH:mm"
        fillScrollView()
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            NotificationCenter.default.post(name: NSNotification.Name("EventClosed"), object: nil)
        }
    }
    
    func fillScrollView() {
        vc?.selectedCell?.updateIndicator()
        tableView.reloadData()
    }
    
    @IBAction func swipeRight(_ recognizer: UISwipeGestureRecognizer) {
        addDays(count: -1)
    }
    
    @IBAction func swipeLeft(_ recognizer: UISwipeGestureRecognizer) {
        addDays(count: 1)
    }
    
    func addDays(count : Int) {
        var newDate = dateFormatter.date(from: vc!.selectedDate)!
        newDate = Calendar.current.date(byAdding: .day, value: count, to: newDate)!
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        vc!.selectedDate = formatter.string(from: newDate)
        
        self.tableView.slideInTo(direction: count, duration: 0.2)
        self.tableView.reloadData()
        
        self.titleBar.titleView?.slideInTo(direction: count, duration: 0.2)
        self.titleBar.title = self.vc!.selectedDate
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
