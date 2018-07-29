//
//  ViewController.swift
//  TattooCalendar
//
//  Created by Artem on 03.07.2018.
//  Copyright © 2018 Artem. All rights reserved.
//

import UIKit
import Foundation

class MainViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var NavBar: UINavigationItem!
    @IBOutlet weak var WeekdayStackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    
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
    
    var months: [MonthView] = []
    
    var storage:Storage = SQLiteStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        day = self.calendar.component(.day, from: date)
        month = self.calendar.component(.month, from: date) - 1
        year = self.calendar.component(.year, from: date)
        
        currentMonthName = Months[month]
        NavBar.prompt = "\(currentMonthName) \(year)"
        updateDaysInFeb()
        
        for (index, label) in WeekdayStackView.arrangedSubviews.enumerated() {
            (label as! UILabel).text = calendar.shortWeekdaySymbols[(index + 1) % 7]
        }
        
        let calendarWidth = MonthView.size
        let calendarHeight = (calendarWidth - 30) / 7 * 6 + 30
        let leftOffset: CGFloat = 8
        let topOffset: CGFloat = 30
        let spacing: CGFloat = 10

        let prevComponents = DateComponents(month: -1, day: -day + 1)
        let prevDate = calendar.date(byAdding: prevComponents, to: date)!
        
        let curComponents = DateComponents(day: -day + 1)
        let curDate = calendar.date(byAdding: curComponents, to: date)!
        
        let nextComponents = DateComponents(month: 1, day: -day + 1)
        let nextDate = calendar.date(byAdding: nextComponents, to: date)!
        
        
        let priorMonth: MonthView = MonthView(frame: CGRect(x: leftOffset, y: topOffset, width: calendarWidth, height: getMonthHeigth(by: prevDate)))
        let currentMonth: MonthView = MonthView(frame: CGRect(x: leftOffset, y: priorMonth.frame.maxY + spacing, width: calendarWidth, height: getMonthHeigth(by: curDate)))
        let nextMonth: MonthView = MonthView(frame: CGRect(x: leftOffset, y: currentMonth.frame.maxY + spacing, width: calendarWidth, height: getMonthHeigth(by: nextDate)))
        
        
        priorMonth.date = prevDate
        currentMonth.date = curDate
        nextMonth.date = nextDate
        
        scrollView.contentSize = CGSize(width: calendarWidth, height:priorMonth.frame.height + currentMonth.frame.height + nextMonth.frame.height + spacing * 3)
        
        scrollView.addSubview(priorMonth)
        scrollView.addSubview(currentMonth)
        scrollView.addSubview(nextMonth)
        
        scrollView.setContentOffset(CGPoint(x: 0, y: calendarHeight - spacing), animated: false)
    }
    
    func createMonth(_ monthOffset: Int, _ y: Int) -> MonthView {
        
    }
    
    func getMonthHeigth(by date: Date) -> CGFloat {
        var emptyDays = Calendar.current.component(.weekday, from: date)
        emptyDays = (emptyDays == 1 ? 7 : emptyDays - 1) - 1
        
        print("emptyDays = \(emptyDays)")
        let range = calendar.range(of: .day, in: .month, for: date)!
        var numDays = range.count + emptyDays
        numDays += (7 - numDays % 7)
        
        let result = CGFloat(Int(numDays / 7)) * CollectionViewCell.height
        return result
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
        currentMonthName = Months[month]
        NavBar.prompt = "\(currentMonthName) \(year)"
        updateDaysInFeb()
    }
    
    func updateDaysInFeb() {
        if (year % 4 == 0 && year % 100 != 0) || year % 400 == 0 {
            DaysInMonths[1] = 29
        } else {
            DaysInMonths[1] = 28
        }
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
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let top: CGFloat = 0
        let bottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
        let buffer: CGFloat = self.cellBuffer * self.cellHeight
        let scrollPosition = scrollView.contentOffset.y
        
        // Reached the bottom of the list
        if scrollPosition > bottom - buffer {
            // Add more dates to the bottom
            let lastDate = self.days.last!
            let additionalDays = self.generateDays(
                lastDate.dateFromDays(1),
                endDate: lastDate.dateFromDays(self.daysToAdd)
            )
            self.days.append(contentsOf: additionalDays)
            
            // Update the tableView
            self.tableView.reloadData()
        }
    }
}
