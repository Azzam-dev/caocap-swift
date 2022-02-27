//
//  CodeBuilderVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 07/05/2020.
//  Copyright © 2020 Ficruty. All rights reserved.
//

import UIKit
import Firebase

class CodeBuilderVC: ArtBuilderVC {

    @IBOutlet weak var codeCollectionView: UICollectionView!

    var caocapCode: [(fileName: String, code: String)] = [
        ("main", #"print("hello capcap")"#),
        ("file2", #"print(1+2)"#),
        ("file3", #"print(-200)"#)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topToolBarBTNs(topToolBarBTNs[0])
        getCaocapData()
    }
    
    //this is to make the second cell visible
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        codeCollectionView.scrollToItem(at:IndexPath(item: fileIndex, section: 0), at: .right, animated: false)
    }
    
    func getCaocapData() {
        guard let openedCaocapKey = openedCaocap?.key else { return }
        DataService.instance.getCaocap(withKey: openedCaocapKey) { caocap in
//            if let code = caocap.code { self.caocapCode = code }
        }
    }
    
    var fileIndex = 1
    @IBAction func didSwipeCollectionView(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .left where fileIndex < (caocapCode.count - 1) :
            fileIndex += 1
            
        case .right where fileIndex > 0 :
            fileIndex -= 1
        default:
            break
        }
        codeCollectionView.scrollToItem(at:IndexPath(item: fileIndex, section: 0), at: .right, animated: true)
    }
}

extension CodeBuilderVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return caocapCode.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "codeCell", for: indexPath) as? CodeCell, let openedCaocapKey = openedCaocap?.key else { return UICollectionViewCell() }
        
        let codeFile = caocapCode[indexPath.row]
        cell.configure(fileName: codeFile.fileName, code: codeFile.code, key: openedCaocapKey)
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        let height = collectionView.frame.size.height
        return CGSize(width: width , height: height)
    }
}

