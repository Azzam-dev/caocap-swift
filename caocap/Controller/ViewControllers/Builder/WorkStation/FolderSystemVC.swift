//
//  FolderSystemVC.swift
//  caocap
//
//  Created by CAOCAP inc on 20/08/1443 AH.
//  Copyright © 1443 Ficruty. All rights reserved.
//

import UIKit
import ReSwift

class FolderSystemVC: UIViewController {

    @IBOutlet weak var caocapNameLBL: UILabel!
    @IBOutlet weak var toolsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var gestureRecognizerView: UIView!
    @IBOutlet weak var pagesCollectionView: UICollectionView!
    
    var openedCaocap: Caocap?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gestureRecognizerSetup()
        addSubViews()
        
    }

    func getCaocapData() {
        //TODO: - get Caocap pages and folder Data
    }
    
    
    func gestureRecognizerSetup() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        upSwipe.direction = .up
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        downSwipe.direction = .down
        
        gestureRecognizerView.addGestureRecognizer(upSwipe)
        gestureRecognizerView.addGestureRecognizer(downSwipe)
    }
    
    func addSubViews() {
        view.addSubview(controlsViewContainer)
        view.addSubview(leftViewContainer)
        view.addSubview(rightViewContainer)
        controlsViewContainer.frame = view.frame
        leftViewContainer.frame = view.frame
        rightViewContainer.frame = view.frame
        controlsViewContainer.alpha = 0
        leftViewContainer.alpha = 0
        rightViewContainer.alpha = 0
        controlsViewTopConstraint.constant = -200
        leftViewLeadingConstraint.constant = -view.frame.width
        rightViewTrailingConstraint.constant = -view.frame.width
    }
    
    
    func toolsViewAnimation(_ hight: Int) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .curveLinear, animations: {
            self.toolsViewHeightConstraint.constant = CGFloat(hight)
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func didPressShowHideBottomViewButton(_ sender: UIButton) {
        if self.toolsViewHeightConstraint.constant < 350 {
            toolsViewAnimation(350)
        } else {
            toolsViewAnimation(135)
        }
    }
    
    @IBOutlet var controlsViewContainer: DesignableView!
    @IBOutlet weak var controlsViewTopConstraint: NSLayoutConstraint!
    
    @IBAction func didPressShowHideTopViewButton(_ sender: Any) {
        if self.controlsViewContainer.isHidden {
            self.controlsViewContainer.isHidden = false
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .curveLinear) {
                self.controlsViewContainer.alpha = 1
                self.controlsViewTopConstraint.constant = -20
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .curveLinear) {
                self.controlsViewContainer.alpha = 0
                self.controlsViewTopConstraint.constant = -200
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.controlsViewContainer.isHidden = true
            }
        }
    }
    
    
    @IBOutlet var leftViewContainer: DesignableView!
    @IBOutlet weak var leftViewLeadingConstraint: NSLayoutConstraint!
    
    @IBAction func didPressShowHideLeftViewButton(_ sender: Any) {
        if self.leftViewContainer.isHidden {
            self.leftViewContainer.isHidden = false
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .curveLinear) {
                self.leftViewContainer.alpha = 1
                self.leftViewLeadingConstraint.constant = -20
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .curveLinear) {
                self.leftViewContainer.alpha = 0
                self.leftViewLeadingConstraint.constant = -self.view.frame.width
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.leftViewContainer.isHidden = true
            }
        }
    }
    
    @IBOutlet var rightViewContainer: DesignableView!
    @IBOutlet weak var rightViewTrailingConstraint: NSLayoutConstraint!
    
    @IBAction func didPressShowHideRightViewButton(_ sender: Any) {
        if self.rightViewContainer.isHidden {
            self.rightViewContainer.isHidden = false
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .curveLinear) {
                self.rightViewContainer.alpha = 1
                self.rightViewTrailingConstraint.constant = -20
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .curveLinear) {
                self.rightViewContainer.alpha = 0
                self.rightViewTrailingConstraint.constant = -self.view.frame.width
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.rightViewContainer.isHidden = true
            }
        }
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
    

    
}


extension FolderSystemVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //TODO: - set up the CollectionViewCells for the mainPageCell and pageCell and foldersCell and the addPageCell
        
        let cell: UICollectionViewCell
        if indexPath.row == 0 {
            cell = pagesCollectionView.dequeueReusableCell(withReuseIdentifier: "mainPageCell", for: indexPath)
        } else if indexPath.row == 1 {
            cell = pagesCollectionView.dequeueReusableCell(withReuseIdentifier: "foldersCell", for: indexPath)
        } else if indexPath.row == 4 {
            cell = pagesCollectionView.dequeueReusableCell(withReuseIdentifier: "addPageCell", for: indexPath)
        } else {
            cell = pagesCollectionView.dequeueReusableCell(withReuseIdentifier: "pageCell", for: indexPath)
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.frame.width / 3) - 10
        let height = width * 1.8
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let openedCaocap = openedCaocap else { return }
        
        let storyboard = UIStoryboard(name: "Builder", bundle: nil)
        let vc: UIViewController
        
        switch openedCaocap.type {
        case .art:
            vc = storyboard.instantiateViewController(withIdentifier: "artBuilder") as! ArtBuilderVC
        case .code:
            vc = storyboard.instantiateViewController(withIdentifier: "codeBuilder") as! CodeBuilderVC
        case .block:
            vc = storyboard.instantiateViewController(withIdentifier: "blockBuilder") as! BlockBuilderVC
        }
        navigationController?.pushViewController(vc, animated: false)
    }
}



extension FolderSystemVC: StoreSubscriber {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }
    
    func newState(state: AppState) {
//        TODO: - set up the folder system state
        openedCaocap = state.openedCaocap
        getCaocapData()
    }
    
}
