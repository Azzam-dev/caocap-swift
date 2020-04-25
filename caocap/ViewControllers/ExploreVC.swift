//
//  ExploreVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 17/01/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit
import Firebase

class ExploreVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var caocapsCollectionView: UICollectionView!
    var caocapsArray = [Caocap]()
    
    @IBOutlet weak var searchTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCaocapsData()
        searchTF.delegate = self
        searchTF.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        caocapsCollectionView.delegate = self
        caocapsCollectionView.dataSource = self
        caocapsCollectionView.register(UINib.init(nibName: "caocapCell", bundle: nil), forCellWithReuseIdentifier: "caocapCell")
        
        if let layout = caocapsCollectionView?.collectionViewLayout as? caocapLayout {
            layout.delegate = self
        }
        
    }
    
    var isReleased = Bool()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataService.instance.REF_RELEASED.observe(DataEventType.value, with: { snap in
            self.isReleased = snap.value! as! Bool
            self.caocapsCollectionView.reloadData()
        })
    }
    
    
    //This pulls all the caocaps from firebase and insert them to the caocap array
    func getCaocapsData() {
        DataService.instance.getAllCaocaps(handler: { (returnedExploreArray) in
            self.caocapsArray = returnedExploreArray.shuffled()
            self.caocapsCollectionView.reloadData()
        })
    }
    
    //FIXME: fix searchTF and show the search bar 
    @objc func  textFieldDidChange() {
        if searchTF.text == "" {
            DataService.instance.getAllCaocaps(handler: { (returnedExploreArray) in
                self.caocapsArray = returnedExploreArray
                self.caocapsCollectionView.reloadData()
            })
        } else {
            DataService.instance.getCaocapsQuery(forSearchQuery: searchTF.text!) { (returnedExploreArray) in
                self.caocapsArray = returnedExploreArray
                self.caocapsCollectionView.reloadData()
            }
        }
    }
    
    
    //FIXME: fix scanner func and show the scanner icon in the search bar
    @IBAction func scannerBTN(_ sender: Any) {
        let scannerVC = storyboard?.instantiateViewController(withIdentifier: "scanner")
        scannerVC!.modalPresentationStyle = .fullScreen
        present(scannerVC!, animated: true, completion: nil)
    }
    
    //FIXME: fix filter func and show the filter icon in the search bar
    
    
    
    
}

extension ExploreVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return caocapsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = caocapsCollectionView.dequeueReusableCell(withReuseIdentifier: "caocapCell", for: indexPath) as? caocapCell else { return UICollectionViewCell() }
        
        cell.configureCell(caocap: caocapsArray[indexPath.row], released: isReleased)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let caocap = storyboard.instantiateViewController(withIdentifier: "caocap") as! caocapVC
        caocap.openedCaocap = caocapsArray[indexPath.row]
        navigationController?.pushViewController(caocap, animated: true)
        
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: .curveEaseInOut, animations: { cell?.alpha = 0 })
    }
}


extension ExploreVC: caocapLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        let randomHeight = [350 , 450 , 500].shuffled()
        return CGFloat(randomHeight[0])
    }
}