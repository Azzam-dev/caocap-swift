//
//  GroupChatVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 11/02/1441 AH.
//  Copyright © 1441 Ficruty. All rights reserved.
//

import UIKit

class GroupChatVC: ChatVC {
    
    
    
    @IBAction func sendBTN(_ sender: Any) {
        if messageTF.text != "" {
            sendBTN.isEnabled = false
            DataService.instance.getUserData { (theUser) in
                if let sender = theUser  {
                    if let chatKey = self.openedChat?.key {
                        let messageData = ["senderUid": sender.uid,
                                           "imageURL": sender.imageURL!,
                                           "color" : sender.color,
                                           "username" : sender.username,
                                           "time": "10:44 am",
                                           "message": self.messageTF.text!
                                            ] as [String : Any]
                        
                        DataService.instance.sendChatMessage(forChatKey: chatKey, messageData: messageData, handler: { (messageSent) in
                            if messageSent {
                                self.sendBTN.isEnabled = true
                                self.messageTF.text = ""
                            }
                        })
                    }
                }
            }
        }
    }
    
    
    
    
}


