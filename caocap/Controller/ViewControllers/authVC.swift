//
//  AuthVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 20/01/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit
import Firebase

class AuthVC: UIViewController {
    
    override var prefersStatusBarHidden: Bool {  return true }
    
    @IBOutlet weak var usernameView: UIView!
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.bindToKeyBoard()
        self.hideKeyboardWhenTappedAround()
        resetSignBTN("sign up")
    }
    
    @IBOutlet weak var signBTN: UIButton!
    @IBAction func signBTN(_ sender: Any) {
        signBTN.isEnabled = false
        signBTN.setTitle("loading...",for: .normal)
        signBTN.alpha = 0.5
        signSwitchBTN.isEnabled = false
        signSwitchBTN.alpha = 0.5
        usernameView.isHidden ? signIn() : signUp()
    }
    
    func signIn() {
        let isEmailAddressValid = isValidEmailAddress(emailAddressString: emailTF.text!)
        if isEmailAddressValid {
            //Email address is valid
            if passwordTF.text != "" {
                loginUser()
            } else {
                displayAlertMessage(messageToDisplay: "فضلا ادخل كلمة السر")
                resetSignBTN("sign in")
            }
        } else {
            //Email address is not valid
            displayAlertMessage(messageToDisplay: "الرجاء التحقق من البريد الالكتروني")
            resetSignBTN("sign in")
        }
    }
    
    func signUp() {
        if usernameTF.text != "" {
            let isEmailAddressValid = isValidEmailAddress(emailAddressString: emailTF.text!)
            if isEmailAddressValid {
                //Email address is valid
                if passwordTF.text != "" {
                    registerUser()
                } else {
                    displayAlertMessage(messageToDisplay: "فضلا ادخل كلمة السر")
                    resetSignBTN("sign up")
                }
            } else {
                //Email address is not valid
                displayAlertMessage(messageToDisplay: "الرجاء التحقق من البريد الالكتروني")
                resetSignBTN("sign up")
            }
        } else {
            displayAlertMessage(messageToDisplay: "فضلا ادخل اسم المستخدم")
            resetSignBTN("sign up")
        }
    }
    
    func resetSignBTN(_ buttonTitle: String) {
        signBTN.isEnabled = true
        signBTN.setTitle(buttonTitle ,for: .normal)
        signBTN.alpha = 1
        signSwitchBTN.isEnabled = true
        signSwitchBTN.alpha = 1
    }
    
    func loginUser() {
        AuthService.instance.loginUser(withEmail: emailTF.text! , andPassword: passwordTF.text! , loginCompleat: { (success, loginError) in
            if success {
                self.rocketLaunchAnimation()
            } else {
                self.displayAlertMessage(messageToDisplay: String(describing: loginError?.localizedDescription) )
                self.resetSignBTN("sign in")
            }
        })
    }
    
    
    func registerUser() {
        AuthService.instance.registerUser(withUsername: usernameTF.text! , Email: emailTF.text! , andPassword: passwordTF.text! , userCreationCompleat: { (success, registrationError) in
            if success {
                AuthService.instance.loginUser(withEmail: self.emailTF.text! , andPassword: self.passwordTF.text! , loginCompleat: { (success, nil) in
                    self.rocketLaunchAnimation()
                })
            } else {
                self.displayAlertMessage(messageToDisplay: String(describing: registrationError?.localizedDescription) )
                self.resetSignBTN("sign up")
            }
        })
    }
    
    @IBOutlet weak var rocketLaunchView: UIView!
    func rocketLaunchAnimation() {
        rocketLaunchView.isHidden = false
        UIView.animate(withDuration: 0.8 , animations: {
            self.signBTN.alpha = 0
            self.signSwitchBTN.alpha = 0
            self.switchLBL.alpha = 0
            self.rocketLaunchView.frame.origin.y = ( 200 - self.view.frame.size.height )
            self.view.layoutIfNeeded()
        }, completion: { finished in
            self.dismissVC()
            self.signBTN.alpha = 1
            self.signSwitchBTN.alpha = 1
            self.switchLBL.alpha = 1
            
        })
    }
    
    @IBOutlet weak var switchLBL: UILabel!
    @IBOutlet weak var signSwitchBTN: UIButton!
    @IBAction func signSwitchBTN(_ sender: Any) {
        if usernameView.isHidden {
            usernameView.isHidden = false
            signBTN.setTitle("sign up", for: .normal)
            switchLBL.text = "Already have an account?"
            signSwitchBTN.setTitle("sign in", for: .normal)
            
        } else {
            usernameView.isHidden = true
            signBTN.setTitle("sign in", for: .normal)
            switchLBL.text = "Don't have an account?"
            signSwitchBTN.setTitle("sign up", for: .normal)
            
        }
    }
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0 {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    func displayAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "عذراً", message: messageToDisplay, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "حسناً", style: .default) { (action:UIAlertAction!) in
            // Code in this block will trigger when OK button tapped.
            print("Ok button tapped")
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    private func dismissVC() {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromBottom
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
        NotificationCenter.default.post(name: Notification.Name("reloadMyProfile"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("reloadExplore"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("openExplore"), object: nil)
        NavigationVC().myPageSubNAV?.popViewController(animated: false)
    }
    
}
