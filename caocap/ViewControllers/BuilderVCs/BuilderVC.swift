//
//  BuilderVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 09/12/2019.
//  Copyright © 2019 Ficruty. All rights reserved.
//

import UIKit

class BuilderVC: UIViewController {
    
    var artVC: UINavigationController!
    var logicVC: UINavigationController!
    var cosmosVC: UINavigationController!
    var labVC: UINavigationController!

    var navigationControllers: [UINavigationController]!
    var navSelectedIndex: Int = 0
    
    lazy var viewWidth = self.view.frame.width
    lazy var viewHeight = self.view.frame.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubNavigationControllers()
        
    }
    
     func setupSubNavigationControllers() {
//        TODO: fix withIdentifier
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           artVC = storyboard.instantiateViewController(withIdentifier: "exploreNAV") as? UINavigationController
           logicVC = storyboard.instantiateViewController(withIdentifier: "myPageNAV") as? UINavigationController
           cosmosVC = storyboard.instantiateViewController(withIdentifier: "chatNAV") as? UINavigationController
        labVC = storyboard.instantiateViewController(withIdentifier: "chatNAV") as? UINavigationController
           navigationControllers = [artVC, logicVC, cosmosVC, labVC]
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
        
//       TODO: add vc and contentView
//        vc.view.frame = contentView.bounds
//        contentView.addSubview(vc.view)
//        vc.didMove(toParent: self)
        
    }
    
}


