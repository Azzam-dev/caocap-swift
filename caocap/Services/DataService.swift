//
//  DataService.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 18/01/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Alamofire
import AlamofireImage


let DB_BASE = Database.database().reference()
let STORAGE_BASE = Storage.storage().reference()

class DataService {
    static let instance = DataService()
    
    // DB references
    private var _REF_DB_BASE = DB_BASE
    private var _REF_APPDATA = DB_BASE.child("appData")
    private var _REF_MINIMUM_VERSION = DB_BASE.child("appData").child("minimumVersion-ios")
    private var _REF_REPAIRING = DB_BASE.child("appData").child("repairing")
    
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_CAOCAPS = DB_BASE.child("caocap")
    
    private var _REF_CHATS = DB_BASE.child("chats")
    
    
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
    
    func createCaocap(caocapData: Dictionary<String, Any> , handler: @escaping (_ createdCaocap: Caocap?) -> ()) {
        if let userUID = Auth.auth().currentUser?.uid {
            let caocapKey = REF_CAOCAPS.childByAutoId().key
            REF_CAOCAPS.child(caocapKey!).updateChildValues(caocapData)
            REF_USERS.child(userUID).child("caocaps").updateChildValues([caocapKey : caocapKey])
            handler(Caocap(key: caocapKey!, dictionary: caocapData))
        } else {
            handler(nil)
        }
    }
    
    func removeCaocap(_ key: String) {
        getUserData { (theUser) in
            guard let user = theUser else { return }
            if user.caocaps.values.contains(key) {
                // this removes the caocap from user data
                self.REF_USERS.child(user.uid).child("caocaps").child(key).removeValue()
                // this removes the caocap entirely
                self.REF_CAOCAPS.child(key).removeValue()
            }
        }
        
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
                REF_USERS.child(userUID).child("orbiting").updateChildValues([caocapKey : caocapKey])
            }
        }
    }
    
    func checkOrbiteStatus(caocapKey: String, handler: @escaping (_ status: Bool) -> ()) {
        if let userUID = Auth.auth().currentUser?.uid { REF_USERS.child(userUID).child("orbiting").child(caocapKey).child("key").observeSingleEvent(of: .value) { (key) in
                handler(key.exists())
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
    
    
    //TODO: - add firebase filter for getCurrentUserChats
    func getCurrentUserChats(handler: @escaping (_ chatsArray: [Chat]) -> ()) {
        let currentUserUID = (Auth.auth().currentUser?.uid)!
        REF_CHATS.observe(.value) { (chatSnapshot) in
            guard let chatSnapshot = chatSnapshot.children.allObjects as? [DataSnapshot] else { return }
            var chatsArray = [Chat]()
            for chat in chatSnapshot {
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
    
    //TODO: Refacter this function
    func getCurrentUserChatsQuery(forSearchQuery query: String, handler: @escaping (_ chatsQueryArray: [Chat]) -> ()) {
        var chatsQueryArray = [Chat]()
        let currentUserUID = (Auth.auth().currentUser?.uid)!
        getCurrentUserChats { chatsArray in
            for chat in chatsArray {
                switch chat.type {
                case .contact:
                    let contactUID = chat.members.filter({ $0 != currentUserUID })[0]
                    self.getUsernameFromUID(forUID: contactUID) { username in
                        if username.containsIgnoringCase(find: query) {
                            chatsQueryArray.append(chat)
                        }
                    }
                default:
                    if chat.name.containsIgnoringCase(find: query) {
                        chatsQueryArray.append(chat)
                    }
                }
            }
            
            handler(chatsQueryArray)
        }
    }
    
//TODO: Refacter this function
    func getCurrentUserCaocaps(handler: @escaping (_ caocapsArray: [Caocap]) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            self.REF_CAOCAPS.observe(.value) { (caocapsSnapshot) in
                var caocapsArray = [Caocap]()
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
        REF_CAOCAPS.observe(.value) { (caocapsSnapshot) in
            guard let caocapsSnapshot = caocapsSnapshot.children.allObjects as? [DataSnapshot] else { return }
            var caocapsArray = [Caocap]()
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
    
    func getCaocap(withKey key: String, handler: @escaping (_ caocap: Caocap) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            self.REF_CAOCAPS.child(key).observe(.value) { caocapSnapshot in
                guard let dictionary = caocapSnapshot.value as? [String : Any] else { return }
                let caocap = Caocap(key: caocapSnapshot.key, dictionary: dictionary)
                DispatchQueue.main.async {
                    handler(caocap)
                }
            }
        }
    }
    
    
    func getAllCaocaps(handler: @escaping (_ caocapsArray: [Caocap]) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            self.REF_CAOCAPS.observeSingleEvent(of: .value) { (caocapsSnapshot) in
                guard let caocapsSnapshot = caocapsSnapshot.children.allObjects as? [DataSnapshot] else { return }
                var caocapsArray = [Caocap]()
                for caocap in caocapsSnapshot {
                    let dictionary = caocap.value
                    let theCaocap = Caocap(key: caocap.key, dictionary: dictionary as! [String : Any] )
                    caocapsArray.append(theCaocap)
                }
                DispatchQueue.main.async {
                    handler(caocapsArray)
                }
            }
        }
    }

    func getMyOrbitingCaocaps(handler: @escaping (_ caocapsArray: [Caocap]) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            if let userUID = Auth.auth().currentUser?.uid {
                self.REF_USERS.child(userUID).child("orbiting").observe(.value) { (orbitSnapshot) in
                    guard let orbitSnapshot = orbitSnapshot.children.allObjects as? [DataSnapshot] else { return }
                    var orbitArray = [Caocap]()
                    for orbit in orbitSnapshot {
                        self.getCaocap(withKey: orbit.key) { caocap in
                            orbitArray.append(caocap)
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                        handler(orbitArray)
                   }
                    
                }
            }
            
        }
        
    }


                                                                                   
    
    
    func getAllPublishedCaocaps(handler: @escaping (_ caocapsArray: [Caocap]) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            let publishedCaocaps = self.REF_CAOCAPS.queryOrdered(byChild: "published").queryEqual(toValue: true)
            publishedCaocaps.observeSingleEvent(of: .value) { (caocapsSnapshot) in
                guard let caocapsSnapshot = caocapsSnapshot.children.allObjects as? [DataSnapshot] else { return }
                var caocapsArray = [Caocap]()
                for caocap in caocapsSnapshot {
                    let dictionary = caocap.value
                    let theCaocap = Caocap(key: caocap.key, dictionary: dictionary as! [String : Any] )
                    caocapsArray.append(theCaocap)
                }
                DispatchQueue.main.async {
                    handler(caocapsArray)
                }
            }
        }
    }
    
    func getCaocapsQuery(forSearchQuery query: String, handler: @escaping (_ caocapsArray: [Caocap]) -> ()) {
        // This goes over all the caocaps and gets the query
        let searchQuery = REF_CAOCAPS.queryOrdered(byChild: "name").queryStarting(atValue: query).queryEnding(atValue: (query+"\u{f8ff}"))
        
        searchQuery.observe(.value) { (caocapsSnapshot) in
            guard let caocapsSnapshot = caocapsSnapshot.children.allObjects as? [DataSnapshot] else { return }
            var caocapsArray = [Caocap]()
            for caocap in caocapsSnapshot {
                if let dictionary = caocap.value as? [String : Any] {
                    caocapsArray.append(Caocap(key: caocap.key, dictionary: dictionary))
                }
            }
            handler(caocapsArray)
        }
    }
    
    //this gets all the caocap room messages, You must provide the caocap key and you will get the messages array
    func getCaocapRoomMessages(forCaocapKey key: String, handler: @escaping (_ messagesArray: [Message]) -> ()) {
        REF_CAOCAPS.child(key).child("room").observe(.value) { (messagesSnapshot) in
            guard let messagesSnapshot = messagesSnapshot.children.allObjects as? [DataSnapshot] else { return }
            var messagesArray = [Message]()
            for message in messagesSnapshot {
                if let dictionary = message.value as? [String : Any] {
                    messagesArray.append(Message(key: message.key, dictionary: dictionary))
                }
            }
            handler(messagesArray)
        }
    }
    
    //this gets all the chat messages, You must provide the chat key and you will get the messages array
    func getChatMessages(forChatKey key: String, handler: @escaping (_ messagesArray: [Message]) -> ()) {
        REF_CHATS.child(key).child("messages").observe(.value) { (messagesSnapshot) in
            guard let messagesSnapshot = messagesSnapshot.children.allObjects as? [DataSnapshot] else { return }
            var messagesArray = [Message]()
            for message in messagesSnapshot {
                if let dictionary = message.value as? [String : Any] {
                messagesArray.append(Message(key: message.key, dictionary: dictionary))
                }
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
    
    func getAllUsers( handler: @escaping (_ usersArray: [User]) -> ()) {
        let currentUserUID = Auth.auth().currentUser?.uid
        // get all users without the current User
        REF_USERS.observe(.value) { (usersSnapshot) in
            guard let usersSnapshot = usersSnapshot.children.allObjects as? [DataSnapshot] else { return }
            var usersArray = [User]()
            for user in usersSnapshot {
                if user.key == currentUserUID { continue }
                if let dictionary = user.value as? [String : Any] {
                    usersArray.append(User(uid: user.key, dictionary: dictionary))
                }
            }
            handler(usersArray)
        }
    }
    
    func getUsernameQuery(forSearchQuery query: String, handler: @escaping (_ usernameArray: [User]) -> ()) {
        let currentUserUID = Auth.auth().currentUser?.uid
        let searchQuery = REF_USERS.queryOrdered(byChild: "username").queryStarting(atValue: query).queryEnding(atValue: (query+"\u{f8ff}"))
        
        searchQuery.observeSingleEvent(of: .value) { (searchSnapshot) in
            guard let usersSnapshot = searchSnapshot.children.allObjects as? [DataSnapshot] else { return }
            var userArray = [User]()
            for user in usersSnapshot {
                if user.key == currentUserUID { continue }
                if let dictionary = user.value as? [String : Any] {
                    userArray.append(User(uid: user.key, dictionary: dictionary))
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
    
    func getUserData(handler: @escaping (_ theUser: User?) -> ()) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        DataService.instance.REF_USERS.child(currentUserUID).observe(.value) { (userDataSnapshot) in
            if let userData = userDataSnapshot.value as? [String : Any] {
                let user = User(uid: currentUserUID , dictionary: userData)
                handler(user)
            }
        }
    }
    

}

