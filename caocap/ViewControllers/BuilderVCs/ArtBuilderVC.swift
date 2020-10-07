//
//  ArtBuilderVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 07/05/2020.
//  Copyright © 2020 Ficruty. All rights reserved.
//

import UIKit
import WebKit
import SwiftSoup
import Firebase

class ArtBuilderVC: UIViewController {
    
    var blocksArray = [#imageLiteral(resourceName: "icons8-text"),  #imageLiteral(resourceName: "icons8-button"),  #imageLiteral(resourceName: "icons8-square.png"),  #imageLiteral(resourceName: "icons8-circled_menu"),  #imageLiteral(resourceName: "icons8-content"),  #imageLiteral(resourceName: "icons8-descending_sorting.png"),  #imageLiteral(resourceName: "icons8-medium_icons"),  #imageLiteral(resourceName: "icons8-play_button"),  #imageLiteral(resourceName: "icons8-map.png"),  #imageLiteral(resourceName: "icons8-progress_indicator"),  #imageLiteral(resourceName: "icons8-favorite_window"),  #imageLiteral(resourceName: "icons8-promotion_window"),  #imageLiteral(resourceName: "icons8-adjust"),  #imageLiteral(resourceName: "icons8-toggle_on")]
    
    var blocks = [
        Block(name: "h1", image: #imageLiteral(resourceName: "icons8-text"), bio: "title text", htmlCode: ["<h1>", #"***"#, "</h1>"])
    ]
    
    @IBOutlet weak var designScrollView: UIScrollView!
    @IBOutlet weak var designSVContant: UIView!
    @IBOutlet var surfaceBlock: UIStackView!
    @IBOutlet var surfaceBlock2: UIStackView!
    @IBOutlet var surfaceBlock3: UIStackView!
    
    
    @IBOutlet weak var blockHierarchyTableView: UITableView!
    @IBOutlet weak var blockCollectionView: UICollectionView!
    @IBOutlet weak var dimensionsInspectorTableView: UITableView!
    
    @IBOutlet weak var toolsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var gestureRecognizerView: UIView!
    
    var toolsSelectedIndex: Int = 1
    var toolsPreviousIndex: Int?
    
    @IBOutlet weak var selectorView: DesignableView!
    @IBOutlet var topToolBarBTNs: [UIButton]!
    
    
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
    
    @IBAction func topToolBarBTNs(_ sender: UIButton) {
        
        toolsPreviousIndex = toolsSelectedIndex
        toolsSelectedIndex = sender.tag
        optionsViewAnimation(sender.tag)
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
    
    func optionsViewAnimation(_ senderTag: Int) {
        switch senderTag {
        case 0:
            blockHierarchyTableView.isHidden = false
            blockCollectionView.isHidden = true
            dimensionsInspectorTableView.isHidden = true
        case 1:
            blockHierarchyTableView.isHidden = true
            blockCollectionView.isHidden = false
            dimensionsInspectorTableView.isHidden = true
        case 2:
            blockHierarchyTableView.isHidden = true
            blockCollectionView.isHidden = true
            dimensionsInspectorTableView.isHidden = false
        default:
            blockHierarchyTableView.isHidden = true
            blockCollectionView.isHidden = false
            dimensionsInspectorTableView.isHidden = true        }
    }
    
    
    func setupViews() {
        designScrollView.contentSize = CGSize(width: viewWidth * 2, height: viewHeight * 2)
        designScrollView.contentOffset = CGPoint(x: viewWidth / 2 , y: viewHeight / 2 )
        
        designScrollView.addSubview(designSVContant)
        designSVContant.frame.size = designScrollView.contentSize
        
        designSVContant.addSubview(surfaceBlock)
        surfaceBlock.frame.origin = CGPoint(x: viewWidth * 0.75, y: viewHeight * 0.6)
        
        designSVContant.addSubview(surfaceBlock2)
        surfaceBlock2.frame.origin = CGPoint(x: surfaceBlock.frame.origin.x + 120 , y: surfaceBlock.frame.origin.y + 300)
        
        
        designSVContant.addSubview(surfaceBlock3)
        surfaceBlock3.frame.origin = CGPoint(x: surfaceBlock.frame.origin.x - 120 , y: surfaceBlock.frame.origin.y + 300)
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
                    optionsViewAnimation(120)
                } else {
                    optionsViewAnimation(300)
                }
            case .down:
                if self.toolsViewHeightConstraint.constant == 120 {
                    optionsViewAnimation(75)
                } else {
                    optionsViewAnimation(120)
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



extension ArtBuilderVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return blocks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = blockCollectionView.dequeueReusableCell(withReuseIdentifier: "blockCell", for: indexPath) as? blockCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureCell(icon: blocks[indexPath.row].image)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let blockIndexPath = blocks[indexPath.row]
        //let htmlBlockCode = blockIndexPath.htmlCode[0] + "testing" + blockIndexPath.htmlCode[2]
        //let caocapHtmlCode = openedCaocap.code["html"]! + htmlBlockCode
        //DataService.instance.launchCaocap(caocapKey: openedCaocap.key, code: ["html": caocapHtmlCode])
        
        
    }
    
}

extension ArtBuilderVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return designSVContant
    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
    }
}


