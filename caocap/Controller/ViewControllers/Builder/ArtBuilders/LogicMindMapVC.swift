//
//  LogicMindMapVC.swift
//  caocap
//
//  Created by omar alzhrani on 15/09/1441 AH.
//  Copyright © 1441 Ficruty. All rights reserved.
//

import UIKit
import WebKit
import Firebase

class LogicMindMapVC: ArtBuilderVC {
    
    @IBOutlet var optionsStackView0: UIStackView!
    @IBOutlet var optionsStackView1: UIStackView!
    @IBOutlet var optionsStackView2: UIStackView!
    
    @IBOutlet weak var logicScrollView: UIScrollView!
    @IBOutlet weak var logicSVContant: UIView!
    @IBOutlet var classBlock: UIStackView!
    @IBOutlet var classBlock2: UIStackView!
    @IBOutlet var classBlock3: UIStackView!
    
    lazy var viewWidth = self.view.frame.width
    lazy var viewHeight = self.view.frame.height
    
    var openedCaocap = Caocap(key: "", dictionary: ["":""])
    override func viewDidLoad() {
        super.viewDidLoad()
        getCaocapData()
        setupViews()
        gestureRecognizerSetup()
    }
    
    func getCaocapData() {
        DataService.instance.REF_CAOCAPS.child(openedCaocap.key).observe(.value) { (caocapSnapshot) in
            let caocap = caocapSnapshot.value as? [String : AnyObject] ?? [:]
            print(caocap)
            //...
        }
    }
    
    @IBOutlet var topToolBarBTNs: [UIButton]!
    @IBAction func topToolBarBTNs(_ sender: UIButton) {
        topToolBarBTNs[0].setImage(#imageLiteral(resourceName: "icons8-mesh"), for: .normal)
        topToolBarBTNs[1].setImage(#imageLiteral(resourceName: "JS"), for: .normal)
        topToolBarBTNs[2].setImage(#imageLiteral(resourceName: "icons8-module"), for: .normal)
        switch sender.tag {
        case 0:
            topToolBarBTNs[0].setImage(#imageLiteral(resourceName: "icons8-mesh-1"), for: .normal)
            optionsStackView0.isHidden = false
            optionsStackView1.isHidden = true
            optionsStackView2.isHidden = true
        case 1:
            topToolBarBTNs[1].setImage(#imageLiteral(resourceName: "JS-1"), for: .normal)
            optionsStackView0.isHidden = true
            optionsStackView1.isHidden = false
            optionsStackView2.isHidden = true
        case 2:
            topToolBarBTNs[2].setImage(#imageLiteral(resourceName: "icons8-module-1"), for: .normal)
            optionsStackView0.isHidden = true
            optionsStackView1.isHidden = true
            optionsStackView2.isHidden = false
        default:
            optionsStackView0.isHidden = true
            optionsStackView1.isHidden = true
            optionsStackView2.isHidden = false
        }
    }
    
    
    func setupViews() {
        logicScrollView.contentSize = CGSize(width: viewWidth * 2, height: viewHeight * 2)
        logicScrollView.contentOffset = CGPoint(x: viewWidth / 2 , y: viewHeight / 2 )
        
        logicScrollView.addSubview(logicSVContant)
        logicSVContant.frame.size = logicScrollView.contentSize
        
        logicSVContant.addSubview(classBlock)
        classBlock.frame.origin = CGPoint(x: viewWidth * 0.75, y: viewHeight * 0.55)
        
        logicSVContant.addSubview(classBlock2)
        classBlock2.frame.origin = CGPoint(x: classBlock.frame.origin.x + 220 , y: viewHeight * 0.55)
        
        
        logicSVContant.addSubview(classBlock3)
        classBlock3.frame.origin = CGPoint(x: classBlock.frame.origin.x - 220 , y: viewHeight * 0.55)
    }
    
}

extension LogicMindMapVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return logicSVContant
    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
    }
}
