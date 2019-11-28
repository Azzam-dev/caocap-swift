//
//  chatGroupCell.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 27/02/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit

class chatGroupCell: UITableViewCell {
    
    @IBOutlet weak var groupIMG: DesignableImage!
    @IBOutlet weak var groupIMGview: DesignableView!
    @IBOutlet weak var groupNameLBL: UILabel!
    @IBOutlet weak var lastSenderLBL: UILabel!
    @IBOutlet weak var lastMessageLBL: UILabel!
    @IBOutlet weak var unreadMessagesLBL: UILabel!
    @IBOutlet weak var timeLBL: UILabel!
    
    let colorArray = [#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.6391159892, blue: 0, alpha: 1), #colorLiteral(red: 0.3846503198, green: 1, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1), #colorLiteral(red: 0.8861780167, green: 0, blue: 1, alpha: 1), #colorLiteral(red: 0.9175696969, green: 0.9176983237, blue: 0.9175290465, alpha: 1)]
    
    func configureCell(chatIMG image: UIImage, chatColor color: Int, chatName name: String, lastSender username: String, lastMessage message: String, numberOfMessages number: Int, lastMessageTime time: String) {
        
        self.groupIMG.image = image
        self.groupIMGview.borderColor = colorArray[color]
        self.groupNameLBL.text = name
        self.lastSenderLBL.text = username + " :"
        self.lastMessageLBL.text = message
        self.unreadMessagesLBL.text = String(number)
        self.timeLBL.text = time
        
    }
    
}

