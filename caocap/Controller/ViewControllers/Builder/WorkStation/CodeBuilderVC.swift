//
//  CodeBuilderVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 07/05/2020.
//  Copyright © 2020 Ficruty. All rights reserved.
//

import UIKit
import ReSwift
import Firebase

class CodeBuilderVC: UIViewController {

    @IBOutlet weak var toolsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var gestureRecognizerView: UIView!
    
    @IBOutlet weak var codeCollectionView: UICollectionView!

    var toolsSelectedIndex = 0
    var openedCaocap: Caocap?
    
    var codeFile = [
            CodeFile(type: .load, code: "louding..."),
            CodeFile(type: .update, code: "louding..."),
            CodeFile(type: .draw, code: "louding..."),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topToolBarBTNs(topToolBarBTNs[0])
        gestureRecognizerSetup()
        getCaocapData()
    }
    
    
    func getCaocapData() {
        guard let openedCaocapKey = openedCaocap?.key else { return }
        DataService.instance.getCaocap(withKey: openedCaocapKey) { caocap in
            //TODO: - loud caocap Data
        }
    }
    
    var fileIndex = 0
    @IBAction func didSwipeCollectionView(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .left where fileIndex < (codeFile.count - 1) :
            fileIndex += 1
        case .right where fileIndex > 0 :
            fileIndex -= 1
        default:
            break
        }
        codeCollectionView.scrollToItem(at:IndexPath(item: fileIndex, section: 0), at: .right, animated: true)
    }
    
    
    func gestureRecognizerSetup() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        upSwipe.direction = .up
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        downSwipe.direction = .down
        
        gestureRecognizerView.addGestureRecognizer(upSwipe)
        gestureRecognizerView.addGestureRecognizer(downSwipe)
    }
    
    func toolsViewAnimation(_ hight: Int) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .curveLinear, animations: {
            self.toolsViewHeightConstraint.constant = CGFloat(hight)
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            switch sender.direction {
            case .up:
                if self.toolsViewHeightConstraint.constant == 75 {
                    toolsViewAnimation(135)
                } else {
                    toolsViewAnimation(350)
                }
            case .down:
                if self.toolsViewHeightConstraint.constant == 135 {
                    toolsViewAnimation(75)
                } else {
                    toolsViewAnimation(135)
                }
            default:
                break
            }
        }
    }
    
    @IBOutlet var topToolBarBTNs: [UIButton]!
    @IBAction func topToolBarBTNs(_ sender: UIButton) {
        toolsSelectedIndex = sender.tag
        // TODO: - setup codeBuilder topToolBarBTNs
    }

}


extension CodeBuilderVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return codeFile.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "codeCell", for: indexPath) as? CodeCell, let openedCaocapKey = openedCaocap?.key else { return UICollectionViewCell() }
        
        let codeFile = codeFile[indexPath.row]
        cell.configure(fileName: codeFile.type.rawValue, code: codeFile.code, key: openedCaocapKey)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        let height = collectionView.frame.size.height
        return CGSize(width: width , height: height)
    }
}


extension CodeBuilderVC: StoreSubscriber {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }
    
    func newState(state: AppState) {
        openedCaocap = state.openedCaocap
        if let code = openedCaocap?.code?["main"] {
            codeFile = code
        }
    }
    
}

