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
        DataService.instance.REF_CAOCAPS.child(openedCaocapKey).observe(.value) { (caocapSnapshot) in
            guard let caocapSnapshot = caocapSnapshot.value as? [String : Any] else { return }
            let caocap = Caocap(key: openedCaocapKey, dictionary: caocapSnapshot)
            //... do something with the data
            print(caocap)
        }
    }
    
    @IBOutlet var topToolBarBTNs: [UIButton]!
    @IBAction func topToolBarBTNs(_ sender: UIButton) {
        topToolBarBTNs[0].setImage(#imageLiteral(resourceName: "icons8-mesh"), for: .normal)
        topToolBarBTNs[1].setImage(#imageLiteral(resourceName: "icons8-email"), for: .normal)
        topToolBarBTNs[2].setImage(#imageLiteral(resourceName: "icons8-password"), for: .normal)
        switch sender.tag {
        case 0:
            toolsSelectedIndex = 0
            topToolBarBTNs[0].setImage(#imageLiteral(resourceName: "icons8-mesh-1"), for: .normal)
            
        case 1:
            toolsSelectedIndex = 1
            topToolBarBTNs[1].setImage(#imageLiteral(resourceName: "icons8-email-1"), for: .normal)
            
        case 2:
            toolsSelectedIndex = 2
            topToolBarBTNs[2].setImage(#imageLiteral(resourceName: "icons8-password-1"), for: .normal)
            
        default:
            break
        }
    }

}

