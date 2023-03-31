//
//  ExploreVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 17/01/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit

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
        cell.configure(caocap: caocapsArray[indexPath.row])
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


extension ExploreVC: CaocapLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        let randomHeight = [350 , 450 , 500].shuffled()
        return CGFloat(randomHeight[0])
    }
}


extension ExploreVC: CaocapCellDelegate {
    
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
                DataService.instance.addAndRemoveFromOrbit(caocapKey: key, remove: true)
            }
        } else {
            orbitingAction = UIAlertAction(title: "add to orbit", style: .destructive ) { (buttonTapped) in
                DataService.instance.addAndRemoveFromOrbit(caocapKey: key, remove: false)
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
        
        let reportAlertController = UIAlertController(title: "report", message: "Why are you reporting this caocap ?", preferredStyle: .actionSheet)
        
        let spamAction = UIAlertAction(title: "it's spam", style: .default) { UIAlertAction in
            print("he's spamming his caocap")
            
        }
        
        let doesNotWorkAction = UIAlertAction(title: "it doesn't work well", style: .default) { UIAlertAction in
            print("it has a problem in it")
            
        }
        
        let falseAction = UIAlertAction(title: "false information", style: .default) { UIAlertAction in
            print("The information is not right ")
            
        }
        
        let dislikeAction = UIAlertAction(title: "I Just don't like it", style: .default) { UIAlertAction in
            print("I don't like it")
            
        }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel)
        
        reportAlertController.addAction(spamAction)
        reportAlertController.addAction(falseAction)
        reportAlertController.addAction(doesNotWorkAction)
        reportAlertController.addAction(dislikeAction)
        reportAlertController.addAction(cancelAction)


        if let popoverController = reportAlertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        }
        
        self.present(reportAlertController, animated: true)
    }
    
}
