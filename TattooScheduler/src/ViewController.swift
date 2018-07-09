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
    
    @IBOutlet weak var Calendar: UICollectionView!
    @IBOutlet weak var MonthLabel: UILabel!
    
    let Months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "November", "Devember"]
    let DaysInMonths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

    var currentMonth = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentMonth = Months[month]
        MonthLabel.text = "\(currentMonth) \(year)"
        
    }
    
    @IBAction func Next(_ sender: Any) {
    }
    
    @IBAction func Back(_ sender: Any) {
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DaysInMonths[month]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calendar", for: indexPath) as! DateCollectionViewCell
        
        cell.backgroundColor = UIColor.clear
        cell.DateLabel.text = "\(indexPath.row + 1)"
        
        return cell
    }
    
    
}
