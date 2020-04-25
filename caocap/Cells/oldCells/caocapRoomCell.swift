//
//  caocapRoomCell.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 02/04/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit

class caocapRoomCell: UITableViewCell {
    
    @IBOutlet weak var roomIMG: DesignableImage!
    @IBOutlet weak var roomIMGview: DesignableView!
    @IBOutlet weak var roomNameLBL: UILabel!
    @IBOutlet weak var bioLBL: UILabel!
    @IBOutlet weak var mambersLBL: UILabel!
    
    let colorArray = [#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.6391159892, blue: 0, alpha: 1), #colorLiteral(red: 0.3846503198, green: 1, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1), #colorLiteral(red: 0.8861780167, green: 0, blue: 1, alpha: 1), #colorLiteral(red: 0.9175696969, green: 0.9176983237, blue: 0.9175290465, alpha: 1)]
    
    func configureCell(roomIMG image: UIImage, roomColor color: Int, roomName name: String, roomBio bio: String, allmembers: Int, onlineMembers: Int) {
        
        self.roomIMG.image = image
        self.roomIMGview.borderColor = colorArray[color]
        self.roomNameLBL.text = name
        self.bioLBL.text = bio
        self.mambersLBL.text = "\(allmembers) members & \(onlineMembers) online"
        
        
    }
    
}
