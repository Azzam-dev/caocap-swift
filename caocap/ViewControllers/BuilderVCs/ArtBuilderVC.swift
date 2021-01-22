//
//  ArtBuilderVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 07/05/2020.
//  Copyright © 2020 Ficruty. All rights reserved.
//

import UIKit
import WebKit
import Firebase

class ArtBuilderVC: UIViewController {
    
    
    @IBOutlet weak var toolsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var gestureRecognizerView: UIView!
    
    var toolsSelectedIndex: Int = 1
    var toolsPreviousIndex: Int?

    lazy var viewWidth = self.view.frame.width
    lazy var viewHeight = self.view.frame.height
    
    var caocapCode = ""
    var openedCaocap = Caocap(key: "", dictionary: ["":""])
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCaocapData()
        gestureRecognizerSetup()
    }
    
    func getCaocapData() {
        DataService.instance.REF_CAOCAPS.child(openedCaocap.key).observe(.value) { (caocapSnapshot) in
            let caocap = caocapSnapshot.value as? [String : AnyObject] ?? [:]
            let code = caocap["code"] as? [String: String] ?? ["html":"<h1> failed to load.. </h1>", "js":"", "css":""]
            
            self.caocapCode = """
            <!DOCTYPE html><html><head><meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
            <meta name="viewport" content="width=device-width, initial-scale=1.0"><meta charset="utf-8"><title>CAOCAP</title><link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous"><style>\(code["css"]!)</style></head><body>\(code["html"]!)<script>\(code["js"]!)</script></body></html>
            """
            
        }
    }
    
    @IBOutlet var topToolBarBTNs: [UIButton]!
    @IBAction func topToolBarBTNs(_ sender: UIButton) {
        topToolBarBTNs[0].setImage(#imageLiteral(resourceName: "icons8-layers"), for: .normal)
        topToolBarBTNs[1].setImage(#imageLiteral(resourceName: "icons8-pen"), for: .normal)
        topToolBarBTNs[2].setImage(#imageLiteral(resourceName: "icons8-ruler"), for: .normal)
        switch sender.tag {
        case 0:
            topToolBarBTNs[0].setImage(#imageLiteral(resourceName: "icons8-layers-1"), for: .normal)
//            blockHierarchyTableView.isHidden = false
//            blockCollectionView.isHidden = true
//            dimensionsInspectorTableView.isHidden = true
        case 1:
            topToolBarBTNs[1].setImage(#imageLiteral(resourceName: "icons8-pen-1"), for: .normal)
//            blockHierarchyTableView.isHidden = true
//            blockCollectionView.isHidden = false
//            dimensionsInspectorTableView.isHidden = true
        case 2:
            topToolBarBTNs[2].setImage(#imageLiteral(resourceName: "icons8-ruler-1"), for: .normal)
//            blockHierarchyTableView.isHidden = true
//            blockCollectionView.isHidden = true
//            dimensionsInspectorTableView.isHidden = false
        default:
            break
//            blockHierarchyTableView.isHidden = true
//            blockCollectionView.isHidden = false
//            dimensionsInspectorTableView.isHidden = true
            
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



