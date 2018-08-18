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

class EventEditViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
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
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var openMode: OpenMode = OpenMode.Add
    var editingEvent: CalendarEvent?
    
    private var eventTypePicker: UIPickerView?
    private var eventTimePicker: UIDatePicker?
    
    var vc: MainViewController?
    var evc: EventViewController?
    
    let timeFormatter = DateFormatter()
    let saveDateFormatter = DateFormatter()
    
    var currentVC: UIViewController?
    var activeField: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EventEditViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        setupDateFormatters()
        setupTextFields()
        fillFromEvent()
        registerForKeyboardNotifications()
    }
    
    deinit {
        deregisterFromKeyboardNotifications()
    }
    
    func setupTextFields() {
        eventTimePicker = UIDatePicker()
        eventTimePicker?.datePickerMode = .time
        eventTimePicker?.locale = Locale(identifier: "uk")
        eventTimePicker?.minuteInterval = 15
        eventTimePicker?.addTarget(self, action: #selector(EventEditViewController.dateChanged(eventTimePicker:)), for: .valueChanged)
        
        eventTypePicker = UIPickerView()
        eventTypePicker?.dataSource = self
        eventTypePicker?.delegate = self
        
        eventTimeTextField.inputView = eventTimePicker
        eventTypeTextField.inputView = eventTypePicker
        
        eventTypeTextField.addDoneButtonOnKeyboard(controller: self)
        eventTimeTextField.addDoneButtonOnKeyboard(controller: self)
        descriptionTextField.addDoneButtonOnKeyboard(controller: self)
        phoneTextField.addDoneButtonOnKeyboard(controller: self)
        priceTextField.addDoneButtonOnKeyboard(controller: self)
        
        descriptionTextField.delegate = self
    }
    
    func setupDateFormatters() {
        timeFormatter.dateFormat = "HH:mm"
        saveDateFormatter.dateFormat = "dd MM yyyy HH:mm"
        saveDateFormatter.locale = Calendar.current.locale
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
        event!.properties.additional["Phone"] = phoneTextField.text!
        event!.properties.additional["Price"] = priceTextField.text!
        
        if let img = self.imageView.image {
            let imageData = img.jpeg(.lowest)
            event!.properties.additional["Image"] = imageData?.base64EncodedString()
        }
        
        let year = Calendar.current.component(.year, from: (event?.date)!)
        let month = Calendar.current.component(.month, from: (event?.date)!)
        let day = Calendar.current.component(.day, from: (event?.date)!)
        
        let ms = "\(year)_\(month)_\(day)"

        if openMode == OpenMode.Add {
            vc?.storage.store(event: event!)
        } else {
            vc?.storage.update(event: event!)
        }
        if vc?.eventsCache[ms] == nil {
           vc?.eventsCache[ms] = []
        }
        vc?.eventsCache[ms]?.append(event!)
        
        self.navigationController?.popViewController(animated: true)
        evc?.fillScrollView()
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        viewTappedLogic()
    }
    
    func viewTappedLogic() {
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
        
        if phoneTextField.isEditing {
            view.endEditing(true)
        }
        
        if priceTextField.isEditing {
            view.endEditing(true)
        }
    }
    
    @IBAction func imageTapped(_ sender: Any) {
        viewTapped(gestureRecognizer: sender as! UITapGestureRecognizer)
        showActionSheet(vc: self)
    }
    
    @objc func dateChanged(eventTimePicker: UIDatePicker) {
        eventTimeTextField.text = timeFormatter.string(from: eventTimePicker.date)
    }
    
    @IBAction func deleteEvent(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete event?", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.deleteLogic()
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in }
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func deleteLogic() {
        if editingEvent != nil {
            let year = Calendar.current.component(.year, from: (editingEvent?.date)!)
            let month = Calendar.current.component(.month, from: (editingEvent?.date)!)
            let day = Calendar.current.component(.day, from: (editingEvent?.date)!)
            
            let ms = "\(year)_\(month)_\(day)"
            
            vc?.eventsCache.removeValue(forKey: ms)
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
            phoneTextField.text = editingEvent?.properties.additional["Phone"]
            priceTextField.text = editingEvent?.properties.additional["Price"]
            
            if editingEvent?.properties.additional.index(forKey: "Image") != nil {
                imageView.image = UIImage(data: Data(base64Encoded: (editingEvent?.properties.additional["Image"])!)!)
                scrollView.isScrollEnabled = true
            }
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
    
    @IBAction func callANumber(_ sender: UIButton) {
        if let num:String = phoneTextField.text {
            if num != "" {
                let url:URL = URL(string: "tel://" + num)!
                UIApplication.shared.open(url)
            }
        }
    }
}
