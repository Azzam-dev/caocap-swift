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
        
        caocapsCollectionView.contentInset.top = 45
        caocapsCollectionView.register(UINib.init(nibName: "CaocapCell", bundle: nil), forCellWithReuseIdentifier: "caocapCell")
        
        if let layout = caocapsCollectionView?.collectionViewLayout as? CaocapLayout {
            layout.delegate = self
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadExplore), name: Notification.Name("reloadExplore"), object: nil)
        
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
    
    @objc func reloadExplore() {
        getCaocapsData()
    }
    
    //FIXME: fix searchTF and show the search bar
    @objc func textFieldDidChange() {
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
        
    }
    
    //FIXME: fix filter func and show the filter icon in the search bar
    
}

extension ExploreVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return caocapsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = caocapsCollectionView.dequeueReusableCell(withReuseIdentifier: "caocapCell", for: indexPath) as? CaocapCell else { return UICollectionViewCell() }
        cell.caocapCellDelegate = self
        cell.configure(caocap: caocapsArray[indexPath.row], released: isReleased)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Explore", bundle: nil)
        let caocap = storyboard.instantiateViewController(withIdentifier: "caocap") as! CaocapVC
        caocap.openedCaocap = caocapsArray[indexPath.row]
        navigationController?.pushViewController(caocap, animated: true)
        
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: .curveEaseInOut, animations: { cell?.alpha = 0 })
    }
}


extension ExploreVC: CaocapLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        let randomHeight = [350 , 450 , 500].shuffled()
        return CGFloat(randomHeight[0])
    }
}


extension ExploreVC: CaocapCellDelegate {
    func moreBTNpressed(key: String, name: String) {
        
        let moreInfoPopup = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let reportAction = UIAlertAction(title: "report", style: .destructive ) { (buttonTapped) in
            self.prisentReportAlert()
        }
        let removeAction = UIAlertAction(title: "remove from orbit", style: .destructive ) { (buttonTapped) in
           print("removed orbit")
        }
        let visitOwnerACT = UIAlertAction(title: name, style: .default ) { (buttonTapped) in
           print("visitOwnerACT")
        }
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        moreInfoPopup.addAction(visitOwnerACT)
        moreInfoPopup.addAction(reportAction)
        moreInfoPopup.addAction(removeAction)
        moreInfoPopup.addAction(cancel)
        
        if let popoverController = moreInfoPopup.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        }
        
        self.present(moreInfoPopup, animated: true)
        
    }
    
    
    func prisentReportAlert() {
        
        let reportAlertConroller = UIAlertController(title: "report", message: "Why are you reporting this caocap ?", preferredStyle: .actionSheet)
        
        let action = UIAlertAction(title: "action 1", style: .default) { UIAlertAction in
            print("nothing")
            
        }
        
        let cencelAction = UIAlertAction(title: "cencel", style: .cancel)
        
        reportAlertConroller.addAction(action)
        reportAlertConroller.addAction(cencelAction)

        if let popoverController = reportAlertConroller.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        }
        
        self.present(reportAlertConroller, animated: true)
    }
    
}
