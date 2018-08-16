//
//  Extensions.swift
//  TattooScheduler
//
//  Created by Artem on 30.07.2018.
//  Copyright © 2018 Artem. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var width: CGFloat {
        return self.frame.width
    }
    
    var height: CGFloat {
        return self.frame.height
    }
}

extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}

extension UITextField {
    private struct Holder {
        static var _vc: EventEditViewController?
    }
    
    var vc: EventEditViewController{
        get {
            return Holder._vc!
        }
        set (value) {
            Holder._vc = value
        }
    }
    
    func addDoneButtonOnKeyboard(controller:EventEditViewController)
    {
        vc = controller
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        vc.viewTappedLogic()
    }
}

extension UITextView {
    private struct Holder {
        static var _vc: EventEditViewController?
        static var _isEditing: Bool = false
    }
    
    var vc: EventEditViewController{
        get {
            return Holder._vc!
        }
        set (value) {
            Holder._vc = value
        }
    }
    
    var isEditing: Bool {
        get {
            return Holder._isEditing
        }
        set (value) {
            Holder._isEditing = value
        }
    }
    
    func addDoneButtonOnKeyboard(controller:EventEditViewController)
    {
        vc = controller
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        vc.viewTappedLogic()
    }
}
