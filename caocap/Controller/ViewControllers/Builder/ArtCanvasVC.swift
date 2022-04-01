//
//  ArtCanvasVC.swift
//  caocap
//
//  Created by CAOCAP inc on 29/08/1443 AH.
//  Copyright © 1443 Ficruty. All rights reserved.
//

import UIKit

class ArtCanvasVC: UIViewController {
    
    
    var caocapBlocks = [Block]()
    var blocksArray = BlockService.instance.blocks
    var editingBlock: Block?

    var workStationVC: WorkStationVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
