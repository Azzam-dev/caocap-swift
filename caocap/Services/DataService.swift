//
//  DataService.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 18/01/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()
let STORAGE_BASE = Storage.storage().reference()

class DataService {
    static let instance = DataService()
    
    // DB references
    private var _REF_DB_BASE = DB_BASE
    private var _REF_APPDATA = DB_BASE.child("appData")
    private var _REF_MINIMUM_VERSION = DB_BASE.child("appData").child("minimumVersion")
    private var _REF_REPAIRING = DB_BASE.child("appData").child("repairing")
    private var _REF_RELEASED = DB_BASE.child("appData").child("released")
    
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_CAOCAPS = DB_BASE.child("caocap")
    
    private var _REF_CHATS = DB_BASE.child("chats")
    //private var _REF_ROOMS = DB_BASE.child("rooms")
    
    
    // Storage references
    private var _REF_STORAGE_BASE = STORAGE_BASE
    
    private var _REF_CHAT_STORAGE = STORAGE_BASE.child("chats")
    
    private var _REF_PROFILE_IMAGES = STORAGE_BASE.child("profile-images")
    private var _REF_CAOCAP_IMAGES = STORAGE_BASE.child("caocap-images")
    private var _REF_GROUP_IMAGES = STORAGE_BASE.child("group-images")
    
    
    //DatabaseReference
    var REF_DB_BASE: DatabaseReference { return _REF_DB_BASE }
    var REF_APPDATA : DatabaseReference { return _REF_APPDATA }
    var REF_MINIMUM_VERSION : DatabaseReference { return _REF_MINIMUM_VERSION }
    var REF_REPAIRING : DatabaseReference { return _REF_REPAIRING }
    var REF_RELEASED : DatabaseReference { return _REF_RELEASED }
    
    var REF_USERS: DatabaseReference { return _REF_USERS }
    var REF_CAOCAPS: DatabaseReference { return _REF_CAOCAPS }
    
    var REF_CHATS: DatabaseReference { return _REF_CHATS }
    //var REF_ROOMS: DatabaseReference { return _REF_ROOMS }
    
    //StorageReference
    var REF_STORAGE_BASE: StorageReference { return _REF_STORAGE_BASE }
    
    var REF_CHAT_STORAGE: StorageReference { return _REF_CHAT_STORAGE }
    
    var REF_PROFILE_IMAGES: StorageReference { return _REF_PROFILE_IMAGES }
    var REF_CAOCAP_IMAGES: StorageReference { return _REF_CAOCAP_IMAGES }
    var REF_GROUP_IMAGES: StorageReference { return _REF_GROUP_IMAGES }
    
    
    func updateUserData(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func createNewContact(withUserIDs ids: [String], andChatType type: String ,  handler: @escaping (_ newContactCreated: Bool) -> ()) {
        REF_CHATS.childByAutoId().updateChildValues(["members": ids, "type": type])
        handler(true)
    }
    
    func createChat(chatData: Dictionary<String, Any> , handler: @escaping (_ chatCreated: Bool) -> ()) {
        REF_CHATS.childByAutoId().updateChildValues(chatData)
        handler(true)
    }
    
    func createCaocap(caocapData: Dictionary<String, Any> , handler: @escaping (_ caocapCreated: Bool) -> ()) {
        REF_CAOCAPS.childByAutoId().updateChildValues(caocapData)
        handler(true)
    }
    
    func launchCaocap(caocapKey: String,code: [String: String]) {
        REF_CAOCAPS.child(caocapKey).child("code").updateChildValues(code)
    }
    
    // this function adds and removes caocaps from the user's orbit
    func addAndReomveFromOrbit(caocapKey: String , remove: Bool) {
        if let userUID = Auth.auth().currentUser?.uid {
            if remove {
                REF_USERS.child(userUID).child("orbiting").child(caocapKey).removeValue()
            } else {
                REF_USERS.child(userUID).child("orbiting").child(caocapKey).updateChildValues(["key": caocapKey])
            }
        }
    }
    
    
    //This sends a new message for the caocap room, You must provide the caocap key and the message data
    func sendRoomMessage(forCaocapKey key: String, messageData: Dictionary<String, Any> , handler: @escaping (_ sendtMessage: Bool) -> ()) {
        REF_CAOCAPS.child(key).child("room").childByAutoId().updateChildValues(messageData)
        handler(true)
    }
    
    //This sends a new message for the caocap room, You must provide the caocap key and the message data
    func sendChatMessage(forChatKey key: String, messageData: Dictionary<String, Any> , handler: @escaping (_ sendtMessage: Bool) -> ()) {
        REF_CHATS.child(key).child("messages").childByAutoId().updateChildValues(messageData)
        handler(true)
    }
    
    func getCurrentUserChats(handler: @escaping (_ chatsArray: [Chat]) -> ()) {
        var chatsArray = [Chat]()
        REF_CHATS.observe(.value) { (chatSnapshot) in
            guard let chatSnapshot = chatSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for chat in chatSnapshot {
                
                let currentUserUID = (Auth.auth().currentUser?.uid)!
                let membersArray = chat.childSnapshot(forPath: "members").value as! [String]
                if membersArray.contains(currentUserUID) {
                    let dictionary = chat.value
                    let chat = Chat(key: chat.key, dictionary: dictionary as! [String : Any] )
                    chatsArray.append(chat)
                }
            }
            handler(chatsArray)
        }
    }
    
    func getCurrentUserChatsQuery(forSearchQuery query: String, handler: @escaping (_ chatsArray: [Chat]) -> ()) {
        var chatsArray = [Chat]()
        REF_CHATS.observe(.value) { (chatSnapshot) in
            guard let chatSnapshot = chatSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for chat in chatSnapshot {
                
                let currentUserUID = (Auth.auth().currentUser?.uid)!
                switch chat.childSnapshot(forPath: "type").value as! String {
                case "contact":
                    
                    let membersArray = chat.childSnapshot(forPath: "members").value as! [String]
                    let contactUID = membersArray.filter({ $0 != currentUserUID })
                    self.REF_USERS.observe(.value) { (userSnapshot) in
                        guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
                        for user in userSnapshot {
                            
                            let username = user.childSnapshot(forPath: "username").value as! String
                            if username.contains(query) && user.key != currentUserUID && membersArray.contains(currentUserUID) {
                                let dictionary = chat.value
                                let chat = Chat(key: chat.key, dictionary: dictionary as! [String : Any] )
                                chatsArray.append(chat)
                            }
                        }
                    }
                case "group":
                    
                    let membersArray = chat.childSnapshot(forPath: "members").value as! [String]
                    let chatname = chat.childSnapshot(forPath: "name").value as! String
                    if membersArray.contains(currentUserUID) && chatname.contains(query) {
                        let dictionary = chat.value
                        let chat = Chat(key: chat.key, dictionary: dictionary as! [String : Any] )
                        chatsArray.append(chat)
                    }
                default:
                    
                    let membersArray = chat.childSnapshot(forPath: "members").value as! [String]
                    let chatname = chat.childSnapshot(forPath: "name").value as! String
                    if membersArray.contains(currentUserUID) && chatname.contains(query) {
                        let dictionary = chat.value
                        let chat = Chat(key: chat.key, dictionary: dictionary as! [String : Any] )
                        chatsArray.append(chat)
                    }
                }
            }
            handler(chatsArray)
        }
    }
    
//TODO: Refacter this function
    func getCurrentUserCaocaps(handler: @escaping (_ caocapsArray: [Caocap]) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            var caocapsArray = [Caocap]()
            self.REF_CAOCAPS.observe(.value) { (caocapsSnapshot) in
                caocapsArray.removeAll()
                guard let caocapsSnapshot = caocapsSnapshot.children.allObjects as? [DataSnapshot] else { return }
                for caocap in caocapsSnapshot {
                    let currentUserUID = (Auth.auth().currentUser?.uid)!
                    let ownersArray = caocap.childSnapshot(forPath: "owners").value as? [String] ?? [""]
                    if ownersArray.contains(currentUserUID) {
                        let dictionary = caocap.value
                        let caocap = Caocap(key: caocap.key, dictionary: dictionary as! [String : Any] )
                        caocapsArray.append(caocap)
                    }
                }
                DispatchQueue.main.async {
                    handler(caocapsArray)
                }
            }
        }
    }
    
    func getCurrentUserCaocapsQuery(forSearchQuery query: String, handler: @escaping (_ caocapsArray: [Caocap]) -> ()) {
        
        // This goes over all the caocaps and gets the query
        var caocapsArray = [Caocap]()
        REF_CAOCAPS.observe(.value) { (caocapsSnapshot) in
            guard let caocapsSnapshot = caocapsSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for caocap in caocapsSnapshot {
                let caocapname = caocap.childSnapshot(forPath: "name").value as! String
                let currentUserUID = (Auth.auth().currentUser?.uid)!
                let ownersArray = caocap.childSnapshot(forPath: "owners").value as? [String] ?? [""]
                if caocapname.contains(query) && ownersArray.contains(currentUserUID) {
                    let dictionary = caocap.value
                    let caocap = Caocap(key: caocap.key, dictionary: dictionary as! [String : Any] )
                    caocapsArray.append(caocap)
                }
            }
            handler(caocapsArray)
        }
    }
    
    func getAllCaocaps(handler: @escaping (_ caocapsArray: [Caocap]) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            var caocapsArray = [Caocap]()
            self.REF_CAOCAPS.observeSingleEvent(of: .value) { (caocapsSnapshot) in
                guard let caocapsSnapshot = caocapsSnapshot.children.allObjects as? [DataSnapshot] else { return }
                for caocap in caocapsSnapshot {
                    let dictionary = caocap.value
                    let caocap = Caocap(key: caocap.key, dictionary: dictionary as! [String : Any] )
                    caocapsArray.append(caocap)
                }
                DispatchQueue.main.async {
                    handler(caocapsArray)
                }
            }
        }
    }
    
    func getCaocapsQuery(forSearchQuery query: String, handler: @escaping (_ caocapsArray: [Caocap]) -> ()) {
        // This goes over all the caocaps and gets the query
        var caocapsArray = [Caocap]()
        REF_CAOCAPS.observe(.value) { (caocapsSnapshot) in
            guard let caocapsSnapshot = caocapsSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for caocap in caocapsSnapshot {
                let caocapname = caocap.childSnapshot(forPath: "name").value as! String
                if caocapname.contains(query) {
                    let dictionary = caocap.value
                    let caocap = Caocap(key: caocap.key, dictionary: dictionary as! [String : Any] )
                    caocapsArray.append(caocap)
                }
            }
            handler(caocapsArray)
        }
    }
    
    //this gets all the caocap room messages, You must provide the caocap key and you will get the messages array
    func getCaocapRoomMessages(forCaocapKey key: String, handler: @escaping (_ messagesArray: [Message]) -> ()) {
        var messagesArray = [Message]()
        REF_CAOCAPS.child(key).child("room").observe(.value) { (messagesSnapshot) in
            guard let messagesSnapshot = messagesSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for theMessage in messagesSnapshot {
                
                let messageDict = theMessage.value
                let message = Message(key: theMessage.key, dictionary: messageDict as! [String : Any])
                messagesArray.append(message)
            }
            handler(messagesArray)
        }
    }
    
    //this gets all the chat messages, You must provide the chat key and you will get the messages array
    func getChatMessages(forChatKey key: String, handler: @escaping (_ messagesArray: [Message]) -> ()) {
        var messagesArray = [Message]()
        REF_CHATS.child(key).child("messages").observe(.value) { (messagesSnapshot) in
            guard let messagesSnapshot = messagesSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for theMessage in messagesSnapshot {
                let messageDict = theMessage.value
                let message = Message(key: theMessage.key, dictionary: messageDict as! [String : Any])
                messagesArray.append(message)
            }
            handler(messagesArray)
        }
    }
    
    
    func getUsernameFromUID(forUID uid: String, handler: @escaping (_ username: String) -> ()) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (userSnapshot) in
            let userName = userSnapshot.childSnapshot(forPath: "username").value as! String
            handler(userName)
        }
    }
    
    func getAllUsernames( handler: @escaping (_ usernameArray: [Users]) -> ()) {
        
        let currentUserID = Auth.auth().currentUser?.uid
        
        // This goes over all the usernames and gets the query without the currentUser username
        var userArray = [Users]()
        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                
                if user.key != currentUserID {
                    let userDict = user.value as? [String : AnyObject] ?? [:]
                    let thisUser = Users(uid: user.key, dictionary: userDict)
                    userArray.append(thisUser)
                }
            }
            handler(userArray)
        }
    }
    
    func getUsernameQuery(forSearchQuery query: String, handler: @escaping (_ usernameArray: [Users]) -> ()) {
        
        let currentUserID = Auth.auth().currentUser?.uid
        
        // This goes over all the usernames and gets the query without the currentUser username
        var userArray = [Users]()
        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                
                let username = user.childSnapshot(forPath: "username").value as! String
                if username.contains(query) && user.key != currentUserID {
                    let userDict = user.value as? [String : AnyObject] ?? [:]
                    let thisUser = Users(uid: user.key, dictionary: userDict)
                    userArray.append(thisUser)
                }
            }
            handler(userArray)
        }
    }
    
    func getUIDs(forUsername username: [String], handler: @escaping (_ uidArray: [String]) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            var uidArray = [String]()
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                let theUsername = user.childSnapshot(forPath: "username").value as! String
                if username.contains(theUsername) {
                    uidArray.append(user.key)
                }
            }
            handler(uidArray)
        }
    }
    
    func getUserData(handler: @escaping (_ theUser: Users?) -> ()) {
        if Auth.auth().currentUser != nil {
            guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
            DataService.instance.REF_USERS.child(currentUserUID).observe(.value) { (userDataSnapshot) in
                if let userData = userDataSnapshot.value as? [String : Any] {
                    let user = Users(uid: currentUserUID , dictionary: userData)
                    handler(user)
                }
            }
        }
    }
    
    
}
