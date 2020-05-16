//
//  LogicMindMapVC.swift
//  caocap
//
//  Created by omar alzhrani on 15/09/1441 AH.
//  Copyright © 1441 Ficruty. All rights reserved.
//

import UIKit

class LogicMindMapVC: UIViewController {
    
    
    @IBOutlet weak var optionsContentView: UIView!
    @IBOutlet var optionsStackViews: [UIStackView]!
    @IBOutlet weak var toolsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var gestureRecognizerView: UIView!
    var toolsSelectedIndex: Int = 2
    var toolsPreviousIndex: Int?
    
    @IBOutlet weak var selectorView: DesignableView!
    @IBOutlet var topToolBarBTNs: [UIButton]!
    
    @IBOutlet weak var logicScrollView: UIScrollView!
    @IBOutlet weak var logicSVContant: UIView!
    @IBOutlet var classBlock: UIStackView!
    @IBOutlet var classBlock2: UIStackView!
    @IBOutlet var classBlock3: UIStackView!
    
    lazy var viewWidth = self.view.frame.width
    lazy var viewHeight = self.view.frame.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupStackViews()
        gestureRecognizerSetup()
        
    }
    
    
    @IBAction func topToolBarBTNs(_ sender: UIButton) {
        
        toolsPreviousIndex = toolsSelectedIndex
        toolsSelectedIndex = sender.tag
        optionsSVAnimation()
        topToolBarAnimation()
    }
    
    func topToolBarAnimation() {
        UIView.animate(withDuration: 0.1,animations: {
                  self.selectorView.shadowOpacity = 0
                  
              }, completion: { (finished) in
                  self.selectorView.frame.origin.x = self.topToolBarBTNs[self.toolsSelectedIndex].frame.origin.x + 12
                  UIView.animate(withDuration: 0.1) {
                      self.selectorView.shadowOpacity = 0.2
                  }
              })
    }
    
    func optionsSVAnimation() {

        let previousSV = optionsStackViews[toolsPreviousIndex!]
        let selectedSV = optionsStackViews[toolsSelectedIndex]
        if toolsPreviousIndex! < toolsSelectedIndex {
//            move right
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .curveLinear, animations: {
                previousSV.frame.origin.x = self.optionsContentView.frame.origin.x + self.optionsContentView.frame.size.width
                selectedSV.frame.origin.x = self.optionsContentView.frame.origin.x
            })
            
        } else {
//            move left
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .curveLinear, animations: {
                previousSV.frame.origin.x = self.optionsContentView.frame.origin.x - self.optionsContentView.frame.size.width
                selectedSV.frame.origin.x = self.optionsContentView.frame.origin.x
            })
        }
        
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
    
    func setupStackViews() {
        
        let size = optionsContentView.frame.size
        let originX = optionsContentView.frame.origin.x
    
            
        optionsContentView.addSubview(optionsStackViews[0])
        optionsStackViews[0].frame.size = size
        optionsStackViews[0].frame.origin.x = originX + size.width
        
        optionsContentView.addSubview(optionsStackViews[1])
        optionsStackViews[1].frame.size = size
        optionsStackViews[1].frame.origin.x = originX + size.width
        
        optionsContentView.addSubview(optionsStackViews[2])
        optionsStackViews[2].frame.size = size
        optionsStackViews[2].frame.origin.x = originX 
        
        optionsContentView.addSubview(optionsStackViews[3])
        optionsStackViews[3].frame.size = size
        optionsStackViews[3].frame.origin.x = originX - size.width
        
        optionsContentView.addSubview(optionsStackViews[4])
        optionsStackViews[4].frame.size = size
        optionsStackViews[4].frame.origin.x = originX - size.width
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
