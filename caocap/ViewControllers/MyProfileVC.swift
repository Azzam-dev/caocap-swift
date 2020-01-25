//
//  MyProfileVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 17/01/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit
import Firebase

class MyProfileVC: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    @IBOutlet weak var profileCollectionView: UICollectionView!
    var caocapsArray = [Caocap]()
    
    
    @IBOutlet weak var userIMG: DesignableImage!
    @IBOutlet weak var userIMGview: DesignableView!
    
    
    @IBOutlet weak var orbitingCountLBL: UILabel!
    @IBOutlet weak var caocapsCountLBL: UILabel!
    @IBOutlet weak var friendsCountLBL: UILabel!
    
    @IBOutlet weak var usernameLBL: UILabel!
    @IBOutlet weak var nameLBL: UILabel!
    @IBOutlet weak var bioLBL: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getUserData()
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
        
        profileCollectionView.register(UINib.init(nibName: "caocapCell", bundle: nil), forCellWithReuseIdentifier: "caocapCell")
        
        caocapIMG.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeImage)))
        
        createBTN.isEnabled = true
        createBTN.setTitle("create",for: .normal)
        createBTN.alpha = 1
    }
    
    
    var isReleased = Bool()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getMyCaocapsData()
        
        DataService.instance.REF_RELEASED.observe(DataEventType.value, with: { snap in
            self.isReleased = snap.value! as! Bool
            self.profileCollectionView.reloadData()
        })
    }
    
    
    //This pulls all the current user caocaps from firebase and insert them to the caocap array
    func getMyCaocapsData() {
        DataService.instance.getCurrentUserCaocaps { (returnedCaocapsArray) in
            self.caocapsArray = returnedCaocapsArray
            self.profileCollectionView.reloadData()
        }
    }
    
    //This makes sure the user is logged-in, then pulls his data from firebase and insert it in the appropriate place
    func getUserData() {
        DataService.instance.getUserData { (theUser) in
            if let user = theUser {
                let colorArray = [#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.6391159892, blue: 0, alpha: 1), #colorLiteral(red: 0.3846503198, green: 1, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1), #colorLiteral(red: 0.8861780167, green: 0, blue: 1, alpha: 1), #colorLiteral(red: 0.9175696969, green: 0.9176983237, blue: 0.9175290465, alpha: 1)]
                self.userIMGview.borderColor = colorArray[user.color]
                self.usernameLBL.text = "@" + user.username
                self.nameLBL.text = user.name
                self.bioLBL.text = user.bio
                self.caocapsCountLBL.text = String(user.caocaps.count)
                self.orbitingCountLBL.text = String(user.followers.count)
                self.friendsCountLBL.text = String(user.following.count)
                
                //ir the user color is red he can not see the plus button @_@
                if user.color == 0 {
                    self.plusBTN.isHidden = true
                } else {
                    self.plusBTN.isHidden = false
                }
                if let url = URL(string: user.imageURL ?? "" ) {
                    ImageService.getImage(withURL: url) { (returnedImage) in
                        self.userIMG.image = returnedImage
                    }
                }
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        let section = 0
        let lastItemIndex = self.profileCollectionView.numberOfItems(inSection: section) - 1
        let indexPath:NSIndexPath = NSIndexPath.init(item: lastItemIndex, section: section)
        self.profileCollectionView.scrollToItem(at: indexPath as IndexPath, at: .left , animated: true )
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
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var blurredView: UIVisualEffectView!
    @IBOutlet weak var cancelPopupsBTN: UIButton!
    @IBOutlet weak var plusBTN: UIView!
    
    @IBOutlet weak var caocapIMG: DesignableImage!
    @IBOutlet weak var caocapIMGview: DesignableView!
    @IBOutlet weak var caocapNameTF: UITextField!
    @IBOutlet weak var caocapWebsiteTF: UITextField!
    
    @IBAction func popupACT(_ sender: Any) {
        
        if cancelPopupsBTN.isHidden {
            cancelPopupsBTN.isHidden = false
            popupView.isHidden = false
            blurredViewShowAnimation()
            UIView.animate(withDuration: 0.3 , animations: {
                //wait for 0.3 s
            }, completion: {(finished:Bool) in
                UIView.animate(withDuration: 0.3 , animations: {
                    self.popupView.alpha = 1
                    self.view.layoutIfNeeded()
                })
            })
        } else {
            blurredViewHideAnimation()
            UIView.animate(withDuration: 0.3 , animations: {
                //wait for 0.3 s
            }, completion: {(finished:Bool) in
                UIView.animate(withDuration: 0.3 , animations: {
                    self.popupView.alpha = 0
                    self.view.layoutIfNeeded()
                }, completion: {(finished:Bool) in
                    self.cancelPopupsBTN.isHidden = true
                    self.popupView.isHidden = true
                })
            })
        }
    }
    
    @IBOutlet weak var createBTN: DesignableButton!
    @IBAction func createBTN(_ sender: Any) {
        
        createBTN.isEnabled = false
        createBTN.setTitle("loading...",for: .normal)
        createBTN.alpha = 0.5
        
        // create caocap
        if caocapWebsiteTF.text == "" || caocapWebsiteTF.text == "https://" || caocapWebsiteTF.text == "https:\\" || caocapWebsiteTF.text == "https:/" {
            displayAlertMessage(messageToDisplay: "please enter a URL in the text field")
            caocapWebsiteTF.text = "https://"
            createBTN.isEnabled = true
            createBTN.setTitle("create",for: .normal)
            createBTN.alpha = 1
        } else {
            if caocapNameTF.text == "" {
                displayAlertMessage(messageToDisplay: "please enter the caocap's name")
                createBTN.isEnabled = true
                createBTN.setTitle("create",for: .normal)
                createBTN.alpha = 1
            } else {
                let imageNameUID = NSUUID().uuidString
                let storageRef = DataService.instance.REF_CAOCAP_IMAGES.child("\(imageNameUID).jpg")
                if let uploadData = self.caocapIMG.image?.jpegData(compressionQuality: 0.2) {
                    storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                        
                        if error != nil { print(error!) }
                        
                        if let currentUserUID = Auth.auth().currentUser?.uid {
                            storageRef.downloadURL(completion: { url, error in
                                if error != nil { print(error!) } else {
                                    // Here you can get the download URL
                                    let caocapData = ["imageURL": url?.absoluteString,
                                                      "name" : self.caocapNameTF.text!,
                                                      "website" : self.caocapWebsiteTF.text!,
                                                      "owners": [currentUserUID],
                                                      ] as [String : Any]
                                    
                                    DataService.instance.createCaocap(caocapData: caocapData, handler: { (caocapCreated) in
                                        if caocapCreated {
                                            self.profileCollectionView.reloadData()
                                            self.caocapNameTF.text = ""
                                            self.caocapIMG.image = #imageLiteral(resourceName: "caocap app icon old")
                                            self.caocapWebsiteTF.text = "https://"
                                            self.createBTN.isEnabled = true
                                            self.createBTN.setTitle("create",for: .normal)
                                            self.createBTN.alpha = 1
                                            self.popupACT(self)
                                        }
                                    })
                                }
                            })
                        }
                    })
                }
            }
        }
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
    
    func blurredViewShowAnimation() {
        if blurredView.isHidden {
            blurredView.isHidden = false
            UIView.animate(withDuration: 0.2 , animations: {
                self.blurredView.alpha = 1
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func blurredViewHideAnimation() {
        if blurredView.isHidden == false {
            blurredView.isHidden = true
            UIView.animate(withDuration: 0.2 , animations: {
                self.blurredView.alpha = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    
}


extension MyProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return caocapsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            guard let cell = profileCollectionView.dequeueReusableCell(withReuseIdentifier: "caocapCell", for: indexPath) as? caocapCell else { return UICollectionViewCell() }
            
            cell.configureCell(caocap: caocapsArray[indexPath.row], released: isReleased)
            
            return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            //let numberOfColumns: CGFloat = 1
            let width = collectionView.frame.size.width
            let height = collectionView.frame.size.height
            //let xInsets: CGFloat = 10
            //let cellspacing: CGFloat = 5
            
            return CGSize(width: width / 2  , height: height)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        var caocap = storyboard.instantiateViewController(withIdentifier: "caocap") as! caocapVC
        caocap.openedCaocap = caocapsArray[indexPath.row]
        navigationController?.pushViewController(caocap, animated: true)
        //caocapView.isUserInteractionEnabled = true
        
        
        let cell = collectionView.cellForItem(at: indexPath)
        //caocapView.cornerRadius = 20
        //caocapView.frame = CGRect(x: (cell?.frame.origin.x)!, y: (cell?.frame.origin.y)!, width: (cell?.frame.width)!, height: (cell?.frame.height)!)
        
        
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: .curveEaseInOut, animations: ({
            
            cell?.alpha = 0
            //self.caocapView.alpha = 1
            //self.caocapView.cornerRadius = 0
            //self.caocapView.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height)
            
            
        }), completion: nil)
    }
}
