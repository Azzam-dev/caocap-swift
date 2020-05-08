//
//  CosmosBaseVC.swift
//  caocap
//
//  Created by omar alzhrani on 15/09/1441 AH.
//  Copyright © 1441 Ficruty. All rights reserved.
//

import UIKit
import SwiftUI

class CosmosBaseVC: UIViewController {

    let chartView = UIHostingController(rootView: ChartUI())
    
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(chartView)
        chartView.view.frame = view.frame
        contentView.addSubview(chartView.view)
        chartView.didMove(toParent: self)
        self.navigationController?.isNavigationBarHidden = true
    }
    

}
