//
//  KeyboardHelper.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 31/03/2023.
//  Copyright © 2023 Ficruty. All rights reserved.
//


import UIKit
import IQKeyboardManagerSwift



extension UIViewController {
    
    //this dismiss Keyboard
    func hideKeyboardWhenTappedAround() {
        NotificationCenter.default.addObserver(self,selector: #selector(setKeyboardDistance),name: UIResponder.keyboardWillShowNotification,object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //this solves the keyboard distance from the TextField issue
    @objc func setKeyboardDistance(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            if keyboardHeight > 300 {
                IQKeyboardManager.shared.keyboardDistanceFromTextField = 26
            } else {
                IQKeyboardManager.shared.keyboardDistanceFromTextField = 60
            }
        }
    }
}


