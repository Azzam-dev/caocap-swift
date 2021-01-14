//
//  CreateCaocapVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 14/01/2021.
//  Copyright © 2021 Ficruty. All rights reserved.
//

import UIKit
import Firebase

class CreateCaocapVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var caocapType: CaocapType?
    @IBOutlet weak var caocapIMG: DesignableImage!
    @IBOutlet weak var caocapIMGview: DesignableView!
    @IBOutlet weak var caocapNameTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        caocapIMG.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeImage)))
        createButtonSetup(withTitle: "create")
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
                                          "name" : self.caocapNameTF.text!,
                                          "code": ["html":"<h1> write your code here </h1>",
                                                   "js": "//write your JS code here",
                                                   "css": "h1 { color: blue; }"],
                                          "published": false,
                                          "owners": [currentUserUID],
                            ] as [String : Any]
                        
                        DataService.instance.createCaocap(caocapData: caocapData, handler: { (caocapCreated) in
                            if caocapCreated {
                                self.caocapNameTF.text = ""
                                self.caocapIMG.image = #imageLiteral(resourceName: "caocap app icon old")
                                self.createButtonSetup(withTitle: "create")
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
