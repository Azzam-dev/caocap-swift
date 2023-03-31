//
//  CaocapGroupCell.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 27/02/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit

class CaocapGroupCell: UITableViewCell {
    
    @IBOutlet weak var caocapIMG: DesignableImage!
    @IBOutlet weak var caocapIMGview: DesignableView!
    @IBOutlet weak var caocapnameLBL: UILabel!
    @IBOutlet weak var lastSenderLBL: UILabel!
    @IBOutlet weak var lastMessageLBL: UILabel!
    @IBOutlet weak var unreadMessagesLBL: UILabel!
    @IBOutlet weak var timeLBL: UILabel!
    
    
    func configureCell(imageURL: String, color: Int, chatName name: String, lastSender username: String, lastMessage message: String, numberOfMessages number: Int, lastMessageTime time: String) {
        
        if let imageURL = URL(string: imageURL) {
            caocapIMG.af.setImage(withURL: imageURL)
        }
        
        if case 0...5 = color {
            caocapIMGview.borderColor = colorArray[color]
        } else {
            caocapIMGview.borderColor = colorArray[3]
        }
        
        caocapnameLBL.text = name
        lastSenderLBL.text = username + " :"
        lastMessageLBL.text = message
        unreadMessagesLBL.text = String(number)
        timeLBL.text = time
        
    }
    
}
