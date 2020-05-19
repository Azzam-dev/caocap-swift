//
//  BuilderVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 09/12/2019.
//  Copyright © 2019 Ficruty. All rights reserved.
//

import UIKit

class BuilderVC: UIViewController {
    
    var testLabNAV: UINavigationController!
    
    @IBOutlet weak var contentView: UIView!
    
    var navigationControllers: [UINavigationController]!
    var navSelectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubNavigationControllers()
    }
    
    @IBAction func exitBuilder(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
     func setupSubNavigationControllers() {
        
           let storyboard = UIStoryboard(name: "Builder", bundle: nil)
        testLabNAV = storyboard.instantiateViewController(withIdentifier: "testLapNAV") as? UINavigationController
           navigationControllers = [testLabNAV]
        let vc = navigationControllers[0]
            addChild(vc)
            vc.view.frame = contentView.bounds
            contentView.addSubview(vc.view)
            vc.didMove(toParent: self)
       }
    
}


