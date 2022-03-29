//
//  IntroVC.swift
//  caocap
//
//  Created by CAOCAP inc on 26/08/1443 AH.
//  Copyright © 1443 Ficruty. All rights reserved.
//

import UIKit

class IntroVC: UIViewController {

    @IBOutlet weak var FrontCard: DesignableView!
    @IBOutlet weak var backCard: DesignableView!
    @IBOutlet weak var cardSegmentedControl: UISegmentedControl!
    @IBOutlet weak var progressionButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func didPressProgressionButton(_ sender: Any) {
        switch cardSegmentedControl.selectedSegmentIndex {
        case 0:
            cardSegmentedControl.selectedSegmentIndex = 1
        case 1:
            cardSegmentedControl.selectedSegmentIndex = 2
            progressionButton.setTitle("Start", for: .normal)
        default:
            self.dismiss(animated: false, completion: nil)
        }
    }
}
