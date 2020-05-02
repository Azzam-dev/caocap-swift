//
//  SurfaceBlock.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 02/05/2020.
//  Copyright © 2020 Ficruty. All rights reserved.
//

import UIKit

class SurfaceBlock: UIViewController {

    @IBOutlet weak var identifier: UILabel!
    @IBOutlet weak var body: DesignableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        body.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
    }

}
