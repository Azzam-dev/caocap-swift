//
//  ArtBuilderVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 07/05/2020.
//  Copyright © 2020 Ficruty. All rights reserved.
//

import UIKit

class ArtBuilderVC: UIViewController {
    
    var blocksArray = [#imageLiteral(resourceName: "icons8-text"), #imageLiteral(resourceName: "icons8-button"), #imageLiteral(resourceName: "icons8-square.png"), #imageLiteral(resourceName: "icons8-circled_menu"), #imageLiteral(resourceName: "icons8-content"), #imageLiteral(resourceName: "icons8-descending_sorting.png"), #imageLiteral(resourceName: "icons8-medium_icons"), #imageLiteral(resourceName: "icons8-play_button"), #imageLiteral(resourceName: "icons8-map.png"), #imageLiteral(resourceName: "icons8-progress_indicator"), #imageLiteral(resourceName: "icons8-favorite_window"), #imageLiteral(resourceName: "icons8-promotion_window"), #imageLiteral(resourceName: "icons8-adjust"), #imageLiteral(resourceName: "icons8-toggle_on")]
    @IBOutlet weak var designScrollView: UIScrollView!
    @IBOutlet weak var designSVContant: UIView!
    @IBOutlet var surfaceBlock: UIStackView!
    @IBOutlet var surfaceBlock2: UIStackView!
    @IBOutlet var surfaceBlock3: UIStackView!
    
    
    @IBOutlet weak var toolsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var gestureRecognizerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var gestureRecognizerView: UIView!
    @IBOutlet weak var blockCollectionView: UICollectionView!
    
    lazy var viewWidth = self.view.frame.width
    lazy var viewHeight = self.view.frame.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        gestureRecognizerSetuo()
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
    
    func gestureRecognizerSetuo() {
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
                    UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .curveLinear, animations: {
                        self.toolsViewHeightConstraint.constant = 120
                        self.gestureRecognizerViewHeightConstraint.constant = 130
                        self.view.layoutIfNeeded()
                    })
                } else {
                    UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .curveLinear, animations: {
                        self.toolsViewHeightConstraint.constant = 300
                        self.gestureRecognizerViewHeightConstraint.constant = 310
                        self.view.layoutIfNeeded()
                    })
                }
            case .down:
                if self.toolsViewHeightConstraint.constant == 120 {
                    UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .curveLinear, animations: {
                        self.toolsViewHeightConstraint.constant = 75
                        self.gestureRecognizerViewHeightConstraint.constant = 85
                        self.view.layoutIfNeeded()
                    })
                } else {
                    UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .curveLinear, animations: {
                        self.toolsViewHeightConstraint.constant = 120
                        self.gestureRecognizerViewHeightConstraint.constant = 130
                        self.view.layoutIfNeeded()
                    })
                }
            default:
                break
            }
        }
    }
}



extension ArtBuilderVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return blocksArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = blockCollectionView.dequeueReusableCell(withReuseIdentifier: "blockCell", for: indexPath) as? blockCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureCell(icon: blocksArray[indexPath.row])
        
        return cell
    }
    
}

extension ArtBuilderVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return designSVContant
    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
    }
}


