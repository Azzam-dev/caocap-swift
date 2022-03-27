//
//  AddLogicCell.swift
//  caocap
//
//  Created by CAOCAP inc on 23/08/1443 AH.
//  Copyright © 1443 Ficruty. All rights reserved.
//

import UIKit

protocol AddLogicNodeDelegate: class {
    func didPressAddLogicNode()
    func didPressBackButton()
}

class AddLogicCell: UITableViewCell {
    
    
    @IBOutlet var buttons: [DesignableButton]!
    weak var delegate: AddLogicNodeDelegate?
    
    func configure(nodeTreeDepth: Int) {
        switch nodeTreeDepth {
        case 1:
            buttons.forEach { $0.isHidden = false }
            buttons.forEach { $0.backgroundColor = .systemYellow }
        case 2:
            buttons.forEach { $0.isHidden = false }
            buttons.forEach { $0.backgroundColor = .systemOrange }
        case 3:
            buttons.forEach { $0.isHidden = false }
            buttons.forEach { $0.backgroundColor = .systemBlue }
        case 4:
            buttons[0].isHidden = false
            buttons[1].isHidden = true
            buttons.forEach { $0.backgroundColor = .systemRed }
        default:
            buttons[0].isHidden = true
            buttons[1].isHidden = false
            buttons.forEach { $0.backgroundColor = .systemGreen }
        }
    }
    
    @IBAction func addLogicNodeBTN(_ sender: UIButton) {
        self.delegate?.didPressAddLogicNode()
    }
    
    @IBAction func didPressbackButton(_ sender: UIButton) {
        self.delegate?.didPressBackButton()
    }

}
