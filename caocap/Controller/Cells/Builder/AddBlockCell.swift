//
//  AddBlockCell.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 08/05/2021.
//  Copyright © 2021 Ficruty. All rights reserved.
//

import UIKit

protocol AddBlockDelegate: AnyObject {
    func didPressAddBlock()
}

class AddBlockCell: UITableViewCell {

    weak var delegate: AddBlockDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    @IBAction func addBlockBTN(_ sender: UIButton) {
        self.delegate?.didPressAddBlock()
    }

}
