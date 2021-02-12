//
//  GroupChatVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 11/02/1441 AH.
//  Copyright © 1441 Ficruty. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

class GroupChatVC: UIViewController {
    
    @IBOutlet weak var messagesTableView: UITableView!
    var opendChat: Chat?
    var messagesArray = [Message]()
    let colorArray = [#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.6391159892, blue: 0, alpha: 1), #colorLiteral(red: 0.3846503198, green: 1, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1), #colorLiteral(red: 0.8861780167, green: 0, blue: 1, alpha: 1), #colorLiteral(red: 0.9175696969, green: 0.9176983237, blue: 0.9175290465, alpha: 1)]
    
    @IBOutlet weak var groupNameLBL: UILabel!
    @IBOutlet weak var groupIMG: DesignableImage!
    @IBOutlet weak var groupIMGview: DesignableView!
    @IBAction func groupPageBTN(_ sender: Any) {
        //send the user to the group profile page @_@
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getChatData()
        
        //keyboard issue:
        //This triggers a keyboardWillShow
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow),name: UIResponder.keyboardWillShowNotification,object: nil)
    }
    
    
    //this gets the chat messages and inputs them to the messages array and relouds the messages TableView
    func getChatData() {
        if let chatKey = opendChat?.key {
            DataService.instance.getChatMessages(forChatKey: chatKey) { (returnedMessagesArray) in
                self.messagesArray = returnedMessagesArray
                self.messagesTableView.reloadData()
            }
            groupNameLBL.text = opendChat?.name
            groupIMGview.borderColor = colorArray[opendChat?.color ?? 3]
            //this gets the caocap UIimage from the url
            if let imageURL = URL(string: opendChat?.imageURL ?? "" ) {
                ImageService.getImage(withURL: imageURL) { (returnedImage) in
                    self.groupIMG.image = returnedImage
                }
            }
        }
    }
    
    
    @IBOutlet weak var messageTF: UITextField!
    @IBOutlet weak var sendBTN: UIButton!
    @IBAction func sendBTN(_ sender: Any) {
        if messageTF.text != "" {
            sendBTN.isEnabled = false
            DataService.instance.getUserData { (theUser) in
                if let sender = theUser  {
                    if let chatKey = self.opendChat?.key {
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
    
    
    //keyboard issue:
    //this solves the keyboard distance from the TextField issue in the ChatVC
    //By checking the height of the keyboard and determining the distance between it and the text field
    //that is because the height of the iPhone X keyboard is different from previous versions
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            if keyboardHeight > 300 {
                IQKeyboardManager.shared.keyboardDistanceFromTextField = 26
            } else {
                IQKeyboardManager.shared.keyboardDistanceFromTextField = 60
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
        let currentUserUID = (Auth.auth().currentUser?.uid)!
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
