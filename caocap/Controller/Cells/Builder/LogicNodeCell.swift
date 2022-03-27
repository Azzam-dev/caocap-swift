//
//  LogicNodeCell.swift
//  caocap
//
//  Created by CAOCAP inc on 23/08/1443 AH.
//  Copyright © 1443 Ficruty. All rights reserved.
//

import UIKit

class LogicNodeCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nodeView: DesignableView!
    func configure(node: LogicNode) {
        titleLabel.text = node.title
        descriptionLabel.text = node.description
        switch node.type {
        case .event:
            icon.image = UIImage(systemName: "bookmark.fill")
            nodeView.backgroundColor = .systemGreen
        case .condition:
            icon.image = UIImage(systemName: "diamond.righthalf.filled")
            nodeView.backgroundColor = .systemYellow
        case .flow:
            icon.image = UIImage(systemName: "scribble.variable")
            nodeView.backgroundColor = .systemOrange
        case .action:
            icon.image = UIImage(systemName: "sparkle")
            nodeView.backgroundColor = .systemBlue
        case .value:
            icon.image = UIImage(systemName: "hexagon.fill")
            nodeView.backgroundColor = .systemRed
        }
    }

}
