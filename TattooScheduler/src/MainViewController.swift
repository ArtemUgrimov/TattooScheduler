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
    
    @IBOutlet weak var NavBar: UINavigationItem!
    @IBOutlet weak var WeekdayStackView: UIStackView!
    @IBOutlet weak var monthsCollectionView: UICollectionView!
    
    let date = Date()
    var selectedDate: String = String()
    
    var months: [MonthView] = []
    var storage:Storage = SQLiteStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let day = self.calendar.component(.day, from: date)
        let month = self.calendar.component(.month, from: date) - 1
        let year = self.calendar.component(.year, from: date)
        
        NavBar.prompt = "\(year)"
        NavBar.title = "\(day) \(calendar.monthSymbols[month])"
        
        for (index, label) in WeekdayStackView.arrangedSubviews.enumerated() {
            (label as! UILabel).text = calendar.shortWeekdaySymbols[(index + 1) % 7]
        }
    }
    
    override func viewDidLayoutSubviews() {
        monthsCollectionView.scrollToItem(at: IndexPath(row: MainViewController.offsetMonths, section: 0), at: .top, animated: false)
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
        return 3000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let monthView = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthView", for: indexPath) as! MonthView
        monthView.vc = self
        
        let currentYear = self.calendar.component(.year, from: date)
        let currentMonth = self.calendar.component(.month, from: date)
        
        let month = currentMonth - (MainViewController.offsetMonths - indexPath.row)
        
        let components = DateComponents(year: currentYear, month: month, day: 1)
        let nextDate = calendar.date(from: components)

        monthView.date = nextDate!
        
        return monthView
    }
}
