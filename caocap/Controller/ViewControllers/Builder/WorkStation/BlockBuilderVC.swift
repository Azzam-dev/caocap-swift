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
