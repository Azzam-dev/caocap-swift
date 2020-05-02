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
    
    @IBOutlet var surfaceBlock: UIStackView!
    
    lazy var viewWidth = self.view.frame.width
    lazy var viewHeight = self.view.frame.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        designScrollView.contentSize = CGSize(width: viewWidth * 2, height: viewHeight * 2)
        designScrollView.contentOffset = CGPoint(x: viewWidth / 2 , y: viewHeight / 2 )
        
//        if let surface1 = Bundle.main.loadNibNamed("SurfaceBlock", owner: self, options: nil)?.first as? SurfaceBlock {
//            designScrollView.addSubview(surface1)
//        }
        
        designScrollView.addSubview(surfaceBlock)
        surfaceBlock.frame.origin = CGPoint(x: viewWidth / 2 , y: viewHeight / 2 )
        
        designCollectionView.delegate = self
        designCollectionView.dataSource = self
    }
}


extension BuilderVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == designCollectionView {
            return 10
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
            guard let cell = designCollectionView.dequeueReusableCell(withReuseIdentifier: "designCell", for: indexPath) as? designCollectionViewCell else { return UICollectionViewCell() }
            
            cell.configureCell(icon: #imageLiteral(resourceName: "icons8-check"))
            
            return cell
        
    }
    

    
}
