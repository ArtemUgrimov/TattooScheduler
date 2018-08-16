//
//  MonthView.swift
//  TattooScheduler
//
//  Created by Artem on 29.07.2018.
//  Copyright © 2018 Artem. All rights reserved.
//

import UIKit

class MonthView: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    static let size: CGFloat = 359
    var vc: MainViewController?
    
    var freeCells:Int = 0

    var year: Int = 0
    var month: Int = 0
    var day: Int = 0
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var view: UIView!
    var date: Date = Date() {
        didSet {
            //monthLabel.text = "\(Calendar.current.monthSymbols[month])"
            year = Calendar.current.component(.year, from: date)
            month = Calendar.current.component(.month, from: date)
            day = Calendar.current.component(.weekday, from: date)
            freeCells = getStartDateDayPosition() - 1
        }
    }
    
    func getStartDateDayPosition() -> Int {
        return day == 1 ? 7 : day - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let range = Calendar.current.range(of: .day, in: .month, for: date)!
        return getStartDateDayPosition() + range.count
    }
    
    func updateDates() {
        DispatchQueue.main.async { [unowned self] in
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //print("____Updating cell!!!")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        let day = indexPath.row + 1 - freeCells
        cell.dateLabel.text = "\(day)"

        cell.year = year
        cell.month = month
        cell.day = day
        
        let range = Calendar.current.range(of: .day, in: .month, for: date)!
        if day < 1 || day > range.count {
            cell.isHidden = true
        } else {
            cell.vc = vc
            cell.date = Calendar.current.date(byAdding: .day, value: day - 1, to: date)
            cell.isHidden = false
        }
        
        //cell.updateIndicator()
        
        return cell
    }
}
