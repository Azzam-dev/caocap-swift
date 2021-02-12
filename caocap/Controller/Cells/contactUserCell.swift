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
    @IBOutlet weak var pofileIMGview: DesignableView!
    @IBOutlet weak var usernameLBL: UILabel!
    @IBOutlet weak var nameLBL: UILabel!
    
    let colorArray = [#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.6391159892, blue: 0, alpha: 1), #colorLiteral(red: 0.3846503198, green: 1, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1), #colorLiteral(red: 0.8861780167, green: 0, blue: 1, alpha: 1), #colorLiteral(red: 0.9175696969, green: 0.9176983237, blue: 0.9175290465, alpha: 1)]
    
    
    func configureCell(profileIMG image: UIImage , profileColor: Int , username: String , name: String ) {
        self.profileIMG.image = image
        if case 0...5 = profileColor {
            self.pofileIMGview.borderColor = colorArray[profileColor]
        } else {
            self.pofileIMGview.borderColor = colorArray[3]
        }
        self.usernameLBL.text = username
        self.nameLBL.text = name
        
    }
    
    
    
}
