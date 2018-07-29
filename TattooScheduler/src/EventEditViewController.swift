//
//  EventEditViewController.swift
//  TattooScheduler
//
//  Created by Artem on 15.07.2018.
//  Copyright © 2018 Artem. All rights reserved.
//

import UIKit

enum OpenMode {
    case Add
    case Edit
}

class EventEditViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    enum EventType: String {
        case Tattoo
        case Training
        case Massage
        case Consult
        case Other
        
        static let allValues = [ Tattoo, Training, Massage, Consult, Other ]
    }
    
    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var eventTypeTextField: UITextField!
    @IBOutlet weak var eventTimeTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var openMode: OpenMode = OpenMode.Add
    var editingEvent: CalendarEvent?
    
    private var eventTypePicker: UIPickerView?
    private var eventTimePicker: UIDatePicker?
    
    var vc: MainViewController?
    var evc: EventViewController?
    
    let timeFormatter = DateFormatter()
    let saveDateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventTimePicker = UIDatePicker()
        eventTimePicker?.datePickerMode = .time
        eventTimePicker?.locale = Locale(identifier: "uk")
        eventTimePicker?.minuteInterval = 15
        eventTimePicker?.addTarget(self, action: #selector(EventEditViewController.dateChanged(eventTimePicker:)), for: .valueChanged)
        
        eventTypePicker = UIPickerView()
        eventTypePicker?.dataSource = self
        eventTypePicker?.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EventEditViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        eventTimeTextField.inputView = eventTimePicker
        eventTypeTextField.inputView = eventTypePicker
        
        timeFormatter.dateFormat = "HH:mm"
        saveDateFormatter.dateFormat = "dd MM yyyy HH:mm"
        saveDateFormatter.locale = Calendar.current.locale
        
        fillFromEvent()
    }
    
    @IBAction func saveEvent(_ sender: Any) {
        
        if (eventTypeTextField.text?.isEmpty)! || (eventTimeTextField.text?.isEmpty)! {
            return
        }
        
        let event: CalendarEvent?
            
        if openMode == OpenMode.Add {
            event = CalendarEvent()
        } else {
            event = editingEvent
        }
        event!.date = saveDateFormatter.date(from: "\(titleBar.title!) \(eventTimeTextField.text!)")
        event!.properties.eventType = eventTypeTextField.text!
        event!.properties.description = descriptionTextField.text!
        
        if openMode == OpenMode.Add {
            vc?.storage.store(event: event!)
        } else {
            vc?.storage.update(event: event!)
        }
        self.navigationController?.popViewController(animated: true)
        evc?.fillScrollView()
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        if eventTypeTextField.isEditing {
            eventTypeTextField.text = EventType.allValues[eventTypePicker!.selectedRow(inComponent: 0)].rawValue
            view.endEditing(true)
        }
        
        if eventTimeTextField.isEditing {
            eventTimeTextField.text = timeFormatter.string(from: (eventTimePicker?.date)!)
            view.endEditing(true)
        }
        
        if descriptionTextField.isEditing {
            view.endEditing(true)
        }
    }
    
    @objc func dateChanged(eventTimePicker: UIDatePicker) {
        eventTimeTextField.text = timeFormatter.string(from: eventTimePicker.date)
    }
    
    @IBAction func deleteEvent(_ sender: Any) {
        if editingEvent != nil {
            vc?.storage.remove(event: editingEvent!)
            self.navigationController?.popViewController(animated: true)
            evc?.fillScrollView()
        }
    }
    
    private func fillFromEvent() {
        if editingEvent != nil {
            eventTypeTextField.text = editingEvent?.properties.eventType
            eventTimeTextField.text = timeFormatter.string(from: (editingEvent?.date)!)
            descriptionTextField.text = editingEvent?.properties.description
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return EventType.allValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return EventType.allValues[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        eventTypeTextField.text = EventType.allValues[eventTypePicker!.selectedRow(inComponent: 0)].rawValue
    }
    
}
