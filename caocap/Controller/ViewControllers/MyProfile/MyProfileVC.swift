//
//  MyProfileVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 17/01/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit
import SwiftUI
import Firebase

class MyProfileVC: UIViewController {
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
        getMyCaocapsData()
        
        profileCollectionView.register(UINib.init(nibName: "CaocapCell", bundle: nil), forCellWithReuseIdentifier: "caocapCell")
        NotificationCenter.default.addObserver(self, selector: #selector(reloadMyProfile), name: Notification.Name("reloadMyProfile"), object: nil)
        
    }
    
    
    var isReleased = Bool()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
                self.orbitingCountLBL.text = String(user.orbiting.count)
                self.caocapsCountLBL.text = String(user.caocaps.count)
                self.friendsCountLBL.text = String(user.followers.count)
                
                if let url = URL(string: user.imageURL ?? "" ) {
                    ImageService.getImage(withURL: url) { (returnedImage) in
                        self.userIMG.image = returnedImage
                    }
                }
            }
        }
    }
    
    @objc func reloadMyProfile() {
        getMyCaocapsData()
        getUserData()
    }
    
    
    override func viewDidLayoutSubviews() {
        let section = 0
        let lastItemIndex = self.profileCollectionView.numberOfItems(inSection: section) - 1
        let indexPath:NSIndexPath = NSIndexPath.init(item: lastItemIndex, section: section)
        self.profileCollectionView.scrollToItem(at: indexPath as IndexPath, at: .left , animated: true )
    }
    
    
    @IBAction func editProfileButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "UserProfile", bundle: nil)
        let editProfileVC = storyboard.instantiateViewController(withIdentifier: "editProfile") as! EditProfileVC
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
}


extension MyProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return caocapsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = profileCollectionView.dequeueReusableCell(withReuseIdentifier: "caocapCell", for: indexPath) as? CaocapCell else { return UICollectionViewCell() }
        
        cell.configure(caocap: caocapsArray[indexPath.row], released: isReleased)
        cell.caocapCellDelegate = self
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        let height = collectionView.frame.size.height
        return CGSize(width: width / 2  , height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        store.dispatch(OpenBuilderAction(caocap: caocapsArray[indexPath.row]))
    }
}



extension MyProfileVC: CaocapCellDelegate {
    func moreBTNpressed(caocapKey: String) {
        let moreInfoPopup = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "delete",style: .destructive ) { (buttonTapped) in
            DataService.instance.removeCaocap(caocapKey)
        }
        let cancel = UIAlertAction(title: "cancel", style: .default, handler: nil)
        moreInfoPopup.addAction(deleteAction)
        moreInfoPopup.addAction(cancel)
        
        if let popoverController = moreInfoPopup.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        }
        
        self.present(moreInfoPopup, animated: true , completion: nil)
    }
}

