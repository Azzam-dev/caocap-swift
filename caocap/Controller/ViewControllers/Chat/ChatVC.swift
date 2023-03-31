//
//  ChatVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 01/04/2023.
//  Copyright © 2023 Ficruty. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
    
    @IBOutlet weak var messagesTableView: UITableView!
    var openedChat: Chat?
    var messagesArray = [Message]()
    
    @IBOutlet weak var chatTitle: UILabel!
    @IBOutlet weak var chatImage: DesignableImage!
    @IBOutlet weak var chatImageView: DesignableView!

    
    @IBOutlet weak var messageTF: UITextField!
    @IBOutlet weak var sendBTN: UIButton!
    
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
        chatTitle.text = chat.name
        chatImageView.borderColor = colorArray[chat.color]
        if let imageURL = URL(string: chat.imageURL ?? "") {
            chatImage.af.setImage(withURL: imageURL)
        }
    }
    
    
    @IBAction func didPressInfoButton(_ sender: Any) {
        //TODO: send the user to the chat Info page
    }


}


extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //TODO: please fix the numberOfRowsInSection and cellForRowAt functions
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
        return 120
    }
    
}
