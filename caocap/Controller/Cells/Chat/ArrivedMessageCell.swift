//
//  ArrivedMessageCell.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 10/02/1441 AH.
//  Copyright © 1441 Ficruty. All rights reserved.
//

import UIKit

class ArrivedMessageCell: UITableViewCell {
    @IBOutlet weak var profileIMG: DesignableImage!
    @IBOutlet weak var profileIMGview: DesignableView!
    @IBOutlet weak var usernameLBL: UILabel!
    @IBOutlet weak var timeLBL: UILabel!
    @IBOutlet weak var messageLBL: UILabel!
    
    
    func configureCell(message: Message) {
        
        if let imageURL = URL(string: message.imageURL ?? "" ) {
            profileIMG.af.setImage(withURL: imageURL)
        }
        
        if case 0...5 = message.color {
            profileIMGview.borderColor = colorArray[message.color]
        } else {
            profileIMGview.borderColor = colorArray[3]
        }
        usernameLBL.text = message.username
        usernameLBL.textColor = colorArray[message.color]
        timeLBL.text = message.time
        messageLBL.text = message.message
        
    }
    
    
    
}
