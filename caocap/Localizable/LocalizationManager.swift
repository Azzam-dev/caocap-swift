//
//  LocalizationManager.swift
//  caocap
//
//  Created by omar alzhrani on 13/07/1443 AH.
//  Copyright © 1443 Ficruty. All rights reserved.
//

import Foundation
import UIKit

protocol LocalizationDelegate: AnyObject {
    func resetApp()
}

class LocalizationManager {
    
    enum Language: String {
        case English = "en"
        case Arabic = "ar"
    }
    
    static let shared = LocalizationManager()
    weak var delegate: LocalizationDelegate?
    
    let currentLang = Locale.current.languageCode
    
    func resetApp() {
        delegate?.resetApp()
    }
    
    func checkOfLanguage(language: String) {
        if currentLang == language {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        } else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
    }
    
}
extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
