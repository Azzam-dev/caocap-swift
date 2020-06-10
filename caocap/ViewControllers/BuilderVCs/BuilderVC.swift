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
    var navSelectedIndex: Int = 0
    
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
        let testLabVC = storyboard.instantiateViewController(withIdentifier: "testLab") as? TestLabVC
        testLabVC?.openedCaocap = openedCaocap
        viewControllers = [testLabVC!]
        let vc = viewControllers[0]
        addChild(vc)
        vc.view.frame = contentView.bounds
        contentView.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
}


