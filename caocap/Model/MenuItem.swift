//
//  MenuItem.swift
//  caocap
//
//  Created by omar alzhrani on 01/07/1442 AH.
//  Copyright © 1442 Ficruty. All rights reserved.
//

import UIKit

enum MenuItemType: String {
    case settings
    
    case logout
    case yourActivity = "your activity"
    case notification
    case privacy
    case security
    case ads
    
    case account
    case changeLanguage = "change language"
    case resetPassword = "reset password"

    case help
    
    case about
    case dataPolicy = "data policy"
    case termsOfUse = "terms of use"
    case openSourceLibraries = "open source libraries"
}

struct MenuItem {
     let image: UIImage
     let label: MenuItemType
    init(image: UIImage, label: MenuItemType) {
        self.image = image
        self.label = label
    }
}
