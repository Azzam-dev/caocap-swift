//
//  NavigationVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 15/01/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit
import ReSwift


class NavigationVC: UIViewController , UINavigationControllerDelegate {
    
    var myPageSubNAV: UINavigationController!

    var navigationControllers: [UINavigationController]!
    var navSelectedIndex: Int = 0
    
    //this is used for the revealing splash animation
    let revealingSplashView = RevealingSplashView(iconImage: UIImage(named : "caocap app icon" )!, iconInitialSize: CGSize(width: 120, height: 120) , backgroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) )
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        checkNetworkStatus()
        addNavCircleGestures()
        setupSubNavigationControllers()
        showSplashAnimation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(openExplore), name: Notification.Name("openExplore"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentCreateCaocapVC), name: Notification.Name("presentCreateCaocapVC"), object: nil)
        
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
    
    func setupSubNavigationControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        myPageSubNAV = storyboard.instantiateViewController(withIdentifier: "myPageNAV") as? UINavigationController
        navigationControllers = [myPageSubNAV]
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
    
    @IBOutlet weak var orbitICON: UIImageView!
    
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
                if myPageSubNAV.viewControllers.count == 1 {
                    //this calls the reload myProfile function
                    NotificationCenter.default.post(name: Notification.Name("reloadMyProfile"), object: nil)
                } else {
                myPageSubNAV?.popViewController(animated: true)
                }
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
    
    @IBOutlet weak var myProfileIconView: UIView!
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
            if panView.frame.intersects(myProfileIconView.frame) {
                navBTNpressed(navBTNs[0])
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
        
        let previousNav = navigationControllers[previousNavIndex]
        previousNav.willMove(toParent: nil)
        previousNav.view.removeFromSuperview()
        previousNav.removeFromParent()
        
        switch navSelectedIndex {
        case 0:
            orbitICON.image = #imageLiteral(resourceName: "B-planet_filled")
        default:
            orbitICON.image = #imageLiteral(resourceName: "w-planet_filled")
        }
        let nav = navigationControllers[navSelectedIndex]
        addChild(nav)
        
        nav.view.frame = contentView.bounds
        contentView.addSubview(nav.view)
        nav.didMove(toParent: self)
        
    }
    
    
    @IBOutlet weak var blurredView: UIVisualEffectView!
    @IBOutlet weak var cancelPopupsBTN: UIButton!
    
    @IBAction func popupACT(_ sender: Any) {
        if self.navCircleViewHeightConstraint.constant == 220 {
            circleViewScaleDownAnimation()
            blurredViewHideAnimation()
        }
    }
    
    //TODO: I think there is more work to do here
    func checkNetworkStatus() {
        //check if the Network is available if not present a message requesting a network connection
        if Reachability()!.connection == .none {
            displayAlertMessage("No internet connection".localized, in: self)
        } else {
            print("كل شي تمام")
        }
    }
    
}

extension NavigationVC: StoreSubscriber {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }
    
    func newState(state: AppState) {
        if let openedCaocap = state.openedCaocap {
            presentBuilderVC(with: openedCaocap)
        }
    }
    
    func presentBuilderVC(with caocap: Caocap) {
        let storyboard = UIStoryboard(name: "Builder", bundle: nil)
        let builderVC = storyboard.instantiateViewController(withIdentifier: "builder") as! BuilderVC
        builderVC.openedCaocap = caocap
        builderVC.modalPresentationStyle = .fullScreen
        self.present(builderVC, animated: true)
    }
    
    @objc func presentCreateCaocapVC() {
        let storyboard = UIStoryboard(name: "Builder", bundle: nil)
        let createCaocapVC = storyboard.instantiateViewController(withIdentifier: "createCaocap")
        self.present(createCaocapVC, animated: true)
    }
    
}

extension NavigationVC: UITextFieldDelegate {
    
}


