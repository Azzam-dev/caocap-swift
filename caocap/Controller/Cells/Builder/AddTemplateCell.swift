//
//  AddTemplateCell.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 08/05/2021.
//  Copyright © 2021 Ficruty. All rights reserved.
//

import UIKit

protocol AddTemplateDelegate: class {
    func didPressAddTemplate()
}

class AddTemplateCell: UITableViewCell {

    weak var delegate: AddTemplateDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    @IBAction func addTemplateBTN(_ sender: UIButton) {
        self.delegate?.didPressAddTemplate()
    }

}
