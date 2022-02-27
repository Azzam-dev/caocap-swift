//
//  CaocapVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 14/08/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit
import Firebase

class CaocapVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var caocapsCollectionView: UICollectionView!
    var openedCaocap: Caocap?
    var caocapsArray = [Caocap]()
    
    
    @IBOutlet weak var searchTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCaocapsData()
        searchTF.delegate = self
        searchTF.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        caocapsCollectionView.register(UINib.init(nibName: "CaocapCell", bundle: nil), forCellWithReuseIdentifier: "caocapCell")
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
        DataService.instance.getAllPublishedCaocaps(handler: { (returnedExploreArray) in
            self.caocapsArray = returnedExploreArray.shuffled()
            self.caocapsCollectionView.reloadData()
        })
    }
    
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
    
}

extension CaocapVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout , OpenedCaocapCellDelegate {
    
    //this is the share function, when the shareBTN in the opendCaocapVC is pressed it will show the share Viewc Controller
    func shareBTNpressed(cell: OpenedCaocapCell, didTappedshow button: UIButton) {
        let activityVC = UIActivityViewController(activityItems: ["https://caocap.app"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true , completion: nil)
        
    }
    
    
    //this is the more info function, when the moreBTN in the opendCaocapCell is pressed it will display Alert controller with more functions
    func moreBTNpressed(cell: OpenedCaocapCell, didTappedshow button: UIButton) {
        let moreInfoPopup = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let visitOwnerACT = UIAlertAction(title: openedCaocap?.name, style: .default ) { (buttonTapped) in
            //FIXME: عند اختيار هذا الخيار يجب ارسال المستخدم الى صفحة صاحب الكوكب
            print("visitOwnerACT")
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        moreInfoPopup.addAction(visitOwnerACT)
        moreInfoPopup.addAction(cancel)
        
        if let popoverController = moreInfoPopup.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        }
        
        self.present(moreInfoPopup, animated: true , completion: nil)
        
    }
    
    //this is the room function, when the roomBTN in the opendCaocapVC is pressed it will
    func roomBTNpressed(cell: OpenedCaocapCell, didTappedshow button: UIButton) {
        let storyboard = UIStoryboard(name: "Chat", bundle: nil)
        let caocapRoomVC = storyboard.instantiateViewController(withIdentifier: "caocapRoomVC") as! CaocapRoomVC
        caocapRoomVC.openedCaocap = openedCaocap
        navigationController?.pushViewController(caocapRoomVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return caocapsArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell = caocapsCollectionView.dequeueReusableCell(withReuseIdentifier: "openedCaocapCell", for: indexPath) as? OpenedCaocapCell else { return UICollectionViewCell() }
            
            cell.configureCell(caocap: openedCaocap!, released: isReleased)
            cell.delegate = self as OpenedCaocapCellDelegate
            
            return cell
        } else {
            
            guard let cell = caocapsCollectionView.dequeueReusableCell(withReuseIdentifier: "caocapCell", for: indexPath) as? CaocapCell else { return UICollectionViewCell() }
            
            cell.configure(caocap: caocapsArray[indexPath.row - 1], released: isReleased)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            
            let width = collectionView.frame.size.width
            let height = collectionView.frame.size.height
            
            return CGSize(width: width - 20  , height: (height / 1.20) + 20 )
        } else {
            let numberOfColumns: CGFloat = 2
            let width = collectionView.frame.size.width
            let height = collectionView.frame.size.height
            let xInsets: CGFloat = 10
            let cellspacing: CGFloat = 5
            
            return CGSize(width: (width / numberOfColumns) - (xInsets + cellspacing ) , height: height / 1.8 )
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            let storyboard = UIStoryboard(name: "Explore", bundle: nil)
            let caocap = storyboard.instantiateViewController(withIdentifier: "caocap") as! CaocapVC
            caocap.openedCaocap = caocapsArray[indexPath.row - 1]
            navigationController?.pushViewController(caocap, animated: true)
            let cell = collectionView.cellForItem(at: indexPath)
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: .curveEaseInOut, animations: { cell?.alpha = 0 })
            
        }
    }
}

