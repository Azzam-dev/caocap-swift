//
//  OrbitingVC.swift
//  caocap
//
//  Created by omar alzhrani on 02/08/1443 AH.
//  Copyright © 1443 Ficruty. All rights reserved.
//

import UIKit
import Firebase

class OrbitingVC: UIViewController {
    
    @IBOutlet weak var orbitingCollectionView: UICollectionView!
    var caocapsArray = [Caocap]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCaocapsData()
        
        
        orbitingCollectionView.contentInset.top = 45
        orbitingCollectionView.register(UINib.init(nibName: "CaocapCell", bundle: nil), forCellWithReuseIdentifier: "caocapCell")
        
        if let layout = orbitingCollectionView?.collectionViewLayout as? CaocapLayout {
            layout.delegate = self
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadExplore), name: Notification.Name("reloadExplore"), object: nil)
        
    }
    
    var isReleased = Bool()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataService.instance.REF_RELEASED.observe(DataEventType.value, with: { snap in
            self.isReleased = snap.value! as! Bool
            self.orbitingCollectionView.reloadData()
        })
    }
    
    
    //This pulls all the caocaps from firebase and insert them to the caocap array
    func getCaocapsData() {
        DataService.instance.getMyOrbitingCaocaps { caocapsArray in
            self.caocapsArray = caocapsArray
            self.orbitingCollectionView.reloadData()
        }
    }
    
    
    @objc func reloadExplore() {
        getCaocapsData()
    }
}
    
   extension OrbitingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return caocapsArray.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = orbitingCollectionView.dequeueReusableCell(withReuseIdentifier: "caocapCell", for: indexPath) as? CaocapCell else { return UICollectionViewCell() }
            cell.caocapCellDelegate = self
            cell.configure(caocap: caocapsArray[indexPath.row], released: isReleased)
            return cell
            
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            let storyboard = UIStoryboard(name: "Explore", bundle: nil)
            let caocap = storyboard.instantiateViewController(withIdentifier: "openedCaocapVC") as! OpenedCaocapVC
            caocap.openedCaocap = caocapsArray[indexPath.row]
            navigationController?.pushViewController(caocap, animated: true)
            
            let cell = collectionView.cellForItem(at: indexPath)
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: .curveEaseInOut, animations: { cell?.alpha = 0 })
        }
    }
    
    
    extension OrbitingVC: CaocapLayoutDelegate {
        func collectionView(_ collectionView: UICollectionView,heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
            let randomHeight = [350 , 450 , 500]
            return CGFloat(randomHeight[0])
        }
    }
    
    
    extension OrbitingVC: CaocapCellDelegate {
        
        func loadCaocapVC(with vc: CaocapVC, on view: UIView) {
            addChild(vc)
            vc.view.frame = view.frame
            view.addSubview(vc.view)
            vc.didMove(toParent: self)
        }
        
        
        func moreBTNpressed(key: String, name: String, isOrbiting: Bool) {
            
            let moreInfoPopup = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let visitOwnerACT = UIAlertAction(title: name, style: .default ) { (buttonTapped) in
                print("visitOwnerACT")
            }
            
            let reportAction = UIAlertAction(title: "report", style: .destructive ) { (buttonTapped) in
                self.prisentReportAlert()
            }
            
            var orbitingAction = UIAlertAction()
            
            
            if isOrbiting {
                orbitingAction = UIAlertAction(title: "remove from orbit", style: .destructive ) { (buttonTapped) in
                    DataService.instance.addAndReomveFromOrbit(caocapKey: key, remove: true)
                }
            } else {
                orbitingAction = UIAlertAction(title: "add to orbit", style: .destructive ) { (buttonTapped) in
                    DataService.instance.addAndReomveFromOrbit(caocapKey: key, remove: false)
                }
            }
            
            
            let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
            
            moreInfoPopup.addAction(visitOwnerACT)
            moreInfoPopup.addAction(reportAction)
            moreInfoPopup.addAction(orbitingAction)
            moreInfoPopup.addAction(cancel)
            
            if let popoverController = moreInfoPopup.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            }
            
            self.present(moreInfoPopup, animated: true)
            
        }
        func prisentReportAlert() {
            
            let reportAlertConroller = UIAlertController(title: "report", message: "Why are you reporting this caocap ?", preferredStyle: .actionSheet)
            
            let spamAction = UIAlertAction(title: "it's spam", style: .default) { UIAlertAction in
                print("he's spamming his caocap")
                
            }
            
            let DosenNotWorkAction = UIAlertAction(title: "it's Dosen't work well", style: .default) { UIAlertAction in
                print("it has a problem in it")
                
            }
            
            let falseAction = UIAlertAction(title: "false information", style: .default) { UIAlertAction in
                print("The information is not right ")
                
            }
            
            let deslikeAction = UIAlertAction(title: "I Just don't like it", style: .default) { UIAlertAction in
                print("I don't like it")
                
            }
            
            let cencelAction = UIAlertAction(title: "cencel", style: .cancel)
            
            reportAlertConroller.addAction(spamAction)
            reportAlertConroller.addAction(falseAction)
            reportAlertConroller.addAction(DosenNotWorkAction)
            reportAlertConroller.addAction(deslikeAction)
            reportAlertConroller.addAction(cencelAction)
            
            
            if let popoverController = reportAlertConroller.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            }
            
            self.present(reportAlertConroller, animated: true)
        }
    }


