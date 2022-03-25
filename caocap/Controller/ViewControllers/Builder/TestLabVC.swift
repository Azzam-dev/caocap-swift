//
//  TestLabVC.swift
//  caocap
//
//  Created by omar alzhrani on 15/09/1441 AH.
//  Copyright © 1441 Ficruty. All rights reserved.
//

import UIKit
import SwiftUI
import ReSwift
import Firebase

class TestLabVC: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var loadingIcon: UIImageView!
    @IBOutlet weak var caocapView: DesignableView!
    var caocapVC: CaocapVC?
    
    @IBOutlet weak var toolsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var gestureRecognizerView: UIView!
    
    var openedCaocap: Caocap?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingAnimation(image: loadingIcon)
        gestureRecognizerSetup()
    }
    
    
    func getCaocapData() {
        // we are useing the observe method to make the changes in real-time and to allow "Multi device changes"
        guard let openedCaocap = openedCaocap else { return }
        
        DataService.instance.getCaocap(withKey: openedCaocap.key) { caocap in
            self.caocapNameTF.text = caocap.name
            self.colorBTNpressed(self.colorBTNs[caocap.color])
            
            if let imageURL = URL(string: caocap.imageURL ?? "" ) {
                self.caocapIMG.af.setImage(withURL: imageURL)
            }
            
            self.publishedStatus = caocap.isPublished
            if self.publishedStatus {
                self.publishingSwitchBTN.backgroundColor = #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1)
                self.publishingSwitchBTN.borderWidth = 0
                self.publishingSwitchBTN.setTitle("Published", for: .normal)
                self.publishingSwitchBTN.setTitleColor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), for: .normal)
            } else {
                self.publishingSwitchBTN.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                self.publishingSwitchBTN.borderWidth = 2
                self.publishingSwitchBTN.setTitle("Publish", for: .normal)
                self.publishingSwitchBTN.setTitleColor(#colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1), for: .normal)
            }
            self.loadCaocap(caocap)
        }
        
    }
    
    private func loadCaocap(_ caocap: Caocap) {
    //TODO: - loadCaocap
        let storyboard = UIStoryboard(name: "Builder", bundle: nil)
        caocapVC = storyboard.instantiateViewController(withIdentifier: "caocapVC") as? CaocapVC
        
        addChild(caocapVC!)
        caocapVC!.view.frame = caocapView.frame
        caocapView.addSubview(caocapVC!.view)
        caocapVC!.didMove(toParent: self)
    }
    
    
    
    
    func gestureRecognizerSetup() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        upSwipe.direction = .up
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        downSwipe.direction = .down
        
        gestureRecognizerView.addGestureRecognizer(upSwipe)
        gestureRecognizerView.addGestureRecognizer(downSwipe)
        caocapIMG.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeImage)))
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            switch sender.direction {
            case .up:
                if self.toolsViewHeightConstraint.constant == 75 {
                    toolsViewAnimation(135)
                } else {
                    toolsViewAnimation(350)
                }
            case .down:
                if self.toolsViewHeightConstraint.constant == 135 {
                    toolsViewAnimation(75)
                } else {
                    toolsViewAnimation(135)
                }
            default:
                break
            }
        }
    }
    func toolsViewAnimation(_ hight: Int) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .curveLinear, animations: {
            self.toolsViewHeightConstraint.constant = CGFloat(hight)
            self.view.layoutIfNeeded()
        })
    }
    
    
    //-----Settings-----
    
    @IBOutlet weak var caocapIMG: DesignableImage!
    @IBOutlet weak var caocapIMGview: DesignableView!
    @IBOutlet weak var caocapNameTF: UITextField!
    @IBOutlet weak var publishingSwitchBTN: UIButton!
    
    var publishedStatus = false
    var colorSelectedIndex = 3
    let colorArray = [#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.6391159892, blue: 0, alpha: 1), #colorLiteral(red: 0.3846503198, green: 1, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1), #colorLiteral(red: 0.8861780167, green: 0, blue: 1, alpha: 1), #colorLiteral(red: 0.9175696969, green: 0.9176983237, blue: 0.9175290465, alpha: 1)]
    
    @IBOutlet var constraintsArray: [NSLayoutConstraint]!
    @IBOutlet var colorBTNs: [UIButton]!
    @IBAction func colorBTNpressed(_ sender: UIButton) {
        guard let openedCaocap = openedCaocap else { return }
        let previousColorIndex = colorSelectedIndex
        colorSelectedIndex = sender.tag
        DataService.instance.REF_CAOCAPS.child(openedCaocap.key).updateChildValues(["color": colorSelectedIndex])
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
            uploudNewCaocapImage()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func uploudNewCaocapImage() {
        guard let openedCaocap = openedCaocap else { return }
        let imageNameUID = NSUUID().uuidString
        let storageRef = DataService.instance.REF_CAOCAP_IMAGES.child("\(imageNameUID).jpg")
        if let uploadData = self.caocapIMG.image?.jpegData(compressionQuality: 0.2) {
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil { print(error!) }
                storageRef.downloadURL(completion: { url, error in
                    if error != nil { print(error!) } else {
                        guard let imageURL = url?.absoluteString else { return }
                        DataService.instance.REF_CAOCAPS.child(openedCaocap.key).updateChildValues(["imageURL": imageURL])
                    }
                })
            })
        }
    }
    
    @IBAction func didPressPublishingSwitchBTN(_ sender: Any) {
        guard let openedCaocap = openedCaocap else { return }
        publishedStatus.toggle()
        if publishedStatus {
            publishingSwitchBTN.backgroundColor = #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1)
            publishingSwitchBTN.borderWidth = 0
            DataService.instance.REF_CAOCAPS.child(openedCaocap.key).updateChildValues(["published": true])
        } else {
            publishingSwitchBTN.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            publishingSwitchBTN.borderWidth = 2
            DataService.instance.REF_CAOCAPS.child(openedCaocap.key).updateChildValues(["published": false])
        }
    }
    
    @IBAction func caocapNameTFDidEndEditing(_ sender: Any) {
        if caocapNameTF.text != "" {
            guard let openedCaocap = openedCaocap else { return }
            DataService.instance.REF_CAOCAPS.child(openedCaocap.key).updateChildValues(["name": caocapNameTF.text!])
        }
    }
    
}

extension TestLabVC: StoreSubscriber {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }
    
    func newState(state: AppState) {
        openedCaocap = state.openedCaocap
        getCaocapData()
    }
    
}
