//
//  ChangeLanguageCell.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 01/08/1443 AH.
//  Copyright © 1443 Ficruty. All rights reserved.
//

import UIKit

class ChangeLanguageCell: MenuCell {
    
    let currentLang = Locale.current.languageCode
    
    override func configure(menuItem: MenuItem) {
        super.configure(menuItem: menuItem)
        languageSegmentedControl.selectedSegmentIndex = currentLang == "en" ? 0:1
    }

    @IBOutlet weak var languageSegmentedControl: UISegmentedControl!
    @IBAction func didChangeLanguage(_ sender: UISegmentedControl) {
        Language.language = sender.selectedSegmentIndex == 0 ? .english:.arabic

    }

}
