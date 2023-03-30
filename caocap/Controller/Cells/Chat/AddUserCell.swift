//
//  AddUserCell.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 02/02/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit

class AddUserCell: UITableViewCell {
    
    
    @IBOutlet weak var profileIMG: DesignableImage!
    @IBOutlet weak var profileIMGview: DesignableView!
    @IBOutlet weak var usernameLBL: UILabel!
    @IBOutlet weak var nameLBL: UILabel!
    @IBOutlet weak var checkView: DesignableView!
    @IBOutlet weak var checkIMG: UIImageView!
    let colorArray = [#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.6391159892, blue: 0, alpha: 1), #colorLiteral(red: 0.3846503198, green: 1, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1), #colorLiteral(red: 0.8861780167, green: 0, blue: 1, alpha: 1), #colorLiteral(red: 0.9175696969, green: 0.9176983237, blue: 0.9175290465, alpha: 1)]
    
    
    func configureCell(user: User, isSelected: Bool) {
        
        if let imageURL = URL(string: user.imageURL ?? "") {
            profileIMG.af.setImage(withURL: imageURL)
        }
        
        if case 0...5 = user.color {
            profileIMGview.borderColor = colorArray[user.color]
        } else {
            profileIMGview.borderColor = colorArray[3]
        }
        usernameLBL.text = user.username
        nameLBL.text = user.name
        if isSelected {
            checkIMG.isHidden = false
            checkView.borderWidth = 0
            checkView.backgroundColor = #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1)
        } else {
            checkIMG.isHidden = true
            checkView.borderWidth = 1
            checkView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            if checkIMG.isHidden {
                checkIMG.isHidden = false
                checkView.borderWidth = 0
                checkView.backgroundColor = #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1)
            } else {
                checkIMG.isHidden = true
                checkView.borderWidth = 1
                checkView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
            }
        }
    }
    
}
