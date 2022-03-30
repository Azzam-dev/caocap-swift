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
        switch logicNode.type {
        case .event:
            symbol.textColor = .systemGreen
        case .condition:
            symbol.textColor = .systemYellow
        case .flow:
            symbol.textColor = .systemOrange
        case .action:
            symbol.textColor = .systemBlue
        case .value:
            symbol.textColor = .systemRed
        }
    }
}
