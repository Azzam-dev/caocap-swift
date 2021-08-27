//
//  BlockBuilderVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 25/08/2021.
//  Copyright © 2021 Ficruty. All rights reserved.
//

import UIKit

class BlockBuilderVC: ArtBuilderVC {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var logicMindMap: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)], for: .selected)
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

    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            logicMindMap.isHidden = false
            view.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)
            backgroundImage.tintColor = .white
            
        } else {
            logicMindMap.isHidden = true
            view.backgroundColor = .white
            backgroundImage.tintColor = .black
        }
        
    }
}
