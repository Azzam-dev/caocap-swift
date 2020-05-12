//
//  CosmosBaseVC.swift
//  caocap
//
//  Created by omar alzhrani on 15/09/1441 AH.
//  Copyright © 1441 Ficruty. All rights reserved.
//

import UIKit
import SwiftUI

class CosmosBaseVC: UIViewController {

    let chartView = UIHostingController(rootView: ChartUI())
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var toolsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var gestureRecognizerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(chartView)
        chartView.view.frame = view.frame
        contentView.addSubview(chartView.view)
        chartView.didMove(toParent: self)
        self.navigationController?.isNavigationBarHidden = true
        
        gestureRecognizerSetup()
    }
    
    func gestureRecognizerSetup() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        upSwipe.direction = .up
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        downSwipe.direction = .down
        
        gestureRecognizerView.addGestureRecognizer(upSwipe)
        gestureRecognizerView.addGestureRecognizer(downSwipe)
        
        
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
                switch sender.direction {
                case .up:
                    if self.toolsViewHeightConstraint.constant == 75 {
                        toolsViewAnimation(120)
                    } else {
                        toolsViewAnimation(300)
                    }
                case .down:
                    if self.toolsViewHeightConstraint.constant == 120 {
                        toolsViewAnimation(75)
                    } else {
                        toolsViewAnimation(120)
                    }
                default:
                    break
                }
            }
        }
    
    func toolsViewAnimation(_ hight: Int) {
           UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .curveLinear, animations: {
               self.toolsViewHeightConstraint.constant = CGFloat(hight)
               self.view.layoutIfNeeded()
           })
       }

}
