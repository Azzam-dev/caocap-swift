//
//  OService.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 30/07/1443 AH.
//  Copyright © 1443 Ficruty. All rights reserved.
//

import UIKit
import ReSwift


@objc class OService: NSObject {
    static let instance = OService()
    
    @objc func sayHelloFromSwift() {
        print("Hello CAOCAP from swift")
    }
    
    //MARK: - change background color
    @objc func changeBackgroundColor(hex: String) {
        store.dispatch(UpdateBackGroundColorForCaocapVCAction(color: UIColor(hex: hex) ?? .black))
    }
    
    //TODO: - add label
    
    //TODO: - change label color
    
    //TODO: - change label font
    
    //TODO: - add image
    
    //TODO: - change image
    
    //TODO: - add button
    
}


