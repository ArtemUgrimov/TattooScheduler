//
//  MonthView.swift
//  TattooScheduler
//
//  Created by Artem on 29.07.2018.
//  Copyright © 2018 Artem. All rights reserved.
//

import UIKit

class MonthView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    static let size: CGFloat = 359
    
    var freeCells:Int = 0
    var month: Int = 0
    var DaysInMonths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    
    var view: UIView!
    var date: Date = Date() {
        didSet {
            month = Calendar.current.component(.month, from: date) - 1
            monthLabel.text = "\(Calendar.current.monthSymbols[month])"
            freeCells = getStartDateDayPosition() - 1
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Setup view from .xib file
        xibSetup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let nibName = UINib(nibName: "CollectionViewCell", bundle:nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "CollectionViewCell")
    }
    
    func getStartDateDayPosition() -> Int {
        let day = Calendar.current.component(.weekday, from: date)
        return day == 1 ? 7 : day - 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getStartDateDayPosition() + DaysInMonths[month]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.dateLabel.text = "\(indexPath.row + 1 - freeCells)"

        if Int(cell.dateLabel.text!)! < 1 || Int(cell.dateLabel.text!)! > DaysInMonths[month] {
            cell.isHidden = true
        }
        
        return cell
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "MonthView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        
        let nibName = UINib(nibName: "CollectionViewCell", bundle:nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "CollectionViewCell")
        
        let width = (view.frame.width) / 7
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        
        addSubview(view)
    }
}
