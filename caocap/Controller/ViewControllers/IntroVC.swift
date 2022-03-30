//
//  IntroVC.swift
//  caocap
//
//  Created by CAOCAP inc on 26/08/1443 AH.
//  Copyright © 1443 Ficruty. All rights reserved.
//

import UIKit

class IntroVC: UIViewController {

    @IBOutlet weak var frontCard: DesignableView!
    @IBOutlet weak var backCard: DesignableView!
    
    @IBOutlet weak var frontImage: UIImageView!
    @IBOutlet weak var frontTitle: UILabel!
    @IBOutlet weak var frontDescription: UILabel!
    
    let imageArray = [#imageLiteral(resourceName: "B-launched_rocket"), #imageLiteral(resourceName: "B-planet_filled"), #imageLiteral(resourceName: "B-chat")]
    let titleArray = ["Explore", "Build", "Collaborate"]
    let descriptionArray = ["Explore", "Build", "Collaborate"]
    
    @IBOutlet weak var cardSegmentedControl: UISegmentedControl!
    @IBOutlet weak var progressionButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        frontImage.image = imageArray[cardSegmentedControl.selectedSegmentIndex]
        frontTitle.text = titleArray[cardSegmentedControl.selectedSegmentIndex]
        frontDescription.text = descriptionArray[cardSegmentedControl.selectedSegmentIndex]
        // Do any additional setup after loading the view.
    }
    
    
    func cardTransitionAnimation() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut) {
            self.frontCard.alpha = 0
        } completion: { _ in
            self.frontImage.image = self.imageArray[self.cardSegmentedControl.selectedSegmentIndex]
            self.frontTitle.text = self.titleArray[self.cardSegmentedControl.selectedSegmentIndex]
            self.frontDescription.text = self.descriptionArray[self.cardSegmentedControl.selectedSegmentIndex]
            UIView.animate(withDuration: 0.2) {
                self.frontCard.alpha = 1
            }
        }

    }

    @IBAction func didChangeCardSegmentedControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 2 {
            progressionButton.setTitle("Start", for: .normal)
        } else {
            progressionButton.setTitle("Next", for: .normal)
        }
        cardTransitionAnimation()
    }
    
    @IBAction func didPressProgressionButton(_ sender: Any) {
        switch cardSegmentedControl.selectedSegmentIndex {
        case 0:
            cardSegmentedControl.selectedSegmentIndex = 1
            didChangeCardSegmentedControl(cardSegmentedControl)
        case 1:
            cardSegmentedControl.selectedSegmentIndex = 2
            didChangeCardSegmentedControl(cardSegmentedControl)
        default:
            UserDefaults.standard.introCompleted()
            self.dismiss(animated: false, completion: nil)
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.checkCurrentUserStatus()
            }
        }
    }
}
