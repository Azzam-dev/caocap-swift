//
//  BuilderVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 09/12/2019.
//  Copyright © 2019 Ficruty. All rights reserved.
//

import UIKit

class BuilderVC: UIViewController {
    
    var blocksArray = [ #imageLiteral(resourceName: "icons8-accounting0"), #imageLiteral(resourceName: "icons8-trash0"), #imageLiteral(resourceName: "icons8-lightning_bolt0"), #imageLiteral(resourceName: "icons8-location_off_filled0"), #imageLiteral(resourceName: "icons8-geo_fence0"), #imageLiteral(resourceName: "W-search_filled"), #imageLiteral(resourceName: "icons8-menu0"), #imageLiteral(resourceName: "W-full_screen_filled"), #imageLiteral(resourceName: "W-uncheck_all_filled"), #imageLiteral(resourceName: "icons8-paper_plane_filled0"), #imageLiteral(resourceName: "icons8-no_microphone0"), #imageLiteral(resourceName: "icons8-galaxy0"), #imageLiteral(resourceName: "W-network"), #imageLiteral(resourceName: "icons8-astronaut_helmet0"), #imageLiteral(resourceName: "w-share"), #imageLiteral(resourceName: "W-full_screen_filled"), #imageLiteral(resourceName: "W-uncheck_all_filled"), #imageLiteral(resourceName: "icons8-paper_plane_filled0"), #imageLiteral(resourceName: "icons8-no_microphone0"), #imageLiteral(resourceName: "icons8-galaxy0")]
    
    @IBOutlet weak var designScrollView: UIScrollView!
    
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
            return blocksArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = blockCollectionView.dequeueReusableCell(withReuseIdentifier: "blockCell", for: indexPath) as? blockCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureCell(icon: blocksArray[indexPath.row])
        
        return cell
    }
    
}

extension BuilderVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return designSVContant
    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
    }
}


