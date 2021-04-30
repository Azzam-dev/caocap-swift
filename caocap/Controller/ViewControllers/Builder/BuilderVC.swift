//
//  BuilderVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 09/12/2019.
//  Copyright © 2019 Ficruty. All rights reserved.
//

import UIKit

class BuilderVC: UIViewController {
    
    var openedCaocap = Caocap(key: "", dictionary: ["":""])
    
    var cosmosBaseSubVC: CosmosBaseVC!
    var artBuilderSubVC: ArtBuilderVC!
    var testLabSubVC: TestLabVC!
    
    var viewControllers: [UIViewController]!
    var navSelectedIndex: Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        addNavCircleGestures()
        setupSubViewControllers()
    }
    
    @IBAction func exitBuilder(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addNavCircleGestures() {
        //this is for the tap press
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(navNormalTap(_:)))
        tapGesture.numberOfTapsRequired = 1
        navFingerTrackingView.addGestureRecognizer(tapGesture)
        
        //this is for the long press
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(navLongTap(_:)))
        longGesture.minimumPressDuration = 0.2
        longGesture.allowableMovement = 100
        navFingerTrackingView.addGestureRecognizer(longGesture)
        
        //this is for the pan gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(navPan(_:)))
        navFingerTrackingView.addGestureRecognizer(panGesture)
    }
    
    
    func setupSubViewControllers() {
        let storyboard = UIStoryboard(name: "Builder", bundle: nil)
        cosmosBaseSubVC = storyboard.instantiateViewController(withIdentifier: "cosmosBase") as? CosmosBaseVC
        testLabSubVC = storyboard.instantiateViewController(withIdentifier: "testLab") as? TestLabVC
        switch openedCaocap.type {
        case .link:
            artBuilderSubVC = storyboard.instantiateViewController(withIdentifier: "linkBuilder") as? LinkBuilderVC
        case .code:
            artBuilderSubVC = storyboard.instantiateViewController(withIdentifier: "codeBuilder") as? CodeBuilderVC
        case .template:
            artBuilderSubVC = storyboard.instantiateViewController(withIdentifier: "templateBuilder") as? TemplateBuilderVC
        case .block:
            artBuilderSubVC = storyboard.instantiateViewController(withIdentifier: "artBuilder") as? CodeBuilderVC
        case .chat:
            artBuilderSubVC = storyboard.instantiateViewController(withIdentifier: "artBuilder") as? CodeBuilderVC
        }
        
        cosmosBaseSubVC?.openedCaocapKey = openedCaocap.key
        artBuilderSubVC?.openedCaocapKey = openedCaocap.key
        testLabSubVC?.openedCaocapKey = openedCaocap.key
        testLabSubVC?.openedCaocapType = openedCaocap.type
        
        viewControllers = [cosmosBaseSubVC!, artBuilderSubVC!, testLabSubVC!]
        navBTNpressed(navBTNs[navSelectedIndex])
    }
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet var navBTNs: [UIButton]!
    
    @IBOutlet weak var cosmosBaseICON: UIImageView!
    @IBOutlet weak var artBuilderICON: UIImageView!
    @IBOutlet weak var testLabICON: UIImageView!
    
    @IBOutlet weak var navCircleViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var navCircleButtonHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var navCircleView: DesignableView!
    @IBOutlet weak var navFingerTrackingView: UIView!
    
    @objc func navNormalTap(_ sender: UIGestureRecognizer){
        navCircleButtonAnimation()
        if self.navCircleViewHeightConstraint.constant == 220 {
            circleViewScaleDownAnimation()
            blurredViewHideAnimation()
        } else if self.navCircleViewHeightConstraint.constant == 65 && blurredView.isHidden {
            
            switch navSelectedIndex {
            case 0:
                print("cosmosBase pop View Controller")
                self.dismiss(animated: true, completion: nil)
                // TODO: pop the top view controller in the cosmosBase NavigationController
            // like this -> exploreSubNAV?.popViewController(animated: true)
            case 1:
                print("artBuilder pop View Controller")
                self.dismiss(animated: true, completion: nil)
                // TODO: pop the top view controller in the artBuilder NavigationController
            case 2:
                print("testLab pop View Controller")
                self.dismiss(animated: true, completion: nil)
                // TODO: pop the top view controller in the testLab NavigationController
            default:
                break
            }
            
        } else if cancelPopupsBTN.isHidden == false {
            self.popupACT(self)
        }
        
    }
    
    @objc func navLongTap(_ sender: UIGestureRecognizer){
        if sender.state == .began {
            if self.navCircleViewHeightConstraint.constant == 220 {
                circleViewScaleDownAnimation()
                blurredViewHideAnimation()
                navCircleButtonAnimation()
            } else {
                circleViewScaleUpAnimation()
                blurredViewShowAnimation()
            }
        }
    }
    
    @IBOutlet weak var cosmosBaseIconView: UIView!
    @IBOutlet weak var artBuilderIconView: UIView!
    @IBOutlet weak var testLabIconView: UIView!
    @objc func navPan(_ sender: UIPanGestureRecognizer){
        let panView = sender.view!
        let translation = sender.translation(in: view)
        
        switch sender.state {
        case .began:
            circleViewScaleUpAnimation()
            blurredViewShowAnimation()
            
        case .changed:
            panView.center = CGPoint(x: panView.center.x + translation.x, y: panView.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: view)
            
        case .ended:
            if panView.frame.intersects(cosmosBaseIconView.frame) {
                navBTNpressed(navBTNs[0])
            } else if panView.frame.intersects(artBuilderIconView.frame) {
                navBTNpressed(navBTNs[1])
            } else if panView.frame.intersects(testLabIconView.frame) {
                navBTNpressed(navBTNs[2])
            }
            
            circleViewScaleDownAnimation()
            blurredViewHideAnimation()
        default:
            break
        }
    }
    
    func blurredViewShowAnimation() {
        if blurredView.isHidden {
            blurredView.isHidden = false
            UIView.animate(withDuration: 0.2 , animations: {
                self.blurredView.alpha = 1
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func blurredViewHideAnimation() {
        if blurredView.isHidden == false {
            UIView.animate(withDuration: 0.2 , animations: {
                self.blurredView.alpha = 0
                self.view.layoutIfNeeded()
            }, completion: { finished in
                self.blurredView.isHidden = true
            })
        }
    }
    
    func navCircleButtonAnimation() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        UIView.animate(withDuration: 0.2 , animations: {
            self.navCircleButtonHeightConstraint.constant = 62
            self.view.layoutIfNeeded()
        }, completion: { finished in
            UIView.animate(withDuration: 0.1 , animations: {
                self.navCircleButtonHeightConstraint.constant = 65
                self.view.layoutIfNeeded()
            })
        })
    }
    
    func circleViewScaleUpAnimation() {
        if self.navCircleViewHeightConstraint.constant == 65 {
            navCircleButtonAnimation()
            UIView.animate(withDuration: 0.2 , animations: {
                self.navCircleViewHeightConstraint.constant = 240
            }, completion: { finished in
                UIView.animate(withDuration: 0.1 , animations: {
                    self.navCircleViewHeightConstraint.constant = 220
                })
            })
        }
    }
    
    func circleViewScaleDownAnimation() {
        if self.navCircleViewHeightConstraint.constant == 220 {
            UIView.animate(withDuration: 0.1 , animations: {
                self.navCircleViewHeightConstraint.constant = 240
                self.view.layoutIfNeeded()
            }, completion: { finished in
                UIView.animate(withDuration: 0.2 , animations: {
                    self.navCircleViewHeightConstraint.constant = 65
                    self.view.layoutIfNeeded()
                })
            })
        }
    }
    
    @IBAction func navBTNpressed(_ sender: UIButton) {
        circleViewScaleDownAnimation()
        blurredViewHideAnimation()
        
        let previousNavIndex = navSelectedIndex
        navSelectedIndex = sender.tag
        
        let previousVC = viewControllers[previousNavIndex]
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        
        switch navSelectedIndex {
        case 0:
            cosmosBaseICON.image = #imageLiteral(resourceName: "cosmos-1")
            artBuilderICON.image = #imageLiteral(resourceName: "artBuilder")
            testLabICON.image = #imageLiteral(resourceName: "testLab")
        case 1:
            cosmosBaseICON.image = #imageLiteral(resourceName: "cosmos")
            artBuilderICON.image = #imageLiteral(resourceName: "artBuilder-1")
            testLabICON.image = #imageLiteral(resourceName: "testLab")
        case 2:
            cosmosBaseICON.image = #imageLiteral(resourceName: "cosmos")
            artBuilderICON.image = #imageLiteral(resourceName: "artBuilder")
            testLabICON.image = #imageLiteral(resourceName: "testLab-1")
        default:
            cosmosBaseICON.image = #imageLiteral(resourceName: "cosmos")
            artBuilderICON.image = #imageLiteral(resourceName: "artBuilder")
            testLabICON.image = #imageLiteral(resourceName: "testLab")
        }
        let vc = viewControllers[navSelectedIndex]
        addChild(vc)
        
        vc.view.frame = contentView.bounds
        contentView.addSubview(vc.view)
        vc.didMove(toParent: self)
        
    }
    
    @IBOutlet weak var blurredView: UIVisualEffectView!
    @IBOutlet weak var cancelPopupsBTN: UIButton!
    
    @IBAction func popupACT(_ sender: Any) {
        if self.navCircleViewHeightConstraint.constant == 220 {
            circleViewScaleDownAnimation()
            blurredViewHideAnimation()
        }
    }
    
}


