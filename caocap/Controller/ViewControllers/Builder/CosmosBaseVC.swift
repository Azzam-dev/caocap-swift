//
//  CosmosBaseVC.swift
//  caocap
//
//  Created by omar alzhrani on 15/09/1441 AH.
//  Copyright © 1441 Ficruty. All rights reserved.
//

import UIKit
import SwiftUI
import Firebase

class CosmosBaseVC: UIViewController {
    
    let chartView = UIHostingController(rootView: ChartUI())
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var toolsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var gestureRecognizerView: UIView!
    
    var toolsSelectedIndex = 1
    var openedCaocapKey = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCaocapData()
        gestureRecognizerSetup()
        
        addChild(chartView)
        chartView.view.frame = view.frame
        contentView.addSubview(chartView.view)
        chartView.didMove(toParent: self)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func getCaocapData() {
        DataService.instance.REF_CAOCAPS.child(openedCaocapKey).observe(.value) { (caocapSnapshot) in
            guard let caocapSnapshot = caocapSnapshot.value as? [String : Any] else { return }
            let caocap = Caocap(key: self.openedCaocapKey, dictionary: caocapSnapshot)
            print(caocap.name)
            //...
        }
    }
    
    func gestureRecognizerSetup() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        upSwipe.direction = .up
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        downSwipe.direction = .down
        
        gestureRecognizerView.addGestureRecognizer(upSwipe)
        gestureRecognizerView.addGestureRecognizer(downSwipe)
    }
    
    func toolsViewAnimation(_ hight: Int) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .curveLinear, animations: {
            self.toolsViewHeightConstraint.constant = CGFloat(hight)
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            switch sender.direction {
            case .up:
                if self.toolsViewHeightConstraint.constant == 75 {
                    toolsViewAnimation(135)
                } else {
                    toolsViewAnimation(350)
                }
            case .down:
                if self.toolsViewHeightConstraint.constant == 135 {
                    toolsViewAnimation(75)
                } else {
                    toolsViewAnimation(135)
                }
            default:
                break
            }
        }
    }
    
    @IBOutlet var topToolBarBTNs: [UIButton]!
    @IBAction func topToolBarBTNs(_ sender: UIButton) {
        topToolBarBTNs[0].setImage(#imageLiteral(resourceName: "icons8-pictures_folder"), for: .normal)
        topToolBarBTNs[1].setImage(#imageLiteral(resourceName: "icons8-accounting"), for: .normal)
        topToolBarBTNs[2].setImage(#imageLiteral(resourceName: "icons8-flow_chart"), for: .normal)
        switch sender.tag {
        case 0:
            toolsSelectedIndex = 0
            topToolBarBTNs[0].setImage(#imageLiteral(resourceName: "icons8-pictures_folder-1"), for: .normal)
        case 1:
            toolsSelectedIndex = 1
            topToolBarBTNs[1].setImage(#imageLiteral(resourceName: "icons8-accounting-1"), for: .normal)
        case 2:
            toolsSelectedIndex = 2
            topToolBarBTNs[2].setImage(#imageLiteral(resourceName: "icons8-flow_chart-1"), for: .normal)
        default:
            break
        }
    }
    
    func presentSelectedView(_ selectedView: UIView) {

        selectedView.isHidden = false
    }
    
}
