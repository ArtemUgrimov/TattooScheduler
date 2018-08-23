//
//  EventEditActions.swift
//  TattooScheduler
//
//  Created by Artem on 19.08.2018.
//  Copyright © 2018 Artem. All rights reserved.
//

import Foundation
import UIKit

extension EventEditViewController {
    func showActions() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Save", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.saveEventLogic()
        }))
        
        if openMode == .Edit {
            actionSheet.addAction(UIAlertAction(title: "Move", style: .default, handler: { (alert:UIAlertAction!) -> Void in
                self.showMoveEventDialog()
            }))
            actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (alert:UIAlertAction!) -> Void in
                self.deleteEventLogic()
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func showMoveEventDialog() {
        let alertController = UIAlertController(title: "Set new date", message: nil, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Save", style: .default) { (_) in
            let newDateStr = (alertController.textFields?[0].text)
            
            if let dateStr = newDateStr {
                if dateStr != "" {
                    let timeFormatter = DateFormatter()
                    timeFormatter.dateFormat = "d MMMM yyyy"
                    let curDate = timeFormatter.date(from: dateStr)!
                    let year = Calendar.current.component(.year, from: curDate)
                    let month = Calendar.current.component(.month, from: curDate)
                    let day = Calendar.current.component(.day, from: curDate)
                    
                    var component = Calendar.current.dateComponents(in: TimeZone.current, from: (self.editingEvent?.date)!)
                    component.year = year
                    component.month = month
                    component.day = day
                    let newDate = Calendar.current.date(from: component)
                    self.saveEventLogic(date: newDate)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            let eventTimePicker = UIDatePicker()
            eventTimePicker.datePickerMode = .date
            eventTimePicker.locale = Locale(identifier: "uk")
            eventTimePicker.addTarget(for: .valueChanged) { (eventTimePicker) in
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "d MMMM yyyy"
                textField.text = timeFormatter.string(from: eventTimePicker.date)
            }
            textField.inputView = eventTimePicker
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
