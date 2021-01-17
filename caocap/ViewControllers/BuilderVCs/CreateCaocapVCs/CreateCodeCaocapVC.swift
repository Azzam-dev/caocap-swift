//
//  CreateCaocapVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 14/01/2021.
//  Copyright © 2021 Ficruty. All rights reserved.
//

import UIKit
import Firebase

protocol CreateCaocapDelegate {
    func openNewlyCreatedCaocap()
}

class CreateCodeCaocapVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var createCaocapDelegate: CreateCaocapDelegate?
    
    @IBOutlet weak var caocapIMG: DesignableImage!
    @IBOutlet weak var caocapIMGview: DesignableView!
    @IBOutlet weak var caocapNameTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        caocapIMG.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeImage)))
        createButtonSetup(withTitle: "create")
    }
    
    var colorSelectedIndex = 3
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
            self.caocapIMGview.borderColor = self.colorArray[self.colorSelectedIndex]
            self.view.layoutIfNeeded()
        })
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
            caocapIMG.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func createButtonSetup(withTitle title: String, andAlpha alphaLevel: CGFloat = 1, isEnabled: Bool = true) {
        createBTN.isEnabled = isEnabled
        createBTN.setTitle(title ,for: .normal)
        createBTN.alpha = alphaLevel
    }
    
    @IBOutlet weak var createBTN: DesignableButton!
    @IBAction func createBTN(_ sender: Any) {
        createButtonSetup(withTitle: "loading...", andAlpha: 0.5, isEnabled: false)
        // create caocap
        if caocapNameTF.text == "" {
            displayAlertMessage(messageToDisplay: "please enter the caocap's name")
            createButtonSetup(withTitle: "create")
        } else {
            uploudCaocap()
        }
    }
    
    func uploudCaocap() {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        let imageNameUID = NSUUID().uuidString
        let storageRef = DataService.instance.REF_CAOCAP_IMAGES.child("\(imageNameUID).jpg")
        if let uploadData = self.caocapIMG.image?.jpegData(compressionQuality: 0.2) {
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil { print(error!) }
                storageRef.downloadURL(completion: { url, error in
                    if error != nil { print(error!) } else {
                        // Here you can get the download URL
                        let caocapData = ["imageURL": url?.absoluteString ?? "",
                                          "color": self.colorSelectedIndex,
                                          "name" : self.caocapNameTF.text!,
                                          "type": "code",
                                          "code": ["html":"<h1> write your code here </h1>",
                                                   "js": "//write your JS code here",
                                                   "css": "h1 { color: blue; }"],
                                          "published": false,
                                          "owners": [currentUserUID],
                            ] as [String : Any]
                        
                        DataService.instance.createCaocap(caocapData: caocapData, handler: { (caocapCreated) in
                            if caocapCreated {
                                self.dismiss(animated: true, completion: nil)
                                self.createCaocapDelegate?.openNewlyCreatedCaocap()
                            }
                        })
                    }
                })
            })
        }
    }
    
    func displayAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "عذراً", message: messageToDisplay, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "حسناً", style: .default)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
