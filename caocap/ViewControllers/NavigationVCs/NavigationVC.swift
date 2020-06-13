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

var exploreSubNAV: UINavigationController!
var chatSubNAV: UINavigationController!
var myPageSubNAV: UINavigationController!

var navigationControllers: [UINavigationController]!
var navSelectedIndex: Int = 0

class NavigationVC: UIViewController , UINavigationControllerDelegate {
    
    //this is used for the revealing splash animtion
    let revealingSplashView = RevealingSplashView(iconImage: UIImage(named : "caocap app icon" )!, iconInitialSize: CGSize(width: 120, height: 120) , backgroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) )
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        checkNetworkStatus()
        addGesturesToNavCircleBTN()
        setupSubNavigationControllers()
        showSplashAnimation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(openExplore), name: Notification.Name("openExplore"), object: nil)
        
    }
    
    func addGesturesToNavCircleBTN() {
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
    }
    
    func setupSubNavigationControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        exploreSubNAV = storyboard.instantiateViewController(withIdentifier: "exploreNAV") as? UINavigationController
        myPageSubNAV = storyboard.instantiateViewController(withIdentifier: "myPageNAV") as? UINavigationController
        chatSubNAV = storyboard.instantiateViewController(withIdentifier: "chatNAV") as? UINavigationController
        navigationControllers = [exploreSubNAV, myPageSubNAV, chatSubNAV]
        navBTNpressed(navBTNs[navSelectedIndex])
    }
    
    func showSplashAnimation() {
        //this is the revealing splash animation
        self.view.addSubview(revealingSplashView)
        revealingSplashView.animationType = SplashAnimationType.popAndZoomOut
        revealingSplashView.startAnimation()
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
        navCircleButtonAnimation()
        if self.navCircleViewHeightConstraint.constant == 220 {
            circleViewScaleDownAnimation()
            blurredViewHideAnimation()
        } else if self.navCircleViewHeightConstraint.constant == 65 && blurredView.isHidden {
            switch navSelectedIndex {
            case 0:
                if exploreSubNAV.viewControllers.count == 1 {
                    //this calls the reload explore function 
                    NotificationCenter.default.post(name: Notification.Name("reloadExplore"), object: nil)
                } else {
                exploreSubNAV?.popViewController(animated: true)
                }
            case 1:
                if myPageSubNAV.viewControllers.count == 1 {
                    //this calls the reload myProfile function
                    NotificationCenter.default.post(name: Notification.Name("reloadMyProfile"), object: nil)
                } else {
                myPageSubNAV?.popViewController(animated: true)
                }
            case 2:
                chatSubNAV?.popViewController(animated: true)
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
            
        case .changed:
            panView.center = CGPoint(x: panView.center.x + translation.x, y: panView.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: view)
            
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
    
    @objc func openExplore() { navBTNpressed(navBTNs[0]) }
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
    
    func checkNetworkStatus() {
        //check if the Network is available if not present a message requesting a network connection
        if !Reachability()!.isReachable {
            displayAlertMessage(messageToDisplay: "لا يوجد اتصال بالانترنت")
        } else {
            print("كل شي تمام")
        }
    }
    
    func displayAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "عذراً", message: messageToDisplay, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "حسناً", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
}

extension NavigationVC: UITextFieldDelegate {
    
}

