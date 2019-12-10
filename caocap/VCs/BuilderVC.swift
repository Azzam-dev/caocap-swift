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
    
    let tokenizer = Tokenizer(self.textEditor.text)
    let token = tokenizer.tokenize()
    let style = [
        "keyword": "",
        "punctuation": "",
        "operator": "",
        "comment" : "",
        "identifier": "",
        "literal": "",
        "error" : "",
        "whitespace": "",
        "EOF": ""
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: color the code | I think you will need to run the html file in a webkit
        while token.category != "EOF" {
            token = tokenizer.tokenize()
        }
        
        
    }
    
    
}
