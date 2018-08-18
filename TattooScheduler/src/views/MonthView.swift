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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: collectionView.width / 7, height: collectionView.width / 6)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
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
        
        if [5, 6, 12, 13, 19, 20, 26, 27, 33, 34, 40, 41].contains(indexPath.row) {
            cell.dateLabel.textColor = #colorLiteral(red: 0.6606217617, green: 0.6606217617, blue: 0.6606217617, alpha: 1)
        } else {
            cell.dateLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
        //cell.updateIndicator()
        
        return cell
    }
}
