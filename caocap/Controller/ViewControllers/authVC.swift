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
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var explainLabel: UILabel!
    @IBOutlet weak var checkYourMail: UILabel!
    @IBOutlet weak var checkContentMessage: UILabel!
    @IBOutlet weak var sendToEmailView: UIStackView!
    
    override func viewDidLoad() {

        explainLabel.text = "will be sent message to your email to retrieve your password.".localized
        checkYourMail.text = "Check Your Mail".localized
        checkContentMessage.text = "We have sent a password recover instructions to your email.".localized
        
        super.viewDidLoad()
        self.view.bindToKeyBoard()
        self.hideKeyboardWhenTappedAround()
    }
    
    let currentLang = Locale.current.languageCode
    @IBOutlet weak var signBTN: UIButton!
    @IBAction func signBTN(_ sender: Any) {
        signBTN.isEnabled = false
        signBTN.setTitle("loading...".localized,for: .normal)
        signBTN.alpha = 0.5
        signSwitchBTN.isEnabled = false
        signSwitchBTN.alpha = 0.5
        
        if usernameView.isHidden && passwordView.isHidden {
            // user is on forgot password
            send()
        } else if usernameView.isHidden {
            // user is on sign in
            signIn()
        } else {
            // user is on sign up
            signUp()
        }
    }
    
    func signIn() {
        let isEmailAddressValid = isValidEmailAddress(emailAddressString: emailTF.text!)
        if isEmailAddressValid {
            //Email address is valid
            if passwordTF.text != "" {
                loginUser()
            } else {
                displayAlertMessage("Please enter the password".localized, in: self)
                resetSignBTN("sign in".localized)
            }
        } else {
            //Email address is not valid
            displayAlertMessage("Please check your email".localized, in: self)
            resetSignBTN("sign in".localized)
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
                    displayAlertMessage("Please enter the password".localized, in: self)
                    resetSignBTN("sign up".localized)
                }
            } else {
                //Email address is not valid
                displayAlertMessage("Please check your email".localized, in: self)
                resetSignBTN("sign up".localized)
            }
        } else {
            displayAlertMessage("Please enter your username".localized, in: self)
            resetSignBTN("sign up".localized)
        }
    }
    
    func send() {
        let isEmailAddressValid = isValidEmailAddress(emailAddressString: emailTF.text!)
        if isEmailAddressValid {
            forgetPassworded()
        } else {
            displayAlertMessage("Please check your email".localized, in: self)
            resetSignBTN("send".localized)
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
        AuthService.instance.loginUser(withEmail: emailTF.text! , andPassword: passwordTF.text! , loginComplete: { (success, loginError) in
            if success {
                self.rocketLaunchAnimation()
            } else {
                displayAlertMessage(String(describing: loginError!.localizedDescription), in: self)
                self.resetSignBTN("sign in".localized)
            }
        })
    }
    
    
    func registerUser() {
        AuthService.instance.registerUser(withUsername: usernameTF.text! , Email: emailTF.text! , andPassword: passwordTF.text! , userCreationComplete: { (success, registrationError) in
            if success {
                AuthService.instance.loginUser(withEmail: self.emailTF.text! , andPassword: self.passwordTF.text! , loginComplete: { (success, nil) in
                    self.rocketLaunchAnimation()
                })
            } else {
                displayAlertMessage(String(describing: registrationError!.localizedDescription), in: self)
                self.resetSignBTN("sign up".localized)
            }
        })
    }
    
    func forgetPassworded() {
        AuthService.instance.resetPassword(withEmail: emailTF.text!) { status, error in
            if status {
                print("successful")
                self.rocketLaunchAnimationForFP()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                    self.resetSignBTN("sign in".localized)
                    self.forgetPassword.isHidden = false
                    self.passwordView.isHidden = false
                    self.explainLabel.isHidden = true
                }
            } else {
                print("error")
                displayAlertMessage(String(describing: "This email does not exist".localized), in: self)
                self.resetSignBTN("send".localized)
            }
        }
    }
    
    @IBOutlet weak var rocketLaunchView: UIView!
    func rocketLaunchAnimation() {
        sendToEmailView.isHidden = true
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
//    FP is means Forget Password
    func rocketLaunchAnimationForFP() {
        rocketLaunchView.isHidden = false
        sendToEmailView.isHidden = false
        UIView.animate(withDuration: 0.8,delay: 0,options: .curveEaseInOut, animations: {
            self.sendToEmailView.alpha = 1
            self.signBTN.alpha = 0
            self.signSwitchBTN.alpha = 0
            self.switchLBL.alpha = 0
            self.rocketLaunchView.frame.origin.y = ( 270 - self.view.frame.size.height )
            self.view.layoutIfNeeded()
        },completion: { finished in
            UIView.animate(withDuration: 0.8,delay: 5, animations: {
                self.signBTN.alpha = 1
                self.signSwitchBTN.alpha = 1
                self.switchLBL.alpha = 1
                self.rocketLaunchView.frame.origin.y = ( 270 + self.view.frame.size.height )
                self.view.layoutIfNeeded()
            })
        }
        )
    }
    

    @IBOutlet weak var forgetPassword: UIButton!
    @IBAction func forgetPassword(_ sender: Any) {
        forgetPassword.isHidden = true
        usernameView.isHidden = true
        passwordView.isHidden = true
        explainLabel.isHidden = false
        forgetPassword.setTitle("forget password ?".localized, for: .normal)
        signBTN.setTitle("send".localized, for: .normal)
        switchLBL.text = "Don't have an account?".localized
        signSwitchBTN.setTitle("sign up".localized, for: .normal)
    }
    
    @IBOutlet weak var switchLBL: UILabel!
    @IBOutlet weak var signSwitchBTN: UIButton!
    @IBAction func signSwitchBTN(_ sender: Any) {
        if usernameView.isHidden {
            forgetPassword.isHidden = true
            usernameView.isHidden = false
            explainLabel.isHidden = true
            passwordView.isHidden = false
            signBTN.setTitle("sign up".localized, for: .normal)
            switchLBL.text = "Already have an account?".localized
            signSwitchBTN.setTitle("sign in".localized, for: .normal)
            
        } else {
            forgetPassword.isHidden = false
            usernameView.isHidden = true
            explainLabel.isHidden = true
            passwordView.isHidden = false
            forgetPassword.setTitle("forget password ?".localized, for: .normal)
            signBTN.setTitle("sign in".localized, for: .normal)
            switchLBL.text = "Don't have an account?".localized
            signSwitchBTN.setTitle("sign up".localized, for: .normal)
            
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
