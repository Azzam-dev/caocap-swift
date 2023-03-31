//
//  CaocapRoomVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 10/02/1441 AH.
//  Copyright © 1441 Ficruty. All rights reserved.
//

import UIKit

class CaocapRoomVC: UIViewController {
    
    @IBOutlet weak var messagesTableView: UITableView!
    var openedCaocap: Caocap?
    var messagesArray = [Message]()
    
    @IBOutlet weak var roomNameLBL: UILabel!
    @IBOutlet weak var roomIMG: DesignableImage!
    @IBOutlet weak var roomIMGview: DesignableView!
    
    @IBAction func caocapBTN(_ sender: Any) {
        //TODO: send the user to the caocap page
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getRoomData()
    }
    
    
    //this gets the room messages and inputs them to the messages array and reloads the messages TableView
    func getRoomData() {
        guard let caocap = openedCaocap else { return }
        DataService.instance.getCaocapRoomMessages(forCaocapKey: caocap.key) { (returnedMessagesArray) in
            self.messagesArray = returnedMessagesArray
            self.messagesTableView.reloadData()
        }
        roomNameLBL.text = caocap.name
        roomIMGview.borderColor = colorArray[caocap.color]
        if let imageURL = URL(string: caocap.imageURL ?? "" ) {
            roomIMG.af.setImage(withURL: imageURL)
        }
    }
    
    
    @IBOutlet weak var messageTF: UITextField!
    @IBOutlet weak var sendBTN: UIButton!
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

extension CaocapRoomVC: UITableViewDelegate, UITableViewDataSource {
    
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

