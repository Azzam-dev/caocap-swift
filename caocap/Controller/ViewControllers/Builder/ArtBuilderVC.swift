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
    @IBOutlet weak var collectionView: UICollectionView!
    
    var toolsSelectedIndex = 1

    lazy var viewWidth = self.view.frame.width
    lazy var viewHeight = self.view.frame.height
    
    var caocapCode = ["html":"<h1> failed to load.. </h1>", "js":"// failed to load..", "css":"/* failed to load.. */"]
    var openedCaocap = Caocap(key: "", dictionary: ["":""])
    override func viewDidLoad() {
        super.viewDidLoad()
        getCaocapData()
        gestureRecognizerSetup()
        collectionView.scrollToItem(at:IndexPath(item: 1, section: 0), at: .right, animated: false)
    }
    
    func getCaocapData() {
        DataService.instance.REF_CAOCAPS.child(openedCaocap.key).observe(.value) { (caocapSnapshot) in
            let caocap = caocapSnapshot.value as? [String : AnyObject] ?? [:]
            let code = caocap["code"] as? [String: String] ?? self.caocapCode
            
            self.caocapCode = code
            
        }
    }
    
    @IBOutlet var topToolBarBTNs: [UIButton]!
    @IBAction func topToolBarBTNs(_ sender: UIButton) {
        topToolBarBTNs[0].setImage(#imageLiteral(resourceName: "JS"), for: .normal)
        topToolBarBTNs[1].setImage(#imageLiteral(resourceName: "HTML"), for: .normal)
        topToolBarBTNs[2].setImage(#imageLiteral(resourceName: "CSS"), for: .normal)
        switch sender.tag {
        case 0:
            toolsSelectedIndex = 0
            topToolBarBTNs[0].setImage(#imageLiteral(resourceName: "JS-1"), for: .normal)
            collectionView.scrollToItem(at:IndexPath(item: 0, section: 0), at: .right, animated: true)
//            blockHierarchyTableView.isHidden = false
//            blockCollectionView.isHidden = true
//            dimensionsInspectorTableView.isHidden = true
        case 1:
            toolsSelectedIndex = 1
            topToolBarBTNs[1].setImage(#imageLiteral(resourceName: "HTML-1"), for: .normal)
            collectionView.scrollToItem(at:IndexPath(item: 1, section: 0), at: .right, animated: true)
//            blockHierarchyTableView.isHidden = true
//            blockCollectionView.isHidden = false
//            dimensionsInspectorTableView.isHidden = true
        case 2:
            toolsSelectedIndex = 2
            topToolBarBTNs[2].setImage(#imageLiteral(resourceName: "CSS-1"), for: .normal)
            collectionView.scrollToItem(at:IndexPath(item: 2, section: 0), at: .right, animated: true)
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
    
    @IBAction func didSwipeCollectionView(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .left:
            switch toolsSelectedIndex {
            case 0:
                topToolBarBTNs(topToolBarBTNs[1])
            case 1:
                topToolBarBTNs(topToolBarBTNs[2])
            default:
                break
            }
        case .right:
            switch toolsSelectedIndex {
            case 1:
                topToolBarBTNs(topToolBarBTNs[0])
            case 2:
                topToolBarBTNs(topToolBarBTNs[1])
            default:
                break
            }
        default:
            break
        }
    }
    
    
}

extension ArtBuilderVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return caocapCode.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "codeCell", for: indexPath) as? CodeCell else { return UICollectionViewCell() }
        
        switch indexPath.row {
        case 0:
            cell.configure(code: caocapCode["js"]!)
        case 1:
            cell.configure(code: caocapCode["html"]!)
        case 2:
            cell.configure(code: caocapCode["css"]!)
        default:
            break
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        let height = collectionView.frame.size.height
        return CGSize(width: width , height: height)
    }
    

}
