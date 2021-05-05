//
//  CodeCell.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 12/02/2021.
//  Copyright © 2021 Ficruty. All rights reserved.
//

import UIKit
enum CodeType: String {
    case js
    case html
    case css
}

class CodeCell: UICollectionViewCell, UITextViewDelegate {
    
    var key: String?
    var type: CodeType?
    @IBOutlet weak var textView: UITextView!
    func configure(code: String, type: CodeType, key: String) {
        textView.text = code
        self.key = key
        self.type = type
    }

    
    func textViewDidChange(_ textView: UITextView) {
        guard let key = key else { return }
        guard let type = type?.rawValue else { return }
        guard let text = textView.text else { return }
        DataService.instance.REF_CAOCAPS.child(key).child("code").updateChildValues([type: text])
    }
}
