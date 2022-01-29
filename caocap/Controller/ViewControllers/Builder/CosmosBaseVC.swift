//
//  CosmosBaseVC.swift
//  caocap
//
//  Created by omar alzhrani on 15/09/1441 AH.
//  Copyright © 1441 Ficruty. All rights reserved.
//

import UIKit
import SwiftUI
import ReSwift
import Firebase

class CosmosBaseVC: UIViewController {
    
    let chartView = UIHostingController(rootView: ChartUI())
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var toolsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var gestureRecognizerView: UIView!
    
    var toolsSelectedIndex = 1
    var openedCaocap: Caocap?
    
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
        guard let openedCaocap = openedCaocap else { return }
        DataService.instance.REF_CAOCAPS.child(openedCaocap.key).observe(.value) { (caocapSnapshot) in
            guard let caocapSnapshot = caocapSnapshot.value as? [String : Any] else { return }
            let caocap = Caocap(key: openedCaocap.key, dictionary: caocapSnapshot)
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
        topToolBarBTNs[0].tintColor = #colorLiteral(red: 0.9215686275, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        topToolBarBTNs[1].tintColor = #colorLiteral(red: 0.9215686275, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        topToolBarBTNs[2].tintColor = #colorLiteral(red: 0.9215686275, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        
        toolsSelectedIndex = sender.tag
        topToolBarBTNs[sender.tag].tintColor = #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1)
    }
    
    func presentSelectedView(_ selectedView: UIView) {

        selectedView.isHidden = false
    }
    
}

extension CosmosBaseVC: StoreSubscriber {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }
    
    func newState(state: AppState) {
        openedCaocap = state.openedCaocap
    }
    
}
