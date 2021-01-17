//
//  CreateLinkCaocapVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 15/01/2021.
//  Copyright © 2021 Ficruty. All rights reserved.
//

import UIKit
import Firebase

class CreateLinkCaocapVC: CreateCodeCaocapVC {
    
    
    @IBOutlet weak var caocapLinkTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func createBTN(_ sender: Any) {
        createButtonSetup(withTitle: "loading...", andAlpha: 0.5, isEnabled: false)
        // create caocap
        if caocapNameTF.text == "" {
            displayAlertMessage(messageToDisplay: "please enter the caocap's name")
            createButtonSetup(withTitle: "create")
        } else if caocapLinkTF.text == "" {
            displayAlertMessage(messageToDisplay: "please enter the caocap's link")
            createButtonSetup(withTitle: "create")
        } else {
            uploudCaocap()
        }
    }
    
    override func uploudCaocap() {
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
                                          "type": "link",
                                          "link": self.caocapLinkTF.text!,
                                          "published": true,
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

}
