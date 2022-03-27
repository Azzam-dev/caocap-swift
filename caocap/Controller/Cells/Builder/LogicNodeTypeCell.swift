//
//  LogicNodeTypeCell.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 20/08/1443 AH.
//  Copyright © 1443 Ficruty. All rights reserved.
//

import UIKit

class LogicNodeTypeCell: UICollectionViewCell {
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    func configure(logicNode: LogicNode) {
        symbol.text = logicNode.type.rawValue.first?.uppercased()
        titleLabel.text = logicNode.type.rawValue
        
    }
}
