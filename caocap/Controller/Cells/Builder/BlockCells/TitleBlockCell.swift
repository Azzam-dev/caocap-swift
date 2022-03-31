//
//  TitleBlockCell.swift
//  caocap
//
//  Created by CAOCAP inc on 27/08/1443 AH.
//  Copyright © 1443 Ficruty. All rights reserved.
//

import UIKit

class TitleBlockCell: BlankCell  {

    @IBOutlet weak var title: UILabel!
    override func configure(block: Block) {
        for blockStyle in block.styles {
            switch blockStyle.type {
            case .text:
                title.text = blockStyle.value as? String
            case .color:
                backgroundColor = UIColor(hex: blockStyle.value as? String ?? "#000000ff")
            default:
                continue
            }
        }
    }

}
