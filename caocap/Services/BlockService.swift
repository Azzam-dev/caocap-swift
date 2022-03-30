//
//  BlockService.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 27/06/2021.
//  Copyright © 2021 Ficruty. All rights reserved.
//

import UIKit

class BlockService {
    static let instance = BlockService()
    
    static let backgroundColorStyle = BlockStyle(title: "background color", description: "change the background color", type: .color, value: "#ffffffff")
    static let titleStyle = BlockStyle(title: "title text", description: "set a title", type: .text, value: "Hello Caocap")
    static let imageStyle = BlockStyle(title: "image", description: "add a image", type: .image, value: "")
    static let videoStyle = BlockStyle(title: "video", description: "add a video", type: .video, value: "")
    
    let blocks = [
        Block(type: .blank,
              description: "a blank view",
              styles: ["backgroundColor" : backgroundColorStyle],
              icon: UIImage(systemName: "doc")!),
        Block(type: .title,
              description: "a title view",
              styles: ["title": titleStyle,
                       "backgroundColor" : backgroundColorStyle],
              icon: UIImage(systemName: "textformat")!),
        
        Block(type: .image,
              description: "a image view",
              styles: ["image": imageStyle,
                       "backgroundColor" : backgroundColorStyle],
              icon: UIImage(systemName: "photo")!),
        
        Block(type: .image,
              description: "a video view",
              styles: ["video": videoStyle,
                       "backgroundColor" : backgroundColorStyle],
              icon: UIImage(systemName: "play.rectangle")!),
    ]
}
