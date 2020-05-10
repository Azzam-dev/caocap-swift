//
//  ChatVC.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 17/01/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit
import Firebase

class ChatVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    @IBOutlet weak var chatsTableView: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    var chatsArray = [Chat]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tableViewtopCellNib = UINib(nibName: "topTableCell", bundle: nil)
        self.chatsTableView.register(tableViewtopCellNib, forCellReuseIdentifier: "topTableCell")
        
        groupMembersSearchTF.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        groupIMG.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeGroupImage)))
        
    
        contactSearchTF.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getChatsData()
    }
    
    
    //This pulls all the current user chats from firebase and insert them to the chats array
    func getChatsData() {
        DataService.instance.getCurrentUserChats(handler: { (returnedChatArray) in
            self.chatsArray = returnedChatArray
            self.chatsTableView.reloadData()
        })
    }
    
    
     //this uses the textfield to search
    @objc func  textFieldDidChange() {
        // search current user chats
        if searchTF.text == "" {
            DataService.instance.getCurrentUserChats(handler: { (returnedChatArray) in
                print("@@@ \(returnedChatArray)")
                self.chatsArray = returnedChatArray
                self.chatsTableView.reloadData()
            })
        } else {
            DataService.instance.getCurrentUserChatsQuery(forSearchQuery: searchTF.text!) { (returnedChatArray) in
                self.chatsArray = returnedChatArray
                self.chatsTableView.reloadData()
            }
        }
        
        // search in group Members Array
        if groupMembersSearchTF.text == "" {
            DataService.instance.getAllUsernames(handler: { (returnedGroupMembersArray) in
                self.groupMembersSearchArray = returnedGroupMembersArray
                self.groupMembersTableView.reloadData()
            })
        } else {
            DataService.instance.getUsernameQuery(forSearchQuery: groupMembersSearchTF.text!) { (returnedGroupMembersArray) in
                self.groupMembersSearchArray = returnedGroupMembersArray
                self.groupMembersTableView.reloadData()
            }
        }
        
        // search in contact Array
        if contactSearchTF.text == "" {
            DataService.instance.getAllUsernames(handler: { (returnedContactsArray) in
                self.contactSearchArray = returnedContactsArray
                self.contactTableView.reloadData()
            })
        } else {
            DataService.instance.getUsernameQuery(forSearchQuery: contactSearchTF.text!) { (returnedContactsArray) in
                self.contactSearchArray = returnedContactsArray
                self.contactTableView.reloadData()
            }
        }
        
    }
 
    
    @IBAction func addChatBTN(_ sender: Any) {
        let createNewPopup = UIAlertController(title: "create", message: "What do you want to create?", preferredStyle: .actionSheet)
        let newGroupAct = UIAlertAction(title: "group", style: .default) { (buttonTapped) in
            self.groupPopupViewACTs(self)
        }
        let newContactAct = UIAlertAction(title: "contact", style: .default) { (buttonTapped) in
            self.contactPopupViewACTs(self)
        }
        let cancel = UIAlertAction(title: "cancel", style: .destructive , handler: nil)
        
        createNewPopup.addAction(newContactAct)
        createNewPopup.addAction(newGroupAct)
        createNewPopup.addAction(cancel)
        
        if let popoverPresentationController = createNewPopup.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverPresentationController.permittedArrowDirections = []
        }
        self.present(createNewPopup, animated: true , completion: nil)
        
    }
    
    @IBOutlet weak var groupPopupView: DesignableView!
    @IBOutlet weak var contactPopupView: DesignableView!
    @IBOutlet weak var blurredView: UIVisualEffectView!
    @IBOutlet weak var cancelPopupsBTN: UIButton!
    
    // contact
    var contactSearchArray = [Users]()
    
    @IBOutlet weak var contactTableView: UITableView!
    @IBOutlet weak var contactSearchTF: UITextField!
    
    //This shows and hides the new contact popuo view
    @IBAction func contactPopupViewACTs(_ sender: Any) {
        if cancelPopupsBTN.isHidden {
            cancelPopupsBTN.isHidden = false
            contactPopupView.isHidden = false
            blurredView.isHidden = false
            UIView.animate(withDuration: 0.3 , animations: {
                self.blurredView.alpha = 1
                self.view.layoutIfNeeded()
            }, completion: {(finished:Bool) in
                UIView.animate(withDuration: 0.3 , animations: {
                    self.contactPopupView.alpha = 1
                    self.view.layoutIfNeeded()
                })
            })
        } else {
            UIView.animate(withDuration: 0.3 , animations: {
                self.blurredView.alpha = 0
                self.view.layoutIfNeeded()
            }, completion: {(finished:Bool) in
                UIView.animate(withDuration: 0.3 , animations: {
                    self.contactPopupView.alpha = 0
                    self.view.layoutIfNeeded()
                }, completion: {(finished:Bool) in
                    self.cancelPopupsBTN.isHidden = true
                    self.contactPopupView.isHidden = true
                    self.blurredView.isHidden = true
                })
            })
        }
    }
    
    // group
    
    @IBOutlet weak var groupIMGview: DesignableView!
    @IBOutlet weak var groupIMG: DesignableImage!
    let colorArray = [#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.6391159892, blue: 0, alpha: 1), #colorLiteral(red: 0.3846503198, green: 1, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1), #colorLiteral(red: 0.8861780167, green: 0, blue: 1, alpha: 1), #colorLiteral(red: 0.9175696969, green: 0.9176983237, blue: 0.9175290465, alpha: 1)]
    
    var groupMembersSearchArray = [Users]()
    var groupSelectedMembersArray = [String]()
    
    @IBOutlet weak var groupMembersTableView: UITableView!
    @IBOutlet weak var groupMembersSearchTF: UITextField!
    //@IBOutlet weak var groupMembersLBL: UILabel!
    @IBOutlet weak var groupNameTF: UITextField!
    
    var groupColorSelectedIndex: Int = Int.random(in: 0 ... 5)
    
    @IBOutlet var groupConstraintsArray: [NSLayoutConstraint]!
    @IBOutlet var groupColorBTNs: [UIButton]!
    @IBAction func groupColorBTNpressed(_ sender: UIButton) {
        
        let previousColorIndex = groupColorSelectedIndex
        groupColorSelectedIndex = sender.tag
        let previousConstraint = groupConstraintsArray[previousColorIndex]
        let selectedConstraint = groupConstraintsArray[groupColorSelectedIndex]
        UIView.animate(withDuration: 0.3 , animations: {
            previousConstraint.constant = 15
            selectedConstraint.constant = 20
            self.groupIMGview.borderColor = self.colorArray[self.groupColorSelectedIndex]
            self.view.layoutIfNeeded()
        }, completion: {(finished:Bool) in
            
        })
        
    }
    
    //This shows and hides the new group popuo view
    @IBAction func groupPopupViewACTs(_ sender: Any) {
        if cancelPopupsBTN.isHidden {
            cancelPopupsBTN.isHidden = false
            groupPopupView.isHidden = false
            blurredView.isHidden = false
            UIView.animate(withDuration: 0.3 , animations: {
                self.blurredView.alpha = 1
                self.view.layoutIfNeeded()
            }, completion: {(finished:Bool) in
                UIView.animate(withDuration: 0.3 , animations: {
                    self.groupPopupView.alpha = 1
                    self.view.layoutIfNeeded()
                })
            })
        } else {
            UIView.animate(withDuration: 0.3 , animations: {
                self.blurredView.alpha = 0
                self.view.layoutIfNeeded()
            }, completion: {(finished:Bool) in
                UIView.animate(withDuration: 0.3 , animations: {
                    self.groupPopupView.alpha = 0
                    self.view.layoutIfNeeded()
                }, completion: {(finished:Bool) in
                    self.cancelPopupsBTN.isHidden = true
                    self.groupPopupView.isHidden = true
                    self.blurredView.isHidden = true
                })
            })
        }
    }
    
    @IBOutlet weak var createGroupBTN: UIButton!
    @IBAction func createGroupBTN(_ sender: Any) {
        if groupNameTF.text == "" {
            displayAlertMessage(messageToDisplay: "فضلا حدد اسم للمجموعة")
        } else {
            DataService.instance.getUIDs(forUsername: groupSelectedMembersArray) { (idsArray) in
                var members = idsArray
                members.append((Auth.auth().currentUser?.uid)!)
                let imageNameUID = NSUUID().uuidString
                let storageRef = DataService.instance.REF_GROUP_IMAGES.child("\(imageNameUID).jpeg")
                if let uploadData = self.groupIMG.image?.jpegData(compressionQuality: 0.2) {
                    
                    storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                        
                        if error != nil { print(error!) }
                        
                        storageRef.downloadURL(completion: { url, error in
                            if error != nil { print(error!) } else {
                                // Here you can get the download URL
                                let groupData = ["imageURL": url?.absoluteString,
                                                 "color": self.groupColorSelectedIndex,
                                                 "name" : self.groupNameTF.text!,
                                                 "members": members,
                                                 "type" : "group" ] as [String : Any]
                                
                                DataService.instance.createChat(chatData: groupData , handler: { (chatCreated) in
                                    if chatCreated {
                                        self.dismiss(animated: true, completion: nil)
                                        //send the user to the new chat
                                    }
                                })
                            }
                        })
                    })
                }
            }
        }
    }
    
    
    //this code is for changing the group image
    
    @objc func changeGroupImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
           groupIMG.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    //this is a function to display alert messages , you have to provide the message
    func displayAlertMessage(messageToDisplay: String) {
    let alertController = UIAlertController(title: "عذراً", message: messageToDisplay, preferredStyle: .alert)
    
    let OKAction = UIAlertAction(title: "حسناً", style: .default) { (action:UIAlertAction!) in
    
    // Code in this block will trigger when OK button tapped.
    print("Ok button tapped")
    
    }
    
    alertController.addAction(OKAction)
    
    self.present(alertController, animated: true, completion:nil)
    }
    
    
}

extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == chatsTableView {
        return chatsArray.count + 1
        } else if tableView == groupMembersTableView {
           return  groupMembersSearchArray.count
        } else {
            return contactSearchArray.count
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == chatsTableView {
            if indexPath.row == 0 {
                //this is the TOP Empty Cell
                let cell = chatsTableView.dequeueReusableCell(withIdentifier: "topTableCell" , for: indexPath ) as! topTableCell
                cell.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                return cell
                
            } else {
                let chat = chatsArray[indexPath.row - 1]
                if chat.type == "contact" {
                    guard let cell = chatsTableView.dequeueReusableCell(withIdentifier: "contactChatCell", for: indexPath) as? contactChatCell else { return UITableViewCell() }
                    
                    //This recognizes the contact UID by getting the current user UID and filtering it from the members array
                    //than uses the contactUID to get his data to fill the cell
                    if let currentUserUID = Auth.auth().currentUser?.uid {
                        let contactUID = chat.members.filter({ $0 != currentUserUID })
                        DataService.instance.REF_USERS.child(contactUID[0]).observeSingleEvent(of: .value, with: { (userDataSnapshot) in
                            // Get user value
                            if let userData = userDataSnapshot.value as? [String : Any] {
                                let user = Users(uid: currentUserUID , dictionary: userData)
                                
                                if let url = URL(string: user.imageURL ?? "" ) {
                                    ImageService.getImage(withURL: url) { (returnedImage) in
                                        cell.configureCell(chatIMG: returnedImage!, chatColor: user.color, chatName: user.username, lastMessage: chat.messages.last! , numberOfMessages: chat.messages.count , lastMessageTime: "\(Int.random(in: 1 ... 12)):\(Int.random(in: 10 ... 60)) AM")
                                    }
                                } else {
                                    cell.configureCell(chatIMG: #imageLiteral(resourceName: "caocap app icon"), chatColor: user.color, chatName: user.username, lastMessage: chat.messages.last! , numberOfMessages: chat.messages.count , lastMessageTime: "\(Int.random(in: 1 ... 12)):\(Int.random(in: 10 ... 60)) AM")
                                }
                            }
                            
                        }) { (error) in
                            print(error.localizedDescription)
                        }
                    }
                    return cell
                    
                } else if chat.type == "group" {
                    guard let cell = chatsTableView.dequeueReusableCell(withIdentifier: "chatGroupCell", for: indexPath) as? chatGroupCell else { return UITableViewCell() }
                    //This takes the image URL returnes the image
                    if let url = URL(string: chat.imageURL ?? "" ) {
                        ImageService.getImage(withURL: url) { (returnedImage) in
                            
                            cell.configureCell(chatIMG: returnedImage!, chatColor: chat.color, chatName: chat.name, lastSender: "itsNoOne", lastMessage: chat.messages.last! , numberOfMessages: chat.messages.count , lastMessageTime: "\(Int.random(in: 1 ... 12)):\(Int.random(in: 10 ... 60)) AM")
                        }
                    } else {
                        //this is used if the image did not return
                        cell.configureCell(chatIMG: #imageLiteral(resourceName: "IMG_2235"), chatColor: chat.color, chatName: chat.name, lastSender: "itsNoOne", lastMessage: chat.messages.last! , numberOfMessages: chat.messages.count , lastMessageTime: "\(Int.random(in: 1 ... 12)):\(Int.random(in: 10 ... 60)) AM")
                    }
                    return cell
                    
                } else {
                    guard let cell = chatsTableView.dequeueReusableCell(withIdentifier: "caocapGroupCell", for: indexPath) as? caocapGroupCell else { return UITableViewCell() }
                    
                    //This takes the image URL returnes the image
                    if let url = URL(string: chat.imageURL ?? "" ) {
                        ImageService.getImage(withURL: url) { (returnedImage) in
                            
                            cell.configureCell(chatIMG: returnedImage!, chatColor: chat.color, chatName: chat.name, lastSender: "itsNoOne", lastMessage: chat.messages.last! , numberOfMessages: chat.messages.count , lastMessageTime: "\(Int.random(in: 1 ... 12)):\(Int.random(in: 10 ... 60)) AM")
                        }
                    } else {
                        //this is used if the image did not return
                        cell.configureCell(chatIMG: #imageLiteral(resourceName: "IMG_2235"), chatColor: chat.color, chatName: chat.name, lastSender: "itsNoOne", lastMessage: chat.messages.last! , numberOfMessages: chat.messages.count , lastMessageTime: "\(Int.random(in: 1 ... 12)):\(Int.random(in: 10 ... 60)) AM")
                    }
                    return cell
                }
            }
        } else if tableView == groupMembersTableView {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "addUserCell") as? addUserCell else { return UITableViewCell() }
            
            if let url = URL(string: groupMembersSearchArray[indexPath.row].imageURL ?? "" ) {
                ImageService.getImage(withURL: url) { (returnedImage) in
                    if self.groupSelectedMembersArray.contains(self.groupMembersSearchArray[indexPath.row].username) {
                        
                        cell.configureCell(profileIMG:  returnedImage!,
                                           profileColor: self.groupMembersSearchArray[indexPath.row].color,
                                           username: self.groupMembersSearchArray[indexPath.row].username,
                                           name: self.groupMembersSearchArray[indexPath.row].name,
                                           isSelected: true)
                    } else {
                        cell.configureCell(profileIMG:  returnedImage!,
                                           profileColor: self.groupMembersSearchArray[indexPath.row].color,
                                           username: self.groupMembersSearchArray[indexPath.row].username,
                                           name: self.groupMembersSearchArray[indexPath.row].name,
                                           isSelected: false)
                    }
                }
            } else {
                if self.groupSelectedMembersArray.contains(self.groupMembersSearchArray[indexPath.row].username) {
                    
                    cell.configureCell(profileIMG:  #imageLiteral(resourceName: "caocap app icon"),
                                       profileColor: self.groupMembersSearchArray[indexPath.row].color,
                                       username: self.groupMembersSearchArray[indexPath.row].username,
                                       name: self.groupMembersSearchArray[indexPath.row].name,
                                       isSelected: true)
                } else {
                    cell.configureCell(profileIMG:  #imageLiteral(resourceName: "caocap app icon"),
                                       profileColor: self.groupMembersSearchArray[indexPath.row].color,
                                       username: self.groupMembersSearchArray[indexPath.row].username,
                                       name: self.groupMembersSearchArray[indexPath.row].name,
                                       isSelected: false)
                }
            }
            
            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "contactUserCell") as? contactUserCell else { return UITableViewCell() }
            
            if let url = URL(string: contactSearchArray[indexPath.row].imageURL ?? "" ) {
                ImageService.getImage(withURL: url) { (returnedImage) in
                    cell.configureCell(profileIMG: returnedImage!,
                                       profileColor: self.contactSearchArray[indexPath.row].color,
                                       username: self.contactSearchArray[indexPath.row].username,
                                       name: self.contactSearchArray[indexPath.row].name)
                }
            } else {
                cell.configureCell(profileIMG: #imageLiteral(resourceName: "caocap app icon"),
                                   profileColor: self.contactSearchArray[indexPath.row].color,
                                   username: self.contactSearchArray[indexPath.row].username,
                                   name: self.contactSearchArray[indexPath.row].name)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == chatsTableView {
            if indexPath.row != 0 {
                let chat = chatsArray[indexPath.row - 1]
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if chat.type == "contact" {
                    let contactChatVC = storyboard.instantiateViewController(withIdentifier: "ContactChatVC") as! ContactChatVC
                    contactChatVC.opendChat = chat
                    navigationController?.pushViewController(contactChatVC, animated: true)
                } else if chat.type == "group" {
                    let groupChatVC = storyboard.instantiateViewController(withIdentifier: "GroupChatVC") as! GroupChatVC
                    groupChatVC.opendChat = chat
                    navigationController?.pushViewController(groupChatVC, animated: true)
                } else {
                    
                }
            }
        } else if tableView == groupMembersTableView {
            guard let cell = tableView.cellForRow(at: indexPath) as? addUserCell else { return }
            if !groupSelectedMembersArray.contains(cell.usernameLBL.text!) {
                groupSelectedMembersArray.append(cell.usernameLBL.text!)
                //groupMembersLBL.text = groupSelectedMembersArray.joined(separator: ", ")
                createGroupBTN.isHidden = false
            } else {
                groupSelectedMembersArray = groupSelectedMembersArray.filter({ $0 != cell.usernameLBL.text! })
                if groupSelectedMembersArray.count >= 1 {
                    //groupMembersLBL.text = groupSelectedMembersArray.joined(separator: ", ")
                } else {
                    //groupMembersLBL.text = "add users to group"
                    createGroupBTN.isHidden = true
                }
            }
        } else {
            guard let cell = tableView.cellForRow(at: indexPath) as? contactUserCell else { return }
            
            DataService.instance.getUIDs(forUsername: [cell.usernameLBL.text!]) { (idsArray) in
                var userIds = idsArray
                userIds.append((Auth.auth().currentUser?.uid)!)
                DataService.instance.createNewContact(withUserIDs: userIds, andChatType: "contact", handler: { (newContactCreated) in
                    if newContactCreated {
                        self.dismiss(animated: true, completion: nil)
                        //send the user to the new chat
                    } else {
                        print("GRoup could not be created , Please try again.")
                    }
                })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == chatsTableView {
            if indexPath.row == 0 { return 45 } else { return 80 }
        } else {
            //this is for the members table views
            return 60
        }
    }

}
