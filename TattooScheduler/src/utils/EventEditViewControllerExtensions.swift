//
//  EventEditViewControllerExtensions.swift
//  TattooScheduler
//
//  Created by Artem on 16.08.2018.
//  Copyright © 2018 Artem. All rights reserved.
//

import Foundation
import UIKit

//image picker
extension EventEditViewController {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC!.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
        } else {
            print("Something went wrong")
        }
        currentVC!.dismiss(animated: true, completion: nil)
    }
}

//gallery and camera
extension EventEditViewController {
    func showActionSheet(vc: UIViewController) {
        currentVC = vc
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
    func photoLibrary()
    {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .photoLibrary
            myPickerController.imageExportPreset = .current
            currentVC!.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            myPickerController.imageExportPreset = .current
            currentVC!.present(myPickerController, animated: true, completion: nil)
        }
    }
}

//textField delegate
extension EventEditViewController {
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWasShown(notification: NSNotification){
        if let field = activeField, let info = notification.userInfo, let keyboardFrameEndUserInfoKey = info[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            var keyboardRect = keyboardFrameEndUserInfoKey.cgRectValue
            keyboardRect = self.view.convert(keyboardRect, from: nil)
            let keyboardTop = keyboardRect.origin.y
            var newScrollFrame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: keyboardTop)
            newScrollFrame.size.height = keyboardTop - self.view.bounds.origin.y
            print(keyboardTop)
            self.scrollView.frame = newScrollFrame
            
            let fieldRect = self.view.convert(field.frame, from: field.superview)
            self.scrollView.scrollRectToVisible(fieldRect, animated: true)
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        let topFrame = CGRect(x: 0, y: 0, width: 1, height: 1)
        self.scrollView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        self.scrollView.scrollRectToVisible(topFrame, animated: true)
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        textView.isEditing = true
        activeField = textView
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        textView.isEditing = false
        activeField = nil
    }
}
