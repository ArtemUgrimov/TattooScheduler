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

class EventEditViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate {
    
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
    //@IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var phoneTextField: UITextField!
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
    var activeField: UITextField?
    
    var imgPath: String = "file:///private/var/mobile/Containers/Data/Application/205C7DCA-F23C-4A8E-BAAA-EF0BC5A2EEB3/tmp/2BA6593B-BD65-4D58-833D-DF354EFFA3B9.png"
    
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
        
        eventTimeTextField.inputView = eventTimePicker
        eventTypeTextField.inputView = eventTypePicker
        
        eventTypeTextField.addDoneButtonOnKeyboard(controller: self)
        eventTimeTextField.addDoneButtonOnKeyboard(controller: self)
        descriptionTextField.addDoneButtonOnKeyboard(controller: self)
        phoneTextField.addDoneButtonOnKeyboard(controller: self)
        
        timeFormatter.dateFormat = "HH:mm"
        saveDateFormatter.dateFormat = "dd MM yyyy HH:mm"
        saveDateFormatter.locale = Calendar.current.locale
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EventEditViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        let imageUrl: URL = URL(fileURLWithPath: imgPath)
        if FileManager.default.fileExists(atPath: imgPath),
            let imageData: Data = try? Data(contentsOf: imageUrl),
            let image = UIImage(data: imageData, scale: UIScreen.main.scale) {
                imageView.image = image
        } else {
            print("No image(((((((")
        }
        
        fillFromEvent()
        
        registerForKeyboardNotifications()
    }
    
    deinit {
        deregisterFromKeyboardNotifications()
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
    }
    
    @IBAction func imageTapped(_ sender: Any) {
        viewTapped(gestureRecognizer: sender as! UITapGestureRecognizer)
        showActionSheet(vc: self)
    }
    
    @objc func dateChanged(eventTimePicker: UIDatePicker) {
        eventTimeTextField.text = timeFormatter.string(from: eventTimePicker.date)
    }
    
    @IBAction func deleteEvent(_ sender: Any) {
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
            let url:URL = URL(string: "tel://" + num)!
            UIApplication.shared.open(url)
        }
    }
}
