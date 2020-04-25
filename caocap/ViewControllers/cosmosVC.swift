//
//  cosmosVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 17/01/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit
import Firebase

class cosmosVC: UIViewController {
    
    @IBOutlet weak var cosmosColView: UICollectionView!
    var caocapsArray = [Caocap]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cosmosColView.delegate = self
        cosmosColView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    
    
}



extension cosmosVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return caocapsArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell = cosmosColView.dequeueReusableCell(withReuseIdentifier: "cosmosCell", for: indexPath) as? cosmosCell else { return UICollectionViewCell() }
            
            return cell
        } else {
//            let caocap = caocapWEB[indexPath.row - 1]
            guard let cell = cosmosColView.dequeueReusableCell(withReuseIdentifier: "cosmosCaocapCell", for: indexPath) as? cosmosCaocapCell else { return UICollectionViewCell() }
            
//            let theURL = URL(string: caocap)
//            let defaultValue = URL(string: "https://ficruty.wixsite.com/caocap")!
//            var urlRequest = URLRequest(url: theURL ?? defaultValue)
//            urlRequest.cachePolicy = .returnCacheDataElseLoad
//            cell.configureCell(website: urlRequest)
            
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            
            let width = collectionView.frame.size.width
            let xInsets: CGFloat = 20
            
            return CGSize(width: width - xInsets , height: 250 )
        } else {
            
            let width = collectionView.frame.size.width
            let xInsets: CGFloat = 20
            
            return CGSize(width: width - xInsets , height: 100 )
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
        } else {
            
            
        }
    }
    
    
}



