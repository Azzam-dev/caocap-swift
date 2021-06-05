//
//  EditTitleStylesCell.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 05/06/2021.
//  Copyright © 2021 Ficruty. All rights reserved.
//

import UIKit

class EditTitleStylesCell: UITableViewCell {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textAlignmentSC: UISegmentedControl!
    
    func configure(title: String) {
        titleTextField.text = title
        textAlignmentSC.subviews.flatMap{$0.subviews}.forEach { subview in
            if let imageView = subview as? UIImageView {
                imageView.contentMode = .scaleAspectFit
            }
        }
    }

    @IBAction func didEditeTitle(_ sender: UITextField) {
        
    }
    
}
