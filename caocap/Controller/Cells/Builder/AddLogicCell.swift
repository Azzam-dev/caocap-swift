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
}

class AddLogicCell: UITableViewCell {
    
    weak var delegate: AddLogicNodeDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    @IBAction func addLogicNodeBTN(_ sender: UIButton) {
        self.delegate?.didPressAddLogicNode()
    }

}
