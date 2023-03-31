//
//  GroupChatVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 11/02/1441 AH.
//  Copyright © 1441 Ficruty. All rights reserved.
//

import UIKit

class GroupChatVC: UIViewController {
    
    @IBOutlet weak var messagesTableView: UITableView!
    var openedChat: Chat?
    var messagesArray = [Message]()
    
    @IBOutlet weak var groupNameLBL: UILabel!
    @IBOutlet weak var groupIMG: DesignableImage!
    @IBOutlet weak var groupIMGview: DesignableView!
    
    @IBAction func groupPageBTN(_ sender: Any) {
        //TODO: send the user to the group profile page
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getChatData()
        
    }
    
    
    //this gets the chat messages and inputs them to the messages array and reloads the messages TableView
    func getChatData() {
        guard let chat = openedChat else { return }
        DataService.instance.getChatMessages(forChatKey: chat.key) { (returnedMessagesArray) in
            self.messagesArray = returnedMessagesArray
            self.messagesTableView.reloadData()
        }
        groupNameLBL.text = chat.name
        groupIMGview.borderColor = colorArray[chat.color]
        if let imageURL = URL(string: chat.imageURL ?? "") {
            groupIMG.af.setImage(withURL: imageURL)
        }
    }
    
    
    @IBOutlet weak var messageTF: UITextField!
    @IBOutlet weak var sendBTN: UIButton!
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


extension GroupChatVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messagesArray[indexPath.row]
        let currentUserUID = AuthService.instance.currentUser()?.uid
        if message.senderUid == currentUserUID {
            guard let cell = messagesTableView.dequeueReusableCell(withIdentifier: "sentMessageCell", for: indexPath) as? SentMessageCell else { return UITableViewCell() }
            
            cell.configureCell(message: message)
            
            return cell
        } else {
            guard let cell = messagesTableView.dequeueReusableCell(withIdentifier: "arrivedMessageCell", for: indexPath) as? ArrivedMessageCell else { return UITableViewCell() }
            
            cell.configureCell(message: message)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}
