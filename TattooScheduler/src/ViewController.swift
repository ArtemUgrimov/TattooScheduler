//
//  ViewController.swift
//  TattooCalendar
//
//  Created by Artem on 03.07.2018.
//  Copyright © 2018 Artem. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var NavBar: UINavigationItem!
    @IBOutlet weak var CalendarView: UICollectionView!
    @IBOutlet weak var WeekdayStackView: UIStackView!
    
    let date = Date()
    let Months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var DaysInMonths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

    var currentMonthName = String()
    var numberOfEmptyBox = 0
    var selectedDay = -1
    var selectedDate = ""
    
    var day: Int = 0
    var weekday: Int = 0
    var month: Int = 0
    var year: Int = 0
    
    var storage:Storage = SQLiteStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        day = self.calendar.component(.day, from: date)
        month = self.calendar.component(.month, from: date) - 1
        year = self.calendar.component(.year, from: date)
        
        currentMonthName = Months[month]
        NavBar.prompt = "\(currentMonthName) \(year)"
        getStartDateDayPosition()
        updateDaysInFeb()
        
        for (index, label) in WeekdayStackView.arrangedSubviews.enumerated() {
            (label as! UILabel).text = calendar.shortWeekdaySymbols[(index + 1) % 7]
        }
        CalendarView.layer.cornerRadius = 10
    }
    
    func getStartDateDayPosition() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EE"
        let dayInWeek = formatter.string(from: calendarDate)
        let weekday = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"].index(of: dayInWeek)!
        numberOfEmptyBox = weekday
    }
    
    @IBAction func RightSwipe(_ sender: Any) {
        Back(sender)
    }
    
    @IBAction func LeftSwipe(_ sender: Any) {
        Next(sender)
    }
    
    func Next(_ sender: Any) {
        if month == 11 {
            month = 0
            year += 1
        } else {
            month += 1
        }
        updateDataAndView()
    }
    
    func Back(_ sender: Any) {
        if month == 0 {
            month = 11
            year -= 1
        } else {
            month -= 1
        }
        updateDataAndView()
    }
    
    func updateDataAndView() {
        getStartDateDayPosition()
        currentMonthName = Months[month]
        NavBar.prompt = "\(currentMonthName) \(year)"
        updateDaysInFeb()
        CalendarView.reloadData()
    }
    
    func updateDaysInFeb() {
        if (year % 4 == 0 && year % 100 != 0) || year % 400 == 0 {
            DaysInMonths[1] = 29
        } else {
            DaysInMonths[1] = 28
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calendar", for: indexPath) as! DateCollectionViewCell
        
        cell.DateLabel.text = "\(indexPath.row + 1 - numberOfEmptyBox)"
        
        let thisMonth = currentMonthName == Months[calendar.component(.month, from: date) - 1]
        let thisYear = year == calendar.component(.year, from: date)
        
        let today = thisMonth && thisYear && indexPath.row + 1 - numberOfEmptyBox == day
        let selected = selectedDay > 0 && indexPath.row + 1 - numberOfEmptyBox == selectedDay
        
        if Int(cell.DateLabel.text!)! < 1 {
            cell.DateLabel.text = "\(DaysInMonths[(month == 0 ? 12 : month) - 1] + indexPath.row + 1 - numberOfEmptyBox)"
            cell.DateLabel.textColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        } else if Int(cell.DateLabel.text!)! > DaysInMonths[month] {
            cell.DateLabel.text = "\(indexPath.row + 1 - numberOfEmptyBox - DaysInMonths[month])"
            cell.DateLabel.textColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        } else {
            if [5, 6, 12, 13, 19, 20, 26, 27, 33, 34, 40, 41].contains(indexPath.row) && !today {
                cell.DateLabel.textColor = #colorLiteral(red: 1, green: 0.002117370991, blue: 0.01371765098, alpha: 1)
            } else {
                cell.DateLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
        
        if selected {
            cell.backgroundColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        } else if today {
            cell.backgroundColor = #colorLiteral(red: 1, green: 0.02328635045, blue: 0, alpha: 1)
        } else {
            cell.backgroundColor = .clear
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = indexPath.row + 1 - numberOfEmptyBox
        if selectedCell > 0 && selectedCell <= DaysInMonths[month] {
            selectedDay = selectedCell
            selectedDate = "\(selectedDay) \(Months[month]) \(year)"
            goToDate()
        } else {
            selectedDay = -1
            selectedDate = ""
        }
        CalendarView.reloadData()
    }
    
    func goToDate() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let eventViewController = mainStoryboard.instantiateViewController(withIdentifier: "EventViewController") as? EventViewController {
            eventViewController.vc = self
            if let navigator = navigationController {
                navigator.pushViewController(eventViewController, animated: true)
            }
        }
    }
    
    var calendarDate: Date {
        let components = DateComponents(year: year, month: month + 1)
        return calendar.date(from: components)!
    }
    
    var calendar: Calendar {
        return Calendar.current
    }
    
}
