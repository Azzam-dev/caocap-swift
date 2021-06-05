//
//  EditDescriptionStylesCell.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 05/06/2021.
//  Copyright © 2021 Ficruty. All rights reserved.
//

import UIKit

class EditDescriptionStylesCell: UITableViewCell {
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var textAlignmentSC: UISegmentedControl!
    
    func configure(description: String) {
        descriptionTextView.text = description
        textAlignmentSC.subviews.flatMap{$0.subviews}.forEach { subview in
            if let imageView = subview as? UIImageView {
                imageView.contentMode = .scaleAspectFit
            }
        }
    }
    
}
