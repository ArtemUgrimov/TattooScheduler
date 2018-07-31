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
    var month: Int = 0
    
    @IBOutlet weak var monthLabel: UILabel!
    
    var view: UIView!
    var date: Date = Date() {
        didSet {
            month = Calendar.current.component(.month, from: date) - 1
            monthLabel.text = "\(Calendar.current.monthSymbols[month])"
            freeCells = getStartDateDayPosition() - 1
        }
    }
    
    func getStartDateDayPosition() -> Int {
        let day = Calendar.current.component(.weekday, from: date)
        return day == 1 ? 7 : day - 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let range = Calendar.current.range(of: .day, in: .month, for: date)!
        return getStartDateDayPosition() + range.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        let day = indexPath.row + 1 - freeCells
        cell.dateLabel.text = "\(day)"

        let range = Calendar.current.range(of: .day, in: .month, for: date)!
        if Int(cell.dateLabel.text!)! < 1 || Int(cell.dateLabel.text!)! > range.count {
            cell.isHidden = true
        } else {
            cell.vc = vc
            cell.date = Calendar.current.date(byAdding: .day, value: day - 1, to: date)
            cell.isHidden = false
        }
        
        return cell
    }
}
