//
//  LinkBuilderVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 07/04/2021.
//  Copyright © 2021 Ficruty. All rights reserved.
//

import UIKit
import WebKit
import Firebase

class LinkBuilderVC: ArtBuilderVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCaocapData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    func getCaocapData() {
        guard let openedCaocapKey = openedCaocap?.key else { return }
        DataService.instance.getCaocap(withKey: openedCaocapKey) { caocap in
            //... do something with the data
            print(caocap)
        }
    }
    

}

