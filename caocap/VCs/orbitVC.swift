//
//  orbitVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 17/01/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit
import Firebase

class orbitVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var caocapsCollectionView: UICollectionView!
    var orbitsArray = [Caocap]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        caocapsCollectionView.delegate = self
        caocapsCollectionView.dataSource = self
        
        
        caocapsCollectionView.register(UINib.init(nibName: "caocapCell", bundle: nil), forCellWithReuseIdentifier: "caocapCell")
        
        
    }
    
    var isReleased = Bool()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DataService.instance.REF_RELEASED.observe(DataEventType.value, with: { snap in
            self.isReleased = snap.value! as! Bool
            self.caocapsCollectionView.reloadData()
        })
    }
    
    
}


extension orbitVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
            return orbitsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
            guard let cell = caocapsCollectionView.dequeueReusableCell(withReuseIdentifier: "caocapCell", for: indexPath) as? caocapCell else { return UICollectionViewCell() }
            
            cell.configureCell(caocap: orbitsArray[indexPath.row], released: isReleased)
            
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            let width = collectionView.frame.size.width
            let height = collectionView.frame.size.height
            
            return CGSize(width: width / 1.15  , height: height / 1.35  )
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        var caocap = storyboard.instantiateViewController(withIdentifier: "caocap") as! caocapVC
        caocap.openedCaocap = orbitsArray[indexPath.row]
        navigationController?.pushViewController(caocap, animated: true)
        
        
    }
    
}

