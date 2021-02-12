//
//  MenuVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 21/01/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit
import Firebase

class MenuVC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    let menuItemsNames = ["edit profile", "settings", "logout" ]
    let menuItemsImages = [#imageLiteral(resourceName: "icons8-user_folder_filled"),#imageLiteral(resourceName: "icons8-settings"),#imageLiteral(resourceName: "icons8-logout_rounded_up_filled")]
    
    @IBOutlet weak var menuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func logoutAct() {
        let logoutPopup = UIAlertController(title: "تسجيل الخروج", message: "هل تريد تسجيل الخروج ؟", preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "نعم", style: .destructive ) { (buttonTapped) in
            do {
                try Auth.auth().signOut()
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let authVC = storyboard.instantiateViewController(withIdentifier: "auth") as? AuthVC
                authVC!.modalPresentationStyle = .fullScreen
                self.present(authVC!, animated: true, completion: nil)
            } catch {
                self.displayAlertMessage(messageToDisplay: error.localizedDescription )
                
            }
        }
        let cancel = UIAlertAction(title: "لا", style: .cancel, handler: nil)
        logoutPopup.addAction(logoutAction)
        logoutPopup.addAction(cancel)
        
        
        if let popoverController = logoutPopup.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(logoutPopup, animated: true , completion: nil)
        
    }
    
    
    func displayAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "عذراً", message: messageToDisplay, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "حسناً", style: .default)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItemsNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuTableView.dequeueReusableCell(withIdentifier: "menuCell" , for: indexPath ) as! MenuCell
        cell.configureCell(image: menuItemsImages[indexPath.row], label: menuItemsNames[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            //edit profile VC
            
            let storyboard = UIStoryboard(name: "UserProfile", bundle: nil)
            let editProfile = storyboard.instantiateViewController(withIdentifier: "editProfile") as! EditProfileVC
            navigationController?.pushViewController(editProfile, animated: true)
            
        } else if indexPath.row == 1 {
            //settings VC
        } else if indexPath.row == 2 {
            logoutAct()
        }
    }
    
}
