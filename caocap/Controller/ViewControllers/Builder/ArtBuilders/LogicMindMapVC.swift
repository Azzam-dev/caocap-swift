//
//  LogicMindMapVC.swift
//  caocap
//
//  Created by omar alzhrani on 15/09/1441 AH.
//  Copyright © 1441 Ficruty. All rights reserved.
//

import UIKit
import WebKit
import Firebase

class LogicMindMapVC: UIViewController {
    
    @IBOutlet var optionsStackView0: UIStackView!
    @IBOutlet var optionsStackView1: UIStackView!
    @IBOutlet var optionsStackView2: UIStackView!
    
    @IBOutlet weak var toolsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var gestureRecognizerView: UIView!
    
    var toolsSelectedIndex: Int = 2
    var toolsPreviousIndex: Int?
    
    @IBOutlet weak var logicScrollView: UIScrollView!
    @IBOutlet weak var logicSVContant: UIView!
    @IBOutlet var classBlock: UIStackView!
    @IBOutlet var classBlock2: UIStackView!
    @IBOutlet var classBlock3: UIStackView!
    
    
    lazy var viewWidth = self.view.frame.width
    lazy var viewHeight = self.view.frame.height
    
    var openedCaocap = Caocap(key: "", dictionary: ["":""])
    override func viewDidLoad() {
        super.viewDidLoad()
        getCaocapData()
        setupViews()
        gestureRecognizerSetup()
    }
    
    func getCaocapData() {
        DataService.instance.REF_CAOCAPS.child(openedCaocap.key).observe(.value) { (caocapSnapshot) in
            let caocap = caocapSnapshot.value as? [String : AnyObject] ?? [:]
            //...
        }
    }
    
    @IBOutlet var topToolBarBTNs: [UIButton]!
    @IBAction func topToolBarBTNs(_ sender: UIButton) {
        topToolBarBTNs[0].setImage(#imageLiteral(resourceName: "icons8-mesh"), for: .normal)
        topToolBarBTNs[1].setImage(#imageLiteral(resourceName: "JS"), for: .normal)
        topToolBarBTNs[2].setImage(#imageLiteral(resourceName: "icons8-module"), for: .normal)
        switch sender.tag {
        case 0:
            topToolBarBTNs[0].setImage(#imageLiteral(resourceName: "icons8-mesh-1"), for: .normal)
            optionsStackView0.isHidden = false
            optionsStackView1.isHidden = true
            optionsStackView2.isHidden = true
        case 1:
            topToolBarBTNs[1].setImage(#imageLiteral(resourceName: "JS-1"), for: .normal)
            optionsStackView0.isHidden = true
            optionsStackView1.isHidden = false
            optionsStackView2.isHidden = true
        case 2:
            topToolBarBTNs[2].setImage(#imageLiteral(resourceName: "icons8-module-1"), for: .normal)
            optionsStackView0.isHidden = true
            optionsStackView1.isHidden = true
            optionsStackView2.isHidden = false
        default:
            optionsStackView0.isHidden = true
            optionsStackView1.isHidden = true
            optionsStackView2.isHidden = false
        }
    }
    
    
    func optionsViewAnimation(_ senderTag: Int) {
        
    }
    
    func setupViews() {
        logicScrollView.contentSize = CGSize(width: viewWidth * 2, height: viewHeight * 2)
        logicScrollView.contentOffset = CGPoint(x: viewWidth / 2 , y: viewHeight / 2 )
        
        logicScrollView.addSubview(logicSVContant)
        logicSVContant.frame.size = logicScrollView.contentSize
        
        logicSVContant.addSubview(classBlock)
        classBlock.frame.origin = CGPoint(x: viewWidth * 0.75, y: viewHeight * 0.55)
        
        logicSVContant.addSubview(classBlock2)
        classBlock2.frame.origin = CGPoint(x: classBlock.frame.origin.x + 220 , y: viewHeight * 0.55)
        
        
        logicSVContant.addSubview(classBlock3)
        classBlock3.frame.origin = CGPoint(x: classBlock.frame.origin.x - 220 , y: viewHeight * 0.55)
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

extension LogicMindMapVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return logicSVContant
    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
    }
}
