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
        Block(type: .blank, description: "a blank template", code: "", icon: UIImage(systemName: "doc")!)
    ]
}
