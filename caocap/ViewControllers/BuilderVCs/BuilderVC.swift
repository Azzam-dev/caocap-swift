//
//  BuilderVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 09/12/2019.
//  Copyright © 2019 Ficruty. All rights reserved.
//

import UIKit

class BuilderVC: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    
    var openedCaocap = Caocap(key: "", dictionary: ["":""])
    
    var viewControllers: [UIViewController]!
    var navSelectedIndex: Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        setupSubViewControllers()
    }
    
    @IBAction func exitBuilder(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func setupSubViewControllers() {
        let storyboard = UIStoryboard(name: "Builder", bundle: nil)
        let cosmosBaseVC = storyboard.instantiateViewController(withIdentifier: "cosmosBase") as? CosmosBaseVC
        let logicMindMapVC = storyboard.instantiateViewController(withIdentifier: "logicMindMap") as? LogicMindMapVC
        let artBuilderVC = storyboard.instantiateViewController(withIdentifier: "artBuilder") as? ArtBuilderVC
        let testLabVC = storyboard.instantiateViewController(withIdentifier: "testLab") as? TestLabVC
        
       
        artBuilderVC?.openedCaocap = openedCaocap
        testLabVC?.openedCaocap = openedCaocap
        viewControllers = [cosmosBaseVC!, logicMindMapVC!, artBuilderVC!, testLabVC!]
        let vc = viewControllers[navSelectedIndex]
        addChild(vc)
        vc.view.frame = contentView.bounds
        contentView.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    @IBOutlet weak var selectorView: DesignableView!
    @IBOutlet var navBTNs: [UIButton]!
    @IBAction func navBTNpressed(_ sender: UIButton) {
        
        let previousNavIndex = navSelectedIndex
        navSelectedIndex = sender.tag
        
        let previousVC = viewControllers[previousNavIndex]
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .curveLinear, animations: {
            self.selectorView.frame.origin.x = self.navBTNs[self.navSelectedIndex].frame.origin.x - 10
        })
        
        
        let vc = viewControllers[navSelectedIndex]
        addChild(vc)
        vc.view.frame = contentView.bounds
        contentView.addSubview(vc.view)
        vc.didMove(toParent: self)
        
    }
    
}


