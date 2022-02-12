//
//  EditProfileVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 27/01/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit
import Firebase

class EditProfileVC: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    @IBOutlet weak var userIMG: DesignableImage!
    @IBOutlet weak var userIMGview: DesignableView!
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var websiteTF: UITextField!
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneNumTF: UITextField!

    
    var colorSelectedIndex: Int = Int.random(in: 0 ... 5)
    let colorArray = [#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.6391159892, blue: 0, alpha: 1), #colorLiteral(red: 0.3846503198, green: 1, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1), #colorLiteral(red: 0.8861780167, green: 0, blue: 1, alpha: 1), #colorLiteral(red: 0.9175696969, green: 0.9176983237, blue: 0.9175290465, alpha: 1)]
    @IBOutlet var constraintsArray: [NSLayoutConstraint]!
    @IBOutlet var colorBTNs: [UIButton]!
    @IBAction func colorBTNpressed(_ sender: UIButton) {
        
        let previousColorIndex = colorSelectedIndex
        colorSelectedIndex = sender.tag
        let previousConstraint = constraintsArray[previousColorIndex]
        let selectedConstraint = constraintsArray[colorSelectedIndex]
        UIView.animate(withDuration: 0.3 , animations: {
            previousConstraint.constant = 15
            selectedConstraint.constant = 20
            self.userIMGview.borderColor = self.colorArray[self.colorSelectedIndex]
            self.view.layoutIfNeeded()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataService.instance.checkOfLanguage(language: "en")
        
        getUserData()
        userIMG.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeImage)))
        
        saveBTN.isEnabled = true
        saveBTN.alpha = 1
        
        // Do any additional setup after loading the view.
    }
    
    //This makes sure the user is logged-in, then pulls his data from firebase and insert it in the appropriate place
    func getUserData() {
        DataService.instance.getUserData { (theUser) in
            if let user = theUser {
                self.colorBTNpressed(self.colorBTNs[user.color])
                self.usernameTF.text = user.username
                self.nameTF.text = user.name
                self.bioTextView.text = user.bio
                self.websiteTF.text = user.website
                self.emailTF.text = user.email
                self.phoneNumTF.text = user.phoneNumber
                if let imageURL = URL(string: user.imageURL ?? "" ) {
                    self.userIMG.af.setImage(withURL: imageURL)
                }
            }
        }
    }
    
    @objc func changeImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            userIMG.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    let currentLang = Locale.current.languageCode
    
    @IBOutlet weak var saveBTN: DesignableButton!
    @IBAction func saveBTN(_ sender: Any) {
        
        saveBTN.isEnabled = false
        if currentLang == "en" {
            saveBTN.setTitle("loading...",for: .normal)
                } else {
                    saveBTN.setTitle("تحميل...",for: .normal)
                }
        saveBTN.alpha = 0.5

        if let currentUser = Auth.auth().currentUser?.uid {
            if usernameTF.text != "" {
                let isEmailAddressValid = isValidEmailAddress(emailAddressString: emailTF.text!)
                if isEmailAddressValid {
                    
                    let storageRef = DataService.instance.REF_PROFILE_IMAGES.child("\(currentUser).jpg")
                    if let uploadData = self.userIMG.image?.jpegData(compressionQuality: 0.2) {
                        storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                            
                             if error != nil { print(error!) }
                            
                            storageRef.downloadURL(completion: { url, error in
                                if error != nil { print(error!) } else {
                                    // Here you can get the download URL for 'simpleImage.jpg'
                                    let userData = ["imageURL": url?.absoluteString,
                                                    "color": self.colorSelectedIndex,
                                                    "username" : self.usernameTF.text!,
                                                    "name": self.nameTF.text!,
                                                    "bio": self.bioTextView.text!,
                                                    "website": self.websiteTF.text!,
                                                    "email" : self.emailTF.text!,
                                                    "phoneNumber": self.phoneNumTF.text!,
                                                    "gender": "Male" ] as [String : Any]
                                    DataService.instance.updateUserData(uid: currentUser , userData: userData)
                                    self.navigationController?.popViewController(animated: true)
                                    
                                }
                            })
                        })
                    }
                } else {
                    //"Email address is not valid
                    displayAlertMessage("الرجاء التحقق من البريد الالكتروني", in: self)
                    self.saveBTN.isEnabled = true
                    self.saveBTN.setTitle("save",for: .normal)
                    self.saveBTN.alpha = 1
                }
                
            } else {
                displayAlertMessage("فضلا ادخل اسم المستخدم", in: self)
                self.saveBTN.isEnabled = true
                self.saveBTN.setTitle("save",for: .normal)
                self.saveBTN.alpha = 1
            }
        }
    }
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
}
