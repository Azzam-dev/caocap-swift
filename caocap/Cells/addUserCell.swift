//
//  addUserCell.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 02/02/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit

class addUserCell: UITableViewCell {

    
    @IBOutlet weak var profileIMG: DesignableImage!
    @IBOutlet weak var pofileIMGview: DesignableView!
    @IBOutlet weak var usernameLBL: UILabel!
    @IBOutlet weak var nameLBL: UILabel!
    @IBOutlet weak var checkView: DesignableView!
    @IBOutlet weak var checkIMG: UIImageView!
    let colorArray = [#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.6391159892, blue: 0, alpha: 1), #colorLiteral(red: 0.3846503198, green: 1, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1), #colorLiteral(red: 0.8861780167, green: 0, blue: 1, alpha: 1), #colorLiteral(red: 0.9175696969, green: 0.9176983237, blue: 0.9175290465, alpha: 1)]
    
    
    func configureCell(profileIMG image: UIImage , profileColor: Int , username: String , name: String , isSelected: Bool) {
        self.profileIMG.image = image
        self.pofileIMGview.borderColor = colorArray[profileColor]
        self.usernameLBL.text = username
        self.nameLBL.text = name
        if isSelected {
            self.checkIMG.isHidden = false
            self.checkView.borderWidth = 0
            self.checkView.backgroundColor = #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1)
        } else {
            self.checkIMG.isHidden = true
            self.checkView.borderWidth = 1
            self.checkView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            if checkIMG.isHidden {
                self.checkIMG.isHidden = false
                self.checkView.borderWidth = 0
                self.checkView.backgroundColor = #colorLiteral(red: 0, green: 0.6544699669, blue: 1, alpha: 1)
            } else {
                self.checkIMG.isHidden = true
                self.checkView.borderWidth = 1
                self.checkView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
            }
        }
    }

}
