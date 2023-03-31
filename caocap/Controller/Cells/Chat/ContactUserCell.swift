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
