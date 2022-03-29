//
//  BlockService.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 27/06/2021.
//  Copyright © 2021 Ficruty. All rights reserved.
//

import UIKit

class BlockService {
    static let instance = BlockService()
    
    let blocks = [
        Block(type: .blank,
              description: "a blank template",
              styles: ["backgroundColor" : BlockStyle(title: "background color", description: "the back ground color for the blank block", type: .color, value: "#ffffffff")],
              icon: UIImage(systemName: "doc")!)
    ]
}
