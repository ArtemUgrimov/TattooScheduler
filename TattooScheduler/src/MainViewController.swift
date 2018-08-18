//
//  ViewController.swift
//  TattooCalendar
//
//  Created by Artem on 03.07.2018.
//  Copyright © 2018 Artem. All rights reserved.
//

import UIKit
import Foundation

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    static let totalMonths: Int = 3000
    static let offsetMonths: Int = 500
    static var screenWidth: CGFloat = 0
    
    @IBOutlet weak var NavBar: UINavigationItem!
    @IBOutlet weak var WeekdayStackView: UIStackView!
    @IBOutlet weak var monthsCollectionView: UICollectionView!
    
    let date = Date()
    var selectedDate: String = String()
    var selectedCell: CollectionViewCell?
    
    var months: [MonthView] = []
    var storage:Storage = SQLiteStorage()
    
    var year: Int = 0
    var month: Int = 0
    var day: Int = 0
    
    var eventsCache: [String:[CalendarEvent]] = [:]
    
    var once: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        day = self.calendar.component(.day, from: date)
        month = self.calendar.component(.month, from: date)
        year = self.calendar.component(.year, from: date)
        
        NavBar.prompt = "\(year)"
        NavBar.title = "\(day) \(calendar.monthSymbols[month - 1])"
        
        for (index, label) in WeekdayStackView.arrangedSubviews.enumerated() {
            (label as! UILabel).text = calendar.shortWeekdaySymbols[(index + 1) % 7]
        }
        
        let events = (storage as! SQLiteStorage).events
        for event in events {
            let year = calendar.component(.year, from: event.date!)
            let month = calendar.component(.month, from: event.date!)
            let day = calendar.component(.day, from: event.date!)
            
            let ms = "\(year)_\(month)_\(day)"
            if eventsCache[ms] == nil {
               eventsCache[ms] = []
            }
            eventsCache[ms]?.append(event)
        }
        setupMonthView()
    }
    
    override func viewDidLayoutSubviews() {
        if once {
            monthsCollectionView.scrollToItem(at: IndexPath(row: MainViewController.offsetMonths, section: 0), at: .top, animated: false)
            once = false
            MainViewController.screenWidth = view.width
        }
    }
    
    func setupMonthView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: monthsCollectionView.width, height: monthsCollectionView.width * 1.2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        monthsCollectionView.collectionViewLayout = layout
    }
    
    func goTo(date: Date) {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        selectedDate = formatter.string(from: date)
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let eventViewController = mainStoryboard.instantiateViewController(withIdentifier: "EventViewController") as? EventViewController {
            eventViewController.vc = self
            if let navigator = navigationController {
                navigator.pushViewController(eventViewController, animated: true)
            }
        }
    }
    
    var calendar: Calendar {
        return Calendar.current
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MainViewController.totalMonths
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //print("Updating month!")
        
        let monthView = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthView", for: indexPath) as! MonthView
        monthView.vc = self
        
        let currentYear = self.calendar.component(.year, from: date)
        let currentMonth = self.calendar.component(.month, from: date)
        let month = currentMonth - (MainViewController.offsetMonths - indexPath.row)
        
        let components = DateComponents(year: currentYear, month: month, day: 1)
        let nextDate = calendar.date(from: components)

        monthView.date = nextDate!
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        monthView.monthLabel.text! = "\(formatter.string(from: nextDate!))"
        
        monthView.updateDates()
        
        return monthView
    }
}
