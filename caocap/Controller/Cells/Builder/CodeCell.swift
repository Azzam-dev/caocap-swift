//
//  CodeCell.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 12/02/2021.
//  Copyright © 2021 Ficruty. All rights reserved.
//

import UIKit

class CodeCell: UICollectionViewCell, UITextViewDelegate {
    
    var key: String?
    var fileName: String?
    @IBOutlet weak var textView: UITextView!
    func configure(fileName: String, code: String, key: String) {
        textView.text = code
        self.key = key
        self.fileName = fileName
    }

    
    func textViewDidChange(_ textView: UITextView) {
        guard let key = key else { return }
        guard let fileName = fileName else { return }
        guard let luaCode = textView.text else { return }
        LuaService.instance.runLua(code: luaCode)
        //TODO: - save the code changes to firebase
        //DataService.instance.REF_CAOCAPS.child(key).child("code").updateChildValues([fileName: luaCode])
    }
}
