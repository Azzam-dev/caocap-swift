//
//  LogicMindMapVC.swift
//  caocap
//
//  Created by omar alzhrani on 15/09/1441 AH.
//  Copyright © 1441 Ficruty. All rights reserved.
//

import UIKit

class LogicMindMapVC: UIViewController {

 
    @IBOutlet weak var toolsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var gestureRecognizerView: UIView!
    var topToolBarSelectedIndex: Int = 2
    
    @IBOutlet weak var selectorView: DesignableView!
    @IBOutlet var topToolBarBTNs: [UIButton]!
    @IBAction func topToolBarBTNs(_ sender: UIButton) {
        
        topToolBarSelectedIndex = sender.tag
        
        UIView.animate(withDuration: 0.1,animations: {
            self.selectorView.shadowOpacity = 0
            
        }, completion: { (finished) in
            self.selectorView.frame.origin.x = self.topToolBarBTNs[self.topToolBarSelectedIndex].frame.origin.x + 12
            UIView.animate(withDuration: 0.1) {
                self.selectorView.shadowOpacity = 0.2
            }
            
        })
        
       
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    

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
