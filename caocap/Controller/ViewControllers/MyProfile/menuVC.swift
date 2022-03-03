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
    case mainAccount
    case setting
    case account
    case about
}

class MenuVC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    var menuType: MenuType = .mainAccount
    var menuItems = [MenuItem]()
    
    
    @IBOutlet weak var menuTableView: UITableView!
    
    override func viewDidLoad() {
        
        LocalizationManager.shared.checkOfLanguage(language: "en")
        
        super.viewDidLoad()
        switch menuType {
        case .mainAccount:
            menuItems = [MenuItem(image: #imageLiteral(resourceName: "icons8-settings_filled"), label: .settings),
                         MenuItem(image: #imageLiteral(resourceName: "icons8-logout_rounded_up_filled"), label: .logout)
            ]
        case .setting:
            menuItems = [MenuItem(image: #imageLiteral(resourceName: "icons8-circled_menu"), label: .yourActivity),
                         MenuItem(image: #imageLiteral(resourceName: "icons8-remove_ads"), label: .notification),
                         MenuItem(image: #imageLiteral(resourceName: "icons8-keyhole_shield_filled"), label: .privacy),
                         MenuItem(image: #imageLiteral(resourceName: "icons8-security_pass_filled"), label: .security),
                         MenuItem(image: #imageLiteral(resourceName: "icons8-remove_ads"), label: .ads),
                         MenuItem(image: #imageLiteral(resourceName: "icons8-group_filled"), label: .account),
                         MenuItem(image: #imageLiteral(resourceName: "icons8-online_support_filled"), label: .help),
                         MenuItem(image: #imageLiteral(resourceName: "icons8-help"), label: .about)
            ]
        case .account:
            menuItems = [MenuItem(image: #imageLiteral(resourceName: "icons8-re_enter_pincode_filled"), label: .resetPassword),
                         MenuItem(image: #imageLiteral(resourceName: "icons8-re_enter_pincode_filled"), label: .resetPassword)
            ]
        case .about:
            menuItems = [MenuItem(image: #imageLiteral(resourceName: "icons8-secured_file"), label: .dataPolicy),
                         MenuItem(image: #imageLiteral(resourceName: "icons8-geography"), label: .termsOfUse),
                         MenuItem(image: #imageLiteral(resourceName: "icons8-copy"), label: .openSourceLibraries)
            ]
        }
        
    }
    
    func logoutAct() {
        let logoutPopup = UIAlertController(title: "تسجيل الخروج".localized(), message: "هل تريد تسجيل الخروج ؟".localized(), preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "yes".localized(), style: .destructive ) { (buttonTapped) in
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
        let cancel = UIAlertAction(title: "no".localized(), style: .cancel, handler: nil)
        logoutPopup.addAction(logoutAction)
        logoutPopup.addAction(cancel)
        
        
        if let popoverController = logoutPopup.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(logoutPopup, animated: true , completion: nil)
        
    }
    func menuCAOCAP(template: MenuType) {
        let storyboardSettings = UIStoryboard(name: "UserProfile", bundle: nil)
        let settingsVC = storyboardSettings.instantiateViewController(withIdentifier: "menu") as! MenuVC
        settingsVC.menuType = template
        navigationController?.pushViewController(settingsVC, animated: true)
    }

    func goToCAOCAPPolitics() {
        let storyboardSettings = UIStoryboard(name: "UserProfile", bundle: nil)
        let settingsVC = storyboardSettings.instantiateViewController(withIdentifier: "CAOCAPPolitics") as! CaocapPoliticsVC
        navigationController?.pushViewController(settingsVC, animated: true)
    }

    func sendMessageToEmail() {
        let userEmail = Auth.auth().currentUser?.email
        let alert = UIAlertController(title: "are you sure?".localized(), message: "If you press yes, a message will be sent to your email to change the password".localized(), preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "yes".localized(), style: .default, handler: { action in
            AuthService.instance.resetPassword(withEmail: userEmail!) { status, error in
                if status {
                    print("successful")
                } else {
                    print("error")
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "no".localized(), style: .cancel, handler: nil))
            present(alert, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuTableView.dequeueReusableCell(withIdentifier: "menuCell" , for: indexPath ) as! MenuCell
        let cell2 = menuTableView.dequeueReusableCell(withIdentifier: "menuCell2" , for: indexPath ) as! MenuCell
        cell.configure(menuItem: menuItems[indexPath.row])
        if menuType == .account {
            switch indexPath.row {
            case 0:
                cell2.configure()
                return cell2
            case 1:
                return cell
            default:
                print("gkk")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch menuItems[indexPath.row].label {
        case .settings:
            menuCAOCAP(template: .setting)
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
            menuCAOCAP(template: .account)
        case .resetPassword:
            sendMessageToEmail()
        case .help:
            print("")
        case .about:
            menuCAOCAP(template: .about)
        case .dataPolicy:
            goToCAOCAPPolitics()
        case .termsOfUse:
            goToCAOCAPPolitics()
        case .openSourceLibraries:
            goToCAOCAPPolitics()
        }
        
    }
    
}
