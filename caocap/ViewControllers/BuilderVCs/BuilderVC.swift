//
//  BuilderVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 09/12/2019.
//  Copyright © 2019 Ficruty. All rights reserved.
//

import UIKit

class BuilderVC: UIViewController {
    
    var artNAV: UINavigationController!
    var logicNAV: UINavigationController!
    var cosmosNAV: UINavigationController!
    var testLabNAV: UINavigationController!
    
    @IBOutlet weak var contentView: UIView!
    
    var navigationControllers: [UINavigationController]!
    var navSelectedIndex: Int = 2
    
    lazy var viewWidth = self.view.frame.width
    lazy var viewHeight = self.view.frame.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubNavigationControllers()
    }
    
    @IBAction func exitBuilder(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
     func setupSubNavigationControllers() {
        
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           artNAV = storyboard.instantiateViewController(withIdentifier: "artBuilderNAV") as? UINavigationController
           logicNAV = storyboard.instantiateViewController(withIdentifier: "logicMindMapNAV") as? UINavigationController
           cosmosNAV = storyboard.instantiateViewController(withIdentifier: "cosmosBaseNAV") as? UINavigationController
        testLabNAV = storyboard.instantiateViewController(withIdentifier: "testLapNAV") as? UINavigationController
           navigationControllers = [cosmosNAV, logicNAV,artNAV, testLabNAV]
           navBTNpressed(navBTNs[navSelectedIndex])
       }
    
    @IBOutlet var navBTNs: [UIButton]!
    
    @IBAction func navBTNpressed(_ sender: UIButton) {
        
        let previousNavIndex = navSelectedIndex
        navSelectedIndex = sender.tag
        
        let previousVC = navigationControllers[previousNavIndex]
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        
        switch navSelectedIndex {
        case 0:
            //            TODO: move the blue view
            print("cosmosBase")
        case 1:
            //            TODO: move the blue view
            print("ligicMindMap")
        case 2:
             //            TODO: move the blue view
            print("artBuilderVC")
        default:
            //            TODO: move the blue view
            print("labVC")
        }
        let vc = navigationControllers[navSelectedIndex]
        addChild(vc)
        vc.view.frame = contentView.bounds
        contentView.addSubview(vc.view)
        vc.didMove(toParent: self)
        
    }
    
}


