//
//  SentMessageCell.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 10/02/1441 AH.
//  Copyright © 1441 Ficruty. All rights reserved.
//

import UIKit

class SentMessageCell: UITableViewCell {
    
    @IBOutlet weak var profileIMG: DesignableImage!
    @IBOutlet weak var profileIMGview: DesignableView!
    @IBOutlet weak var usernameLBL: UILabel!
    @IBOutlet weak var timeLBL: UILabel!
    @IBOutlet weak var messageLBL: UILabel!
    
    let colorArray = [#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.6391159892, blue: 0, alpha: 1), #colorLiteral(red: 0.3846503198, green: 1, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1), #colorLiteral(red: 0.8861780167, green: 0, blue: 1, alpha: 1), #colorLiteral(red: 0.9175696969, green: 0.9176983237, blue: 0.9175290465, alpha: 1)]
    
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
        //This is not important because it is from the sender himself
        //self.usernameLBL.textColor = colorArray[message.color]
        timeLBL.text = message.time
        messageLBL.text = message.message
        
    }
    
    
    
}
