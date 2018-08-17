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
    
    private func remove(listItem li: UIView) {
        li.removeFromSuperview()
    }
    
    func fillScrollView() {
        vc?.selectedCell?.updateIndicator()
        tableView.reloadData()
    }
    
    func addEventToList() {
        fillScrollView()
    }
    
    func removeLastEvent() {
        fillScrollView()
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
        
        UIView.transition(with: tableView, duration: 0.1, options: .transitionCrossDissolve, animations: {
            self.tableView.reloadData()
            self.titleBar.title = self.vc!.selectedDate
        }, completion: nil)
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
