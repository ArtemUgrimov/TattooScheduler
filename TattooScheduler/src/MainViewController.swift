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
    
    var doNotCheckBounds: Bool = false
    var totalMonthsHeight: CGFloat = 0
    var lastMonthHeight: CGFloat = 0
    var months: [MonthView] = [] {
        didSet {
            totalMonthsHeight = 0
            for month in months {
                totalMonthsHeight += month.height + spacing
            }
        }
    }
    
    var storage:Storage = SQLiteStorage()
    
    let topOffset: CGFloat = 30
    let spacing: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        day = self.calendar.component(.day, from: date)
        month = self.calendar.component(.month, from: date) - 1
        year = self.calendar.component(.year, from: date)
        
        currentMonthName = Months[month]
        NavBar.prompt = "\(currentMonthName) \(year)"
        
        for (index, label) in WeekdayStackView.arrangedSubviews.enumerated() {
            (label as! UILabel).text = calendar.shortWeekdaySymbols[(index + 1) % 7]
        }

        let priorMonth = createMonth(-1, topOffset)
        let currentMonth = createMonth(0, priorMonth.frame.maxY + spacing)
        let nextMonth = createMonth(1, currentMonth.frame.maxY + spacing)
        
        scrollView.contentSize = CGSize(width: MonthView.size, height: priorMonth.height + currentMonth.height + nextMonth.height + spacing * 3)
        
        scrollView.addSubview(priorMonth)
        scrollView.addSubview(currentMonth)
        scrollView.addSubview(nextMonth)
        
        scrollView.setContentOffset(CGPoint(x: 0, y: priorMonth.height - spacing), animated: false)
    }
    
    func createMonth(_ monthOffset: Int, _ y: CGFloat) -> MonthView {
        let calendarWidth = MonthView.size
        let leftOffset: CGFloat = 8

        let prevComponents = DateComponents(month: monthOffset, day: -day + 1)
        let prevDate = calendar.date(byAdding: prevComponents, to: date)!
        
        let priorMonth: MonthView = MonthView(frame: CGRect(x: leftOffset, y: y, width: calendarWidth, height: getMonthHeigth(by: prevDate)))
        priorMonth.date = prevDate
        months.append(priorMonth)
        
        return priorMonth
    }
    
    func appendMonthToList(month: MonthView) {
        scrollView.contentSize.height = scrollView.contentSize.height + month.height + spacing
        scrollView.addSubview(month)
    }
    
    func getMonthHeigth(by date: Date) -> CGFloat {
        var emptyDays = Calendar.current.component(.weekday, from: date)
        emptyDays = (emptyDays == 1 ? 7 : emptyDays - 1) - 1
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        var numDays = range.count + emptyDays
        numDays += (7 - numDays % 7)
        
        let result = CGFloat(Int(numDays / 7)) * CollectionViewCell.height
        return result
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let frame: CGFloat = scrollView.frame.size.height
        let scrollPosition = scrollView.contentOffset.y
        
        if scrollPosition > totalMonthsHeight - frame * 10 {
            let nextMonth = createMonth(months.count - 1, totalMonthsHeight + spacing)
            self.appendMonthToList(month: nextMonth)
        }
    }
}
