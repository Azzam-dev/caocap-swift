//
//  MenuVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 21/01/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit
import Firebase

enum MenuType {
    case account
    case setting
}

class MenuVC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    var menuType: MenuType = .account
    var menuItems = [MenuItem]()
    
    
    @IBOutlet weak var menuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch menuType {
        case .account:
            menuItems = [MenuItem(image: #imageLiteral(resourceName: "icons8-settings"), label: .settings),
                         MenuItem(image: #imageLiteral(resourceName: "icons8-logout_rounded_up_filled"), label: .logout)
            ]
        case .setting:
            menuItems = [MenuItem(image: #imageLiteral(resourceName: "w-launched_rocket"), label: .yourActivity),
                         MenuItem(image: #imageLiteral(resourceName: "w-comments"), label: .notification),
                         MenuItem(image: #imageLiteral(resourceName: "W-search_filled"), label: .privacy),
                         MenuItem(image: #imageLiteral(resourceName: "W-search_filled"), label: .security),
                         MenuItem(image: #imageLiteral(resourceName: "W-search_filled"), label: .ads),
                         MenuItem(image: #imageLiteral(resourceName: "W-search_filled"), label: .account),
                         MenuItem(image: #imageLiteral(resourceName: "W-search_filled"), label: .help),
                         MenuItem(image: #imageLiteral(resourceName: "W-search_filled"), label: .about)
            ]
        }
        
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
                displayAlertMessage(error.localizedDescription, in: self)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuTableView.dequeueReusableCell(withIdentifier: "menuCell" , for: indexPath ) as! MenuCell
        cell.configure(menuItem: menuItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch menuItems[indexPath.row].label {
        case .settings:
            let storyboardSettings = UIStoryboard(name: "UserProfile", bundle: nil)
            let settingsVC = storyboardSettings.instantiateViewController(withIdentifier: "menu") as! MenuVC
            settingsVC.menuType = .setting
            navigationController?.pushViewController(settingsVC, animated: true)
        case .logout:
            logoutAct()
        case .yourActivity:
            print("")
        case .notification:
            print("")
        case .privacy:
            print("")
        case .security:
            print("")
        case .ads:
            print("")
        case .account:
            print("")
        case .help:
            print("")
        case .about:
            print("")
        }
        
    }
    
}
