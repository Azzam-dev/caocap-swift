//
//  CaocapRoomVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 10/02/1441 AH.
//  Copyright © 1441 Ficruty. All rights reserved.
//

import UIKit

class CaocapRoomVC: ChatVC {
    
    
    var openedCaocap: Caocap? //TODO: determine if we should use this or something else 
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getRoomData()
    }
    
    
    //this gets the room messages and inputs them to the messages array and reloads the messages TableView
    func getRoomData() { //TODO: we should start using the chat object not the caocap
        guard let caocap = openedCaocap else { return }
        DataService.instance.getCaocapRoomMessages(forCaocapKey: caocap.key) { (returnedMessagesArray) in
            self.messagesArray = returnedMessagesArray
            self.messagesTableView.reloadData()
        }
        chatTitle.text = caocap.name
        chatImageView.borderColor = colorArray[caocap.color]
        if let imageURL = URL(string: caocap.imageURL ?? "" ) {
            chatImage.af.setImage(withURL: imageURL)
        }
    }
    
    
    
    @IBAction func sendBTN(_ sender: Any) {
        if messageTF.text != "" {
            sendBTN.isEnabled = false
            DataService.instance.getUserData { (theUser) in
                if let sender = theUser  {
                    if let caocapKey = self.openedCaocap?.key {
                        let messageData = ["senderUid": sender.uid,
                                           "imageURL": sender.imageURL!,
                                           "color" : sender.color,
                                           "username" : sender.username,
                                           "time": "10:44 am",
                                           "message": self.messageTF.text!
                        ] as [String : Any]
                        
                        DataService.instance.sendRoomMessage(forCaocapKey: caocapKey, messageData: messageData, handler: { (messageSent) in
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



