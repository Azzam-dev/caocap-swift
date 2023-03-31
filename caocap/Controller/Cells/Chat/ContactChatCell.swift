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
