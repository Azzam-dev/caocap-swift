//
//  ContactChatVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 10/04/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit

class ContactChatVC: UIViewController {
    
    @IBOutlet weak var messagesTableView: UITableView!
    var openedChat: Chat?
    var messagesArray = [Message]()
    let colorArray = [#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.6391159892, blue: 0, alpha: 1), #colorLiteral(red: 0.3846503198, green: 1, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1), #colorLiteral(red: 0.8861780167, green: 0, blue: 1, alpha: 1), #colorLiteral(red: 0.9175696969, green: 0.9176983237, blue: 0.9175290465, alpha: 1)]
    
    @IBOutlet weak var contactNameLBL: UILabel!
    @IBOutlet weak var contactIMG: DesignableImage!
    @IBOutlet weak var contactIMGview: DesignableView!
    
    @IBAction func contactPageBTN(_ sender: Any) {
        //TODO: send the user to the contact profile page
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
        contactNameLBL.text = chat.name
        contactIMGview.borderColor = colorArray[chat.color]
        if let imageURL = URL(string: chat.imageURL ?? "" ) {
            contactIMG.af.setImage(withURL: imageURL)
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


extension ContactChatVC: UITableViewDelegate, UITableViewDataSource {
    
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
