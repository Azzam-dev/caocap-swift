//
//  ContactUserCell.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 28/02/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit

class ContactUserCell: UITableViewCell {
    
    
    @IBOutlet weak var profileIMG: DesignableImage!
    @IBOutlet weak var profileIMGview: DesignableView!
    @IBOutlet weak var usernameLBL: UILabel!
    @IBOutlet weak var nameLBL: UILabel!
    
    let colorArray = [#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.6391159892, blue: 0, alpha: 1), #colorLiteral(red: 0.3846503198, green: 1, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1), #colorLiteral(red: 0.8861780167, green: 0, blue: 1, alpha: 1), #colorLiteral(red: 0.9175696969, green: 0.9176983237, blue: 0.9175290465, alpha: 1)]
    
    
    func configureCell(user: User ) {
        if let imageURL = URL(string: user.imageURL ?? "") {
            profileIMG.af.setImage(withURL: imageURL)
        }
        
        if case 0...5 = user.color {
            self.profileIMGview.borderColor = colorArray[user.color]
        } else {
            self.profileIMGview.borderColor = colorArray[3]
        }
        self.usernameLBL.text = user.username
        self.nameLBL.text = user.name
        
    }
    
    
    
}
