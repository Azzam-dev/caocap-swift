//
//  CodeCell.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 12/02/2021.
//  Copyright © 2021 Ficruty. All rights reserved.
//

import UIKit

class CodeCell: UICollectionViewCell {
    
    @IBOutlet weak var textView: UITextView!
    func configure(code: String) {
        textView.text = code
    }
}
