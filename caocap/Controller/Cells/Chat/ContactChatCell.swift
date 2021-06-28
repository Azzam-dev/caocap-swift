//
//  ContactChatCell.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 27/02/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit

class ContactChatCell: UITableViewCell {

    @IBOutlet weak var userIMG: DesignableImage!
    @IBOutlet weak var userIMGview: DesignableView!
    @IBOutlet weak var usernameLBL: UILabel!
    @IBOutlet weak var lastMessageLBL: UILabel!
    @IBOutlet weak var unreadMessagesLBL: UILabel!
    @IBOutlet weak var timeLBL: UILabel!
    
    let colorArray = [#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.6391159892, blue: 0, alpha: 1), #colorLiteral(red: 0.3846503198, green: 1, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1), #colorLiteral(red: 0.8861780167, green: 0, blue: 1, alpha: 1), #colorLiteral(red: 0.9175696969, green: 0.9176983237, blue: 0.9175290465, alpha: 1)]
    
    func configureCell(imageURL: String, color: Int, chatName name: String, lastMessage message: String, numberOfMessages number: Int, lastMessageTime time: String) {
        
        if let imageURL = URL(string: imageURL) {
            userIMG.af.setImage(withURL: imageURL)
        }
        
        if case 0...5 = color {
            userIMGview.borderColor = colorArray[color]
        } else {
            userIMGview.borderColor = colorArray[3]
        }
        usernameLBL.text = name
        lastMessageLBL.text = message
        unreadMessagesLBL.text = String(number)
        timeLBL.text = time
        
    }

}
