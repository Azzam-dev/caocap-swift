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
    
    @objc func changeBackgroundColor(hex: String) {
        //TODO: - change background color
        store.dispatch(UpdateBackGroundColorForCaocapVCAction(color: UIColor(hex: hex) ?? .black))
    }
    
}


