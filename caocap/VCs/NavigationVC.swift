//
//  NavigationVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 15/01/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit
import Firebase
import RevealingSplashView

var exploreSubVC: UINavigationController!
var chatSubVC: UINavigationController!
var myPageSubVC: UINavigationController!

var navigationControllers: [UINavigationController]!
var navSelectedIndex: Int = 0


class NavigationVC: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    //this is used for the revealing splash animtion
    let revealingSplashView = RevealingSplashView(iconImage: UIImage(named : "caocap app icon" )!, iconInitialSize: CGSize(width: 120, height: 120) , backgroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) )
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        
        //this is for the tap press
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(navNormalTap(_:)))
        tapGesture.numberOfTapsRequired = 1
        navCircleBTN.addGestureRecognizer(tapGesture)
        
        //this is for the long press
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(navLongTap(_:)))
        longGesture.minimumPressDuration = 0.2
        longGesture.allowableMovement = 100
        navCircleBTN.addGestureRecognizer(longGesture)
        
        //this is for the pan gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(navPan(_:)))
        navCircleBTN.addGestureRecognizer(panGesture)
        
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        exploreSubVC = storyboard.instantiateViewController(withIdentifier: "exploreNAV") as? UINavigationController
        myPageSubVC = storyboard.instantiateViewController(withIdentifier: "myPageNAV") as? UINavigationController
        chatSubVC = storyboard.instantiateViewController(withIdentifier: "chatNAV") as? UINavigationController
        
        navigationControllers = [exploreSubVC, myPageSubVC, chatSubVC]
        
        navBTNpressed(navBTNs[navSelectedIndex])
        
        //this is the revealing splash animation
        self.view.addSubview(revealingSplashView)
        revealingSplashView.animationType = SplashAnimationType.popAndZoomOut
        revealingSplashView.startAnimation() {
             print("Completed")
        }
        
    }
    
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet var navBTNs: [UIButton]!
    
    
    @IBOutlet weak var exploreICON: UIImageView!
    @IBOutlet weak var orbitICON: UIImageView!
    @IBOutlet weak var chatICON: UIImageView!
    
    @IBOutlet weak var navCircleViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var navCircleButtonHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var navCircleView: DesignableView!
    @IBOutlet weak var navCircleBTN: UIButton!
    
    
 
    @objc func navNormalTap(_ sender: UIGestureRecognizer){
        print("Normal tap")
        
        navCircleButtonAnimation()
        if self.navCircleViewHeightConstraint.constant == 220 {
            circleViewScaleDownAnimation()
            blurredViewHideAnimation()
        } else if self.navCircleViewHeightConstraint.constant == 65 && blurredView.isHidden {
            switch navSelectedIndex {
            case 0:
                exploreSubVC?.popViewController(animated: true)
            case 1:
                myPageSubVC?.popViewController(animated: true)
            case 2:
                chatSubVC?.popViewController(animated: true)
            default:
                break
            }
            
        } else if cancelPopupsBTN.isHidden == false {
            self.popupACT(self)
        }
        
    }
    
    @objc func navLongTap(_ sender: UIGestureRecognizer){
        print("Long tap")
        if sender.state == .ended {
            print("UIGestureRecognizerStateEnded")
        } else if sender.state == .began {
            print("UIGestureRecognizerStateBegan.")
            
            if self.navCircleViewHeightConstraint.constant == 220 {
                circleViewScaleDownAnimation()
                blurredViewHideAnimation()
            } else {
                circleViewScaleUpAnimation()
                blurredViewShowAnimation()
            }
            //Do Whatever You want on Began of Gesture
        }
    }
    
    
    
    @IBOutlet weak var exploreIconView: UIView!
    @IBOutlet weak var chatIconView: UIView!
    @IBOutlet weak var myprofileIconView: UIView!
    @objc func navPan(_ sender: UIPanGestureRecognizer){
        let panView = sender.view!
        let translation = sender.translation(in: view)
        
        switch sender.state {
        case .began:
            circleViewScaleUpAnimation()
            blurredViewShowAnimation()
            
        case .began , .changed:
            panView.center = CGPoint(x: panView.center.x + translation.x, y: panView.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: view)
            print("is changing")
            
        case .ended:
            if panView.frame.intersects(exploreIconView.frame) {
                navBTNpressed(navBTNs[0])
            } else if panView.frame.intersects(chatIconView.frame) {
                navBTNpressed(navBTNs[1])
            } else if panView.frame.intersects(myprofileIconView.frame) {
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
            blurredView.isHidden = true
            UIView.animate(withDuration: 0.2 , animations: {
                self.blurredView.alpha = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func navCircleButtonAnimation() {
        UIView.animate(withDuration: 0.2 , animations: {
            self.navCircleButtonHeightConstraint.constant = 62
            self.view.layoutIfNeeded()
        }, completion: {(finished:Bool) in
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
                //self.view.layoutIfNeeded()
            }, completion: {(finished:Bool) in
                UIView.animate(withDuration: 0.1 , animations: {
                    self.navCircleViewHeightConstraint.constant = 220
                    //self.view.layoutIfNeeded()
                })
            })
            
        }
    }
    
    func circleViewScaleDownAnimation() {
        if self.navCircleViewHeightConstraint.constant == 220 {
            UIView.animate(withDuration: 0.1 , animations: {
                self.navCircleViewHeightConstraint.constant = 240
                self.view.layoutIfNeeded()
            }, completion: {(finished:Bool) in
                UIView.animate(withDuration: 0.2 , animations: {
                    self.navCircleViewHeightConstraint.constant = 65
                    self.view.layoutIfNeeded()
                }, completion: {(finished:Bool) in
                })
            })
        }
    }
    
    
    @IBAction func navBTNpressed(_ sender: UIButton) {
        circleViewScaleDownAnimation()
        blurredViewHideAnimation()
        
        let previousNavIndex = navSelectedIndex
        navSelectedIndex = sender.tag
        
        let previousVC = navigationControllers[previousNavIndex]
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        
        switch navSelectedIndex {
        case 0:
            exploreICON.image = #imageLiteral(resourceName: "B-launched_rocket")
            orbitICON.image = #imageLiteral(resourceName: "w-planet_filled")
            chatICON.image = #imageLiteral(resourceName: "W-chat")
        case 1:
            exploreICON.image = #imageLiteral(resourceName: "w-launched_rocket")
            orbitICON.image = #imageLiteral(resourceName: "B-planet_filled")
            chatICON.image = #imageLiteral(resourceName: "W-chat")
        case 2:
            exploreICON.image = #imageLiteral(resourceName: "w-launched_rocket")
            orbitICON.image = #imageLiteral(resourceName: "w-planet_filled")
            chatICON.image = #imageLiteral(resourceName: "B-chat")
        default:
            exploreICON.image = #imageLiteral(resourceName: "w-launched_rocket")
            orbitICON.image = #imageLiteral(resourceName: "w-planet_filled")
            chatICON.image = #imageLiteral(resourceName: "W-chat")
        }
        let vc = navigationControllers[navSelectedIndex]
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

extension NavigationVC: UITextFieldDelegate {
    
}
