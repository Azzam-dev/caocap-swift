//
//  BuilderVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 09/12/2019.
//  Copyright © 2019 Ficruty. All rights reserved.
//

import UIKit

class BuilderVC: UIViewController {

    @IBOutlet weak var textEditor: UITextView!
    
    var source_code = ""
    var tokenizer: Tokenizer? = nil
    
    let style = [
        "keyword": UIColor.blue,
        "punctuation": UIColor.green,
        "operator": UIColor.blue,
        "comment" : UIColor.purple,
        "identifier": UIColor.white,
        "literal": UIColor.gray,
        "error" : UIColor.red,
        "whitespace": UIColor.white,
        "EOF": UIColor.black
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
    @IBAction func compileBTN(_ sender: Any) {
        
        source_code = textEditor.text
        tokenizer = Tokenizer(source_code: self.source_code, ignore_whitespace: true)
        
        let textEditorStorage = textEditor.textStorage
        let storageString = textEditorStorage.string as NSString
        var tokenRanges: NSRange
        
        
        var token = tokenizer!.tokenize()
        while token.category != "EOF" {
            token = tokenizer!.tokenize()
            
            tokenRanges = NSMakeRange(token.position, token.value.count)
            textEditorStorage.addAttribute(.foregroundColor, value: UIColor.red, range: tokenRanges)
            
        }
        
    }
    
    /*
     
     **/
    
    
}
