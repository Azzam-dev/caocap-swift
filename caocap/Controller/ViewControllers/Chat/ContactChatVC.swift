//
//  ContactChatVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 10/04/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit

class ContactChatVC: ChatVC {
    
    
    
    @IBAction func sendBTN(_ sender: Any) {
        if messageTF.text != "" {
            sendBTN.isEnabled = false
            DataService.instance.getUserData { (theUser) in
                if let sender = theUser  {
                    if let chatKey = self.openedChat?.key {
                        let messageData = ["senderUid": sender.uid,
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
