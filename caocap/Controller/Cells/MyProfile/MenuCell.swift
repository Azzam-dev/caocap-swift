//
//  MenuCell.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 08/01/1441 AH.
//  Copyright © 1441 Ficruty. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
    weak var viewController: UIViewController?
    let currentLang = Locale.current.languageCode
    
    @IBOutlet weak var segmentedOutlet: UISegmentedControl!
    @IBAction func SelectedLanguage(_ sender: Any) {
        switch segmentedOutlet.selectedSegmentIndex {
        case 0:
            let newLang = currentLang == "ar" ? "en":"ar"
            UserDefaults.standard.setValue([newLang], forKey: "AppleLanguages")
        case 1:
            let newLang = currentLang == "en" ? "ar":"en"
            UserDefaults.standard.setValue([newLang], forKey: "AppleLanguages")
        default:
            print("h")
        }
        LocalizationManager.shared.resetApp()
    }
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemlabel: UILabel!
    
    func configure(menuItem: MenuItem, isHidden: Bool) {

        
        if currentLang == "en" {
            segmentedOutlet.selectedSegmentIndex = 0
        } else {
            segmentedOutlet.selectedSegmentIndex = 1
        }
        itemlabel.text = menuItem.label.rawValue.localized()
        self.itemImage.image = menuItem.image
        self.segmentedOutlet.isHidden = isHidden
    }

    
}
