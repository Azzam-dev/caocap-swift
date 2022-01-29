//
//  CodeBuilderVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 07/05/2020.
//  Copyright © 2020 Ficruty. All rights reserved.
//

import UIKit
import WebKit
import Firebase

class CodeBuilderVC: ArtBuilderVC {

    @IBOutlet weak var codeCollectionView: UICollectionView!

    var caocapCode = ["html":"<h1> failed to load.. </h1>", "js":"// failed to load..", "css":"/* failed to load.. */"]
    override func viewDidLoad() {
        super.viewDidLoad()
        getCaocapData()
        topToolBarBTNs(topToolBarBTNs[1])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        codeCollectionView.scrollToItem(at:IndexPath(item: 1, section: 0), at: .right, animated: false)
    }
    
    func getCaocapData() {
        guard let openedCaocapKey = openedCaocap?.key else { return }
        DataService.instance.getCaocap(withKey: openedCaocapKey) { caocap in
            if let code = caocap.code { self.caocapCode = code }
        }
    }
    
    
    @IBAction func didSwipeCollectionView(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .left:
            switch toolsSelectedIndex {
            case 0:
                topToolBarBTNs(topToolBarBTNs[1])
            case 1:
                topToolBarBTNs(topToolBarBTNs[2])
            default:
                break
            }
        case .right:
            switch toolsSelectedIndex {
            case 1:
                topToolBarBTNs(topToolBarBTNs[0])
            case 2:
                topToolBarBTNs(topToolBarBTNs[1])
            default:
                break
            }
        default:
            break
        }
    }
}

extension CodeBuilderVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return caocapCode.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "codeCell", for: indexPath) as? CodeCell, let openedCaocapKey = openedCaocap?.key else { return UICollectionViewCell() }
        
        switch indexPath.row {
        case 0:
            cell.configure(code: caocapCode["js"]!, type: .js, key: openedCaocapKey)
        case 1:
            cell.configure(code: caocapCode["html"]!, type: .html, key: openedCaocapKey)
        case 2:
            cell.configure(code: caocapCode["css"]!, type: .css, key: openedCaocapKey)
        default:
            break
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        let height = collectionView.frame.size.height
        return CGSize(width: width , height: height)
    }
}

