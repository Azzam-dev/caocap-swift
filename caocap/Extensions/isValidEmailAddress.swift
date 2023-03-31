//
//  isValidEmailAddress.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 30/03/2023.
//  Copyright © 2023 Ficruty. All rights reserved.
//

import Foundation

func isValidEmailAddress(_ email: String) -> Bool {
    
    var returnValue = true
    let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
    
    do {
        let regex = try NSRegularExpression(pattern: emailRegEx)
        let nsString = email as NSString
        let results = regex.matches(in: email, range: NSRange(location: 0, length: nsString.length))
        
        if results.count == 0 {
            returnValue = false
        }
        
    } catch let error as NSError {
        print("invalid regex: \(error.localizedDescription)")
        returnValue = false
    }
    
    return  returnValue
}
