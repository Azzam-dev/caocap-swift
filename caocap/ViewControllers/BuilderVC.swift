//
//  BuilderVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 09/12/2019.
//  Copyright © 2019 Ficruty. All rights reserved.
//

import UIKit

class BuilderVC: UIViewController {
    
    
    @IBOutlet weak var designScrollView: UIScrollView!
    @IBOutlet weak var designCollectionView: UICollectionView!
    
    @IBOutlet weak var blockCollectionView: UICollectionView!
    @IBOutlet weak var designSVContant: UIView!
    @IBOutlet var surfaceBlock: UIStackView!
    @IBOutlet var surfaceBlock2: UIStackView!
    @IBOutlet var surfaceBlock3: UIStackView!
    
    lazy var viewWidth = self.view.frame.width
    lazy var viewHeight = self.view.frame.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        designScrollView.contentSize = CGSize(width: viewWidth * 2, height: viewHeight * 2)
        designScrollView.contentOffset = CGPoint(x: viewWidth / 2 , y: viewHeight / 2 )
        
        designScrollView.addSubview(designSVContant)
        designSVContant.frame.size = designScrollView.contentSize
        
//        if let surface1 = Bundle.main.loadNibNamed("SurfaceBlock", owner: self, options: nil)?.first as? SurfaceBlock {
//            designScrollView.addSubview(surface1)
//        }
        
        designSVContant.addSubview(surfaceBlock)
        surfaceBlock.frame.origin = CGPoint(x: viewWidth * 0.75, y: viewHeight * 0.6)
        
        designSVContant.addSubview(surfaceBlock2)
        surfaceBlock2.frame.origin = CGPoint(x: surfaceBlock.frame.origin.x + 120 , y: surfaceBlock.frame.origin.y + 300)
        
        
        designSVContant.addSubview(surfaceBlock3)
        surfaceBlock3.frame.origin = CGPoint(x: surfaceBlock.frame.origin.x - 120 , y: surfaceBlock.frame.origin.y + 300)
        
    }
}


extension BuilderVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == designCollectionView {
            return 10
        } else {
            return 20
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == designCollectionView {
            guard let cell = designCollectionView.dequeueReusableCell(withReuseIdentifier: "designCell", for: indexPath) as? designCollectionViewCell else { return UICollectionViewCell() }
            
            cell.configureCell(icon: #imageLiteral(resourceName: "W-sorting_options"))
            
            return cell
            
        } else {
            guard let cell = blockCollectionView.dequeueReusableCell(withReuseIdentifier: "blockCell", for: indexPath) as? blockCollectionViewCell else { return UICollectionViewCell() }
            
            cell.configureCell(icon: #imageLiteral(resourceName: "icons8-audio_wave0"))
            
            return cell
        }
        
    }
    
}

extension BuilderVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return designSVContant
    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
    }
}


